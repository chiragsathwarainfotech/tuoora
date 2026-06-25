import 'dart:async';
import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';

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
  int? _activePlanId;

  ProductDetails? productForPlan(int planId) =>
      _products['com.tuoora.plan$planId'];

  @override
  void onInit() {
    super.onInit();
    if (!Platform.isIOS) return;

    _purchaseSubscription = _iap.purchaseStream.listen(_onPurchaseUpdated);
    _initProducts();
  }

  Future<void> _initProducts() async {
    isAvailable.value = await _iap.isAvailable();

    // Guard: controller may have been disposed while awaiting
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
      // Dependency not yet available — products will load via the Worker
      // once InstituteSubscriptionController is registered.
    }
  }

  Future<void> loadProductsForPlans(List<SubscriptionPlan> plans) async {
    if (_disposed || !Platform.isIOS || !isAvailable.value) return;

    final activePlans = plans.where((p) => p.status == 1).toList();
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
    isPurchasing.value = true;

    // buyConsumable allows buying the same product ID again (needed for renewals)
    await _iap.buyConsumable(purchaseParam: PurchaseParam(productDetails: product));
    // State is reset inside _onPurchaseUpdated
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          // Keep isPurchasing = true while Apple processes the payment
          break;

        case PurchaseStatus.purchased:
          // 1. Verify with backend & activate subscription
          await _verifyAndActivate(purchase);
          // 2. Finalise the transaction with StoreKit
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          if (!_disposed) {
            isPurchasing.value = false;
            _activePlanId = null;
          }

        case PurchaseStatus.error:
          AppSnackBar.error(
            purchase.error?.message ?? AppStrings.iapPurchaseFailed,
          );
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          if (!_disposed) {
            isPurchasing.value = false;
            _activePlanId = null;
          }

        case PurchaseStatus.canceled:
          if (!_disposed) {
            isPurchasing.value = false;
            _activePlanId = null;
          }

        case PurchaseStatus.restored:
          // Finalise any previously incomplete transactions on app start
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
      }
    }
  }

  /// Task 3 — Purchase Verification & Backend Processing:
  /// 1. Captures transaction ID and base64 receipt from StoreKit.
  /// 2. POSTs to /institute/subscription/iap-verify.
  /// 3. Backend verifies with Apple and activates the subscription.
  /// 4. Refreshes local subscription state and updates AuthService.
  Future<void> _verifyAndActivate(PurchaseDetails details) async {
    final planId = _activePlanId;
    if (planId == null) return;

    try {
      await _repository.verifyIapPurchase(
        planId: planId,
        // Unique Apple transaction identifier
        transactionId: details.purchaseID ?? details.productID,
        // Base64-encoded App Store receipt for server-side verification
        receiptData: details.verificationData.serverVerificationData,
      );

      // Refresh subscription data so the active plan card updates immediately
      if (!_disposed && Get.isRegistered<InstituteSubscriptionController>()) {
        await Get.find<InstituteSubscriptionController>()
            .fetchSubscriptionData();
      }

      if (!_disposed) {
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
