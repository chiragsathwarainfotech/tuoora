import 'dart:io';

import 'package:tuoora/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/presentation/institute/controllers/subscription_renewal_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';

class SubmitPaymentProofScreen extends GetView<SubscriptionRenewalController> {
  const SubmitPaymentProofScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.labelSubmitPaymentProof,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPaddingTop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.enterYourTransactionDetailsSoOur,
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                        height: 1.5,
                      ),
                    ),
                    AppSpacing.v24,
                    Obx(
                      () => AppInputField(
                        label: AppStrings.transactionIdRefNumber,
                        hint: AppStrings.enterUtrRefNoOrTxn,
                        controller: controller.transactionIdController,
                        icon: Icons.tag_rounded,
                        labelFontSize: 12,
                        labelLetterSpacing: 1.0,
                        errorText: controller.transactionIdError.value,
                      ),
                    ),
                    AppSpacing.v24,
                    _buildScreenshotPicker(),
                    AppSpacing.v24,
                    AppInputField(
                      label: AppStrings.messageOptional,
                      hint: AppStrings.enterAnySpecificNote,
                      controller: controller.messageController,
                      maxLines: 3,
                      labelFontSize: 12,
                      labelLetterSpacing: 1.0,
                    ),
                    AppSpacing.v32,
                    SafeArea(
                      top: false,
                      minimum: const EdgeInsets.only(bottom: 16),
                      child: Obx(
                        () => AppButton(
                          label: AppStrings.submitProof,
                          onPressed: controller.submitProof,
                          isLoading: controller.isSubmitting.value,
                          backgroundColor: AppColors.primaryBrand,
                          foregroundColor: AppColors.white,
                          borderRadius: AppSpacing.cardRadius,
                          fontSize: 16,
                          fullWidth: true,
                        ),
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

  Widget _buildScreenshotPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.paymentScreenshot,
          style: AppTextStyles.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
            letterSpacing: 1.0,
          ),
        ),
        AppSpacing.v8,
        Obx(() {
          final path = controller.screenshotPath.value;
          final hasError = controller.screenshotError.value != null;
          return GestureDetector(
            onTap: controller.pickScreenshot,
            child: Container(
              height: AppSpacing.s140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(
                  color: hasError ? AppColors.errorRed : AppColors.borderGrey,
                  width: 1.5,
                ),
              ),
              child: path != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadius,
                      ),
                      child: Image.file(
                        File(path),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: AppSpacing.s32,
                          color: AppColors.textMuted,
                        ),
                        AppSpacing.v8,
                        Text(
                          AppStrings.uploadScreenshotJpgPng,
                          style: AppTextStyles.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        }),
        Obx(() {
          final error = controller.screenshotError.value;
          if (error == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(left: 4, top: 4),
            child: Text(
              error,
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: AppColors.errorRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ],
    );
  }
}
