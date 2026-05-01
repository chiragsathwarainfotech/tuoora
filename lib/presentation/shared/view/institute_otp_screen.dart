import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/shared/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class InstituteOtpScreen extends GetView<SignupController> {
  const InstituteOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppSpacing.v32,
              _buildHeader(),
              AppSpacing.v40,
              Container(
                margin: AppSpacing.x24,
                padding: const EdgeInsets.all(AppSpacing.s28),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: AppSpacing.s24,
                      offset: const Offset(0, AppSpacing.s12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('VERIFICATION CODE'),
                    AppSpacing.v16,
                    _buildOtpField(),
                    AppSpacing.v32,
                    Obx(
                      () => AppButton(
                        label: 'Verify OTP',
                        onPressed: controller.verifyOtp,
                        isLoading: controller.isLoading.value,
                        backgroundColor: AppColors.primaryBrand,
                        foregroundColor: Colors.white,
                        borderRadius: AppSpacing.s24,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s18,
                        ),
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
                                'Resend code in 00:${controller.timerSeconds.value.toString().padLeft(2, '0')}',
                                style: AppTextStyles.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF917B6B),
                                ),
                              ),
                            if (controller.canResend.value)
                              TextButton(
                                onPressed: controller.resendOtp,
                                child: Text(
                                  'Resend Code',
                                  style: AppTextStyles.manrope(
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSpacing.s40,
              height: AppSpacing.s40,
              decoration: BoxDecoration(
                color: AppColors.primaryBrandLight,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.lock_person_outlined,
                  color: const Color(0xFF663322),
                  size: AppSpacing.s24,
                ),
              ),
            ),
            AppSpacing.h12,
            Text(
              'Verification',
              style: AppTextStyles.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
              ),
            ),
          ],
        ),
        AppSpacing.v32,
        Text(
          'CHECK YOUR EMAIL',
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF663322),
            letterSpacing: 1.5,
          ),
        ),
        AppSpacing.v8,
        Text(
          'OTP Verification',
          style: AppTextStyles.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF663322),
          ),
        ),
        AppSpacing.v8,
        Padding(
          padding: AppSpacing.x24,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF917B6B),
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'We have sent a 6-digit verification code to ',
                ),
                TextSpan(
                  text: controller.emailController.text,
                  style: AppTextStyles.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF663322),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF663322),
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildOtpField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(AppSpacing.s16),
      ),
      child: TextField(
        controller: controller.otpController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        textAlign: TextAlign.center,
        style: AppTextStyles.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF663322),
          letterSpacing: 8.0,
        ),
        decoration: const InputDecoration(
          counterText: '',
          hintText: 'XXXXXX',
          hintStyle: TextStyle(color: Color(0xFF917B6B), letterSpacing: 8.0),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }
}
