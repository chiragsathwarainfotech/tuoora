import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/url_constants.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/data/models/institute_profile_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';
import 'package:tuoora/presentation/institute/widgets/subscription_success_dialog.dart';

class RazorpayController extends GetxController {
  final InstituteRepositoryImpl _repository;

  RazorpayController(this._repository);

  Razorpay? _razorpay;
  bool _disposed = false;

  final isPurchasing = false.obs;
  final purchasingPlanId = Rx<int?>(null);

  int? _activePlanId;
  SubscriptionPlan? _activePlan;

  @override
  void onInit() {
    super.onInit();
    if (!Platform.isAndroid) return;

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> startPayment(SubscriptionPlan plan) async {
    if (_disposed || isPurchasing.value || _razorpay == null) return;

    _activePlanId = plan.id;
    _activePlan = plan;
    isPurchasing.value = true;
    purchasingPlanId.value = plan.id;

    try {
      final order = await _repository.createRazorpayOrder(planId: plan.id);

      InstituteProfile? profile;
      if (Get.isRegistered<InstituteProfileController>()) {
        final profileCtrl = Get.find<InstituteProfileController>();
        if (profileCtrl.profile.value == null) {
          await profileCtrl.fetchProfile();
        }
        profile = profileCtrl.profile.value;
      }

      final options = {
        'key': UrlConstants.razorpayKeyId,
        'amount': order['amount'],
        'currency': order['currency'] ?? 'INR',
        'order_id': order['order_id'],
        'name': 'Tuoora',
        'description': '${plan.name} · ${plan.durationDays} days',
        'theme': {'color': '#F97316'},
        'prefill': {
          if (profile?.name.isNotEmpty == true) 'name': profile!.name,
          if (profile?.phone.isNotEmpty == true) 'contact': profile!.phone,
          if (profile?.email.isNotEmpty == true) 'email': profile!.email,
        },
      };

      _razorpay!.open(options);
    } catch (e) {
      _resetState();
      final msg = e.toString().replaceFirst('Exception: ', '');
      AppSnackBar.error(msg.isNotEmpty ? msg : AppStrings.iapPlanUnavailable);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final planId = _activePlanId;
    final plan = _activePlan;
    if (planId == null) return;

    try {
      await _repository.verifyRazorpayPayment(
        planId: planId,
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );

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
      if (!_disposed) AppSnackBar.error(AppStrings.iapActivationFailed);
    } finally {
      _resetState();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!_disposed && response.code != Razorpay.PAYMENT_CANCELLED) {
      AppSnackBar.error(response.message ?? AppStrings.iapPurchaseFailed);
    }
    _resetState();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _resetState();
  }

  void _resetState() {
    if (!_disposed) {
      isPurchasing.value = false;
      purchasingPlanId.value = null;
    }
    _activePlanId = null;
    _activePlan = null;
  }

  @override
  void onClose() {
    _disposed = true;
    _razorpay?.clear();
    super.onClose();
  }
}
