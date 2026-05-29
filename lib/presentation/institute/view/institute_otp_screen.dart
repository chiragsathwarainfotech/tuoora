import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class InstituteOtpScreen extends GetView<SignupController> {
  const InstituteOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSpacing.v32,
              _buildHeader(),
              AppSpacing.v40,
              Container(
                margin: AppSpacing.x16,
                padding: AppSpacing.cardPadding,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Enter Code'),
                    AppSpacing.v16,
                    _buildOtpField(),
                    AppSpacing.v32,
                    Obx(
                      () => AppButton(
                        label: 'Verify',
                        onPressed: controller.verifyOtp,
                        isLoading: controller.isLoading.value,
                        backgroundColor: AppColors.primaryBrand,
                        foregroundColor: AppColors.white,
                        borderRadius: AppSpacing.cardRadius,
                        fontSize: 16,
                        fullWidth: true,
                      ),
                    ),
                    AppSpacing.v24,
                    Obx(
                      () => Center(
                        child: Column(
                          children: [
                            if (!controller.canResend.value)
                              Text(
                                'Didn\'t receive? 00:${controller.timerSeconds.value.toString().padLeft(2, '0')}',
                                style: AppTextStyles.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blueSapphire,
                                ),
                              ),
                            if (controller.canResend.value)
                              TextButton(
                                onPressed: controller.resendOtp,
                                child: Text(
                                  'Resend OTP',
                                  style: AppTextStyles.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryBrand,
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
              AppSpacing.v32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Image.asset(AppImages.logoWithName, height: AppSpacing.s48),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.brandAppBarColor,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildOtpField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: TextField(
        controller: controller.otpController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: AppTextStyles.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.brandAppBarColor,
          letterSpacing: 8.0,
        ),
        decoration: const InputDecoration(
          counterText: '',
          hintText: 'XXXXXX',
          hintStyle: TextStyle(
            color: AppColors.blueSapphire,
            letterSpacing: 8.0,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }
}
