import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_network_image.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/widgets/subscription_manage_on_web_view.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';
import 'package:tuoora/presentation/institute/controllers/subscription_renewal_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';

class SubscriptionRenewalScreen extends GetView<SubscriptionRenewalController> {
  const SubscriptionRenewalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              InstituteAppBar(
                title: AppStrings.offlineSubscriptionRenewal,
                onBackTap: () => Get.back(),
              ),
              const Expanded(child: SubscriptionManageOnWebView()),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.offlineSubscriptionRenewal,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPaddingTop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.payUsingTheDetailsBelowThen,
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                        height: 1.5,
                      ),
                    ),
                    AppSpacing.v24,
                    _buildTabSelector(),
                    AppSpacing.v24,
                    Obx(
                      () => controller.selectedTab.value == 0
                          ? _buildQrTab()
                          : _buildBankTab(),
                    ),
                    AppSpacing.v32,
                    SafeArea(
                      top: false,
                      minimum: const EdgeInsets.only(bottom: 16),
                      child: AppButton(
                        label: AppStrings.iVeCompletedPayment,
                        onPressed: controller.promptForProof,
                        icon: Icons.check_circle_outline_rounded,
                        backgroundColor: AppColors.primaryBrand,
                        foregroundColor: AppColors.white,
                        borderRadius: AppSpacing.cardRadius,
                        fontSize: 16,
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: AppSpacing.all4,
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabButton('Scan UPI QR', 0),
            _buildTabButton('Bank Details', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.s6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? AppColors.primaryBrand
                  : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: AppSpacing.s24,
            offset: const Offset(0, AppSpacing.s12),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildQrTab() {
    return _buildCard(
      child: Obx(() {
        final qrUrl = _paymentSettings()?.qrUrl;
        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: qrUrl != null && qrUrl.isNotEmpty
                    ? AppNetworkImage(
                        url: qrUrl,
                        fit: BoxFit.contain,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadius,
                        ),
                        errorWidget: _qrPlaceholder(),
                      )
                    : _qrPlaceholder(),
              ),
            ),
            AppSpacing.v16,
            Text(
              AppStrings.studentPayFeesScanWith,
              style: AppTextStyles.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.brandAppBarColor,
                letterSpacing: 1.0,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _qrPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.qr_code_2_rounded,
            size: AppSpacing.s64,
            color: AppColors.textMuted,
          ),
          AppSpacing.v8,
          Text(
            AppStrings.qrCodeWillAppearHere,
            style: AppTextStyles.outfit(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankTab() {
    return _buildCard(
      child: Obx(() {
        final p = _paymentSettings();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.bankTransferDetails,
              style: AppTextStyles.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.brandAppBarColor,
                letterSpacing: 1.0,
              ),
            ),
            AppSpacing.v16,
            _buildBankRow('Holder', p?.bankHolderName ?? '—'),
            _buildBankRow('Bank', p?.bankName ?? '—'),
            _buildBankRow('A/C No', p?.bankAccount ?? '—'),
            _buildBankRow('IFSC', p?.bankIfsc ?? '—', isLast: true),
          ],
        );
      }),
    );
  }

  SubscriptionPaymentSettings? _paymentSettings() {
    if (!Get.isRegistered<InstituteSubscriptionController>()) return null;
    return Get.find<InstituteSubscriptionController>()
        .subscriptionData
        .value
        ?.paymentSettings;
  }

  Widget _buildBankRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              AppSnackBar.success('$label copied');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.h8,
                const Icon(
                  Icons.copy_rounded,
                  size: AppSpacing.s16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
