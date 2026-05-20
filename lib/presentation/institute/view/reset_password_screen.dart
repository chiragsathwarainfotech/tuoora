import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends GetView<ForgotPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Reset Access Key',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'A verification code has been sent to your email. Enter it below along with your new access key.',
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                        height: 1.5,
                      ),
                    ),
                    AppSpacing.v40,
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s28),
                      decoration: BoxDecoration(
                        color: AppColors.white,
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
                          Text(
                            'VERIFICATION CODE',
                            style: AppTextStyles.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brandAppBarColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          AppSpacing.v8,
                          _buildTextField(
                            controller: controller.otpController,
                            hint: 'Enter 6-digit code',
                            prefixIcon: Icons.security_outlined,
                            keyboardType: TextInputType.number,
                          ),
                          AppSpacing.v24,
                          Text(
                            'NEW ACCESS KEY',
                            style: AppTextStyles.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brandAppBarColor,
                              letterSpacing: 1.0,
                            ),
                          ),
                          AppSpacing.v8,
                          Obx(
                            () => _buildTextField(
                              controller: controller.passwordController,
                              hint: 'â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢',
                              prefixIcon: Icons.lock_outline,
                              obscureText: controller.obscurePassword.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.textMuted,
                                  size: AppSpacing.s20,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                          ),
                          AppSpacing.v32,
                          Obx(
                            () => AppButton(
                              label: 'Update Access Key',
                              onPressed: controller.resetPassword,
                              isLoading: controller.isLoading.value,
                              backgroundColor: AppColors.primaryBrand,
                              foregroundColor: AppColors.white,
                              borderRadius: AppSpacing.s24,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.s18,
                              ),
                              fontSize: 16,
                              fullWidth: true,
                            ),
                          ),
                          AppSpacing.v24,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.canResend.value
                                      ? "Didn't receive the code? "
                                      : "Resend code in ",
                                  style: AppTextStyles.lexend(
                                    fontSize: 14,
                                    color: AppColors.blueSapphire,
                                  ),
                                ),
                              ),
                              Obx(
                                () => controller.canResend.value
                                    ? GestureDetector(
                                        onTap: controller.isLoading.value
                                            ? null
                                            : controller.resendOtp,
                                        child: Text(
                                          'Resend Code',
                                          style: AppTextStyles.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryBrand,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        '00:${controller.timerSeconds.value.toString().padLeft(2, '0')}',
                                        style: AppTextStyles.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryBrand,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.lexend(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.blueSapphire,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.blueSapphire,
            size: AppSpacing.s20,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }
}
