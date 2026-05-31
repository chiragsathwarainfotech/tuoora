import 'package:tuoora/core/constants/app_images.dart';
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
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Set New Password',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: AppSpacing.screenPaddingTop,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - AppSpacing.s16,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              AppImages.logoWithName,
                              height: AppSpacing.s48,
                            ),
                          ),
                          AppSpacing.v12,
                          Text(
                            'A verification code has been sent to your email. Enter it below along with your new access key.',
                            style: AppTextStyles.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textTertiary,
                              height: 1.5,
                            ),
                          ),
                          AppSpacing.v40,
                          Container(
                            padding: AppSpacing.cardPadding,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.cardRadius,
                              ),
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
                                  'Verification code',
                                  style: AppTextStyles.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.fieldLabel,
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
                                  'New Password',
                                  style: AppTextStyles.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.fieldLabel,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                AppSpacing.v8,
                                Obx(
                                  () => _buildTextField(
                                    controller: controller.passwordController,
                                    hint: 'Enter new password',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText:
                                        controller.obscurePassword.value,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.obscurePassword.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.textMuted,
                                        size: AppSpacing.s20,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                  ),
                                ),
                                AppSpacing.v24,
                                Text(
                                  'Confirm Password',
                                  style: AppTextStyles.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.fieldLabel,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                AppSpacing.v8,
                                Obx(
                                  () => _buildTextField(
                                    controller:
                                        controller.confirmPasswordController,
                                    hint: 'Enter confirm password',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText:
                                        controller.obscureConfirmPassword.value,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.obscureConfirmPassword.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.textMuted,
                                        size: AppSpacing.s20,
                                      ),
                                      onPressed: controller
                                          .toggleConfirmPasswordVisibility,
                                    ),
                                  ),
                                ),
                                AppSpacing.v32,
                                Obx(
                                  () => AppButton(
                                    label: 'Reset Password',
                                    onPressed: controller.resetPassword,
                                    isLoading: controller.isLoading.value,
                                    backgroundColor: AppColors.primaryBrand,
                                    foregroundColor: AppColors.white,
                                    borderRadius: AppSpacing.cardRadius,
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
                                        style: AppTextStyles.outfit(
                                          fontSize: 14,
                                          color: AppColors.blueSapphire,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => controller.canResend.value
                                          ? GestureDetector(
                                              onTap:
                                                  controller.isResending.value
                                                  ? null
                                                  : controller.resendOtp,
                                              child: Text(
                                                'Resend Code',
                                                style: AppTextStyles.outfit(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primaryBrand,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              '00:${controller.timerSeconds.value.toString().padLeft(2, '0')}',
                                              style: AppTextStyles.outfit(
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
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.outfit(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.outfit(
            fontSize: 14,
            color: AppColors.fieldLabel,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.fieldLabel,
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
