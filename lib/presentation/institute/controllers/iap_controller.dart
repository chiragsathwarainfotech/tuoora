import 'dart:async';
import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';
import 'package:tuoora/presentation/institute/widgets/subscription_success_dialog.dart';

class IAPController extends GetxController {
  final InstituteRepositoryImpl _repository;

  IAPController(this._repository);

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Worker? _productsWorker;
  bool _disposed = false;

  final isAvailable = false.obs;
  final isLoadingProducts = false.obs;
  final _products = <String, ProductDetails>{}.obs;
  final isPurchasing = false.obs;
  final purchasingPlanId = Rx<int?>(null);
  int? _activePlanId;
  SubscriptionPlan? _activePlan;

  // iOS only — Android uses Razorpay instead of Google Play Billing.
  static bool get _isSupported => Platform.isIOS;

  // "ios" or "android" — sent to backend so it uses the correct receipt path
  static String get _platform => Platform.isIOS ? 'ios' : 'android';

  ProductDetails? productForPlan(int planId) =>
      _products['com.tuoora.plan$planId'];

  @override
  void onInit() {
    super.onInit();
    if (!_isSupported) return;

    _purchaseSubscription = _iap.purchaseStream.listen(_onPurchaseUpdated);
    _initProducts();
  }

  Future<void> _initProducts() async {
    isAvailable.value = await _iap.isAvailable();

    // Guard: controller may have been disposed during the await
    if (_disposed || !isAvailable.value) return;

    try {
      final subCtrl = Get.find<InstituteSubscriptionController>();

      // React to future subscription data loads (e.g. after refresh)
      _productsWorker = ever(subCtrl.subscriptionData, (data) {
        if (_disposed) return;
        if (data != null && !isLoadingProducts.value && _products.isEmpty) {
          loadProductsForPlans(data.plans);
        }
      });

      // Handle data that already loaded before this controller started
      final existing = subCtrl.subscriptionData.value;
      if (existing != null) loadProductsForPlans(existing.plans);
    } catch (_) {
      // Dependency not yet available — Worker will trigger load when data arrives
    }
  }

  Future<void> loadProductsForPlans(List<SubscriptionPlan> plans) async {
    if (_disposed || !isAvailable.value) return;

    final activePlans = plans.where((p) => p.status == 1 && !p.isFree).toList();
    if (activePlans.isEmpty) return;

    isLoadingProducts.value = true;
    try {
      final ids = activePlans.map((p) => p.appleProductId).toSet();
      final response = await _iap.queryProductDetails(ids);

      if (_disposed) return;

      final map = <String, ProductDetails>{};
      for (final p in response.productDetails) {
        map[p.id] = p;
      }
      _products.assignAll(map);
    } finally {
      if (!_disposed) isLoadingProducts.value = false;
    }
  }

  Future<void> purchasePlan(SubscriptionPlan plan) async {
    if (_disposed || isPurchasing.value) return;

    final product = productForPlan(plan.id);
    if (product == null) {
      AppSnackBar.error(AppStrings.iapPlanUnavailable);
      return;
    }

    _activePlanId = plan.id;
    _activePlan = plan;
    isPurchasing.value = true;
    purchasingPlanId.value = plan.id;

    // buyConsumable allows re-purchasing the same product ID (needed for renewals)
    // Works identically on iOS (StoreKit) and Android (Google Play Billing)
    await _iap.buyConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    // State is reset inside _onPurchaseUpdated
  }

  /// Finalises a transaction with the store, guarded against the StoreKit
  /// plugin throwing (e.g. a null-check error in the Xcode StoreKit testing
  /// environment) so a completion failure never crashes the app.
  Future<void> _safeComplete(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) return;
    try {
      await _iap.completePurchase(purchase);
    } catch (_) {
      // Completion can fail in local/sandbox testing; ignore so the
      // purchase stream handler doesn't throw an unhandled exception.
    }
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          // Keep isPurchasing = true while the store processes the payment
          break;

        case PurchaseStatus.purchased:
          // 1. Verify with backend & activate subscription
          await _verifyAndActivate(purchase);
          // 2. Finalise the transaction with the store (required on both platforms)
          await _safeComplete(purchase);
          if (!_disposed) {
            isPurchasing.value = false;
            purchasingPlanId.value = null;
            _activePlanId = null;
            _activePlan = null;
          }

        case PurchaseStatus.error:
          AppSnackBar.error(
            purchase.error?.message ?? AppStrings.iapPurchaseFailed,
          );
          await _safeComplete(purchase);
          if (!_disposed) {
            isPurchasing.value = false;
            purchasingPlanId.value = null;
            _activePlanId = null;
            _activePlan = null;
          }

        case PurchaseStatus.canceled:
          if (!_disposed) {
            isPurchasing.value = false;
            purchasingPlanId.value = null;
            _activePlanId = null;
            _activePlan = null;
          }

        case PurchaseStatus.restored:
          // Finalise any previously incomplete transactions on app start
          await _safeComplete(purchase);
      }
    }
  }

  /// Sends transaction proof to the backend for server-side verification.
  ///
  /// iOS  → [receiptData] is the base64-encoded App Store receipt.
  /// Android → [receiptData] is the Google Play purchase token.
  /// The [platform] field lets the backend choose the correct verification path.
  Future<void> _verifyAndActivate(PurchaseDetails details) async {
    final planId = _activePlanId;
    final plan = _activePlan;
    if (planId == null) return;

    try {
      await _repository.verifyIapPurchase(
        planId: planId,
        transactionId: details.purchaseID ?? details.productID,
        receiptData: details.verificationData.serverVerificationData,
        platform: _platform,
      );

      // Refresh the subscription screen so the active plan card updates
      if (!_disposed && Get.isRegistered<InstituteSubscriptionController>()) {
        await Get.find<InstituteSubscriptionController>()
            .fetchSubscriptionData();
      }

      if (!_disposed && plan != null) {
        final expiresAt = Get.isRegistered<InstituteSubscriptionController>()
            ? Get.find<InstituteSubscriptionController>()
                .subscriptionData
                .value
                ?.subscription
                .expiresAt
            : null;
        SubscriptionSuccessDialog.show(
          planName: plan.name,
          addedDays: plan.durationDays,
          expiresAt: expiresAt,
        );
      } else if (!_disposed) {
        AppSnackBar.success(AppStrings.iapPurchaseSuccess);
      }
    } catch (_) {
      if (!_disposed) {
        AppSnackBar.error(AppStrings.iapActivationFailed);
      }
    }
  }

  @override
  void onClose() {
    _disposed = true;
    _productsWorker?.dispose();
    _purchaseSubscription?.cancel();
    super.onClose();
  }
}
