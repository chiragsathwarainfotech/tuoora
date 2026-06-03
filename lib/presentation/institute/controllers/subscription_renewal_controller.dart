import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/widgets/common_dialog.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';

class SubscriptionRenewalController extends GetxController {
  final InstituteRepositoryImpl _repository;
  final AuthService _authService = Get.find<AuthService>();

  SubscriptionRenewalController(this._repository);

  /// 0 = Scan UPI QR, 1 = Bank Details
  final selectedTab = 0.obs;

  final transactionIdController = TextEditingController();
  final messageController = TextEditingController();
  final screenshotPath = RxnString();

  final transactionIdError = RxnString();
  final screenshotError = RxnString();
  final isSubmitting = false.obs;

  final ImagePicker _picker = ImagePicker();

  void selectTab(int index) => selectedTab.value = index;

  Future<void> pickScreenshot() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        screenshotPath.value = image.path;
        screenshotError.value = null;
      }
    } catch (_) {
      AppSnackBar.error(AppStrings.errFailedPickImage);
    }
  }

  /// Shown after the user indicates the payment is done. Dismissing it leaves
  /// the user on the renewal screen, where the same action can be re-triggered.
  void promptForProof() {
    CommonDialog.show(
      title: AppStrings.labelSubmitPaymentProof,
      description:
          'Once you have completed the payment, submit your transaction '
          'details so our billing team can verify and activate your '
          'subscription.',
      icon: Icons.receipt_long_rounded,
      iconColor: AppColors.primaryBrand,
      iconBgColor: AppColors.primaryBrandLight,
      confirmText: AppStrings.submitDetails,
      cancelText: AppStrings.notYet,
      confirmButtonColor: AppColors.primaryBrand,
      onConfirm: () => Get.toNamed(AppRoutes.instituteSubmitPaymentProof),
    );
  }

  Future<void> submitProof() async {
    final transactionId = transactionIdController.text.trim();
    transactionIdError.value = null;
    screenshotError.value = null;

    var hasError = false;
    if (transactionId.isEmpty) {
      transactionIdError.value = 'Please enter the transaction ID';
      hasError = true;
    }
    if (screenshotPath.value == null) {
      screenshotError.value = 'Please upload the payment screenshot';
      hasError = true;
    }
    if (hasError) return;

    isSubmitting.value = true;
    try {
      await _repository.renewSubscription(
        transactionId: transactionId,
        screenshotPath: screenshotPath.value!,
        message: messageController.text,
      );

      // Reflect the pending state locally so the dashboard banner immediately
      // switches to "Renewal Request Pending Review".
      final current = _authService.subscription;
      if (current != null) {
        await _authService.setSubscription(current.copyWith(status: 'pending'));
      }

      AppSnackBar.success(
        AppStrings.yourRenewalRequestHasBeenSubmitted,
      );

      // Pop the proof + renewal screens back to the dashboard host (mounted
      // under either route name), falling back to the first route as a guard.
      Get.until(
        (route) =>
            route.settings.name == AppRoutes.instituteDashboard ||
            route.settings.name == AppRoutes.instituteMain ||
            route.isFirst,
      );
    } catch (e) {
      AppSnackBar.error(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    transactionIdController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
