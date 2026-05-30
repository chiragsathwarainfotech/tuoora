import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Forgot Password',
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
                            'Enter your registered email address and we\'ll send you an OTP to reset your password.',
                            style: AppTextStyles.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blueSapphire,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.v24,
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
                                  'Email Address',
                                  style: AppTextStyles.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.fieldLabel,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                AppSpacing.v8,
                                _buildTextField(
                                  controller: controller.emailController,
                                  hint: 'Enter email',
                                  prefixIcon: Icons.mail,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                AppSpacing.v32,
                                Obx(
                                  () => AppButton(
                                    label: 'Send Reset Code',
                                    onPressed: controller.sendOtp,
                                    isLoading: controller.isLoading.value,
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
            color: AppColors.blueSapphire,
            size: AppSpacing.s20,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }
}
