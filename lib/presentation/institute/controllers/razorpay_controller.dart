import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/url_constants.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';

class RazorpayController extends GetxController {
  final InstituteRepositoryImpl _repository;

  RazorpayController(this._repository);

  Razorpay? _razorpay;
  bool _disposed = false;

  final isPurchasing = false.obs;
  final purchasingPlanId = Rx<int?>(null);

  int? _activePlanId;

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
    isPurchasing.value = true;
    purchasingPlanId.value = plan.id;

    try {
      final order = await _repository.createRazorpayOrder(planId: plan.id);

      final options = {
        'key': UrlConstants.razorpayKeyId,
        'amount': order['amount'],
        'currency': order['currency'] ?? 'INR',
        'order_id': order['order_id'],
        'name': 'Tuoora',
        'description': '${plan.name} · ${plan.durationDays} days',
        'theme': {'color': '#F97316'},
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

      if (!_disposed) AppSnackBar.success(AppStrings.iapPurchaseSuccess);
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
  }

  @override
  void onClose() {
    _disposed = true;
    _razorpay?.clear();
    super.onClose();
  }
}
