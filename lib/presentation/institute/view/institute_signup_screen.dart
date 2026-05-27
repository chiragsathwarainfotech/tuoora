import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class InstituteSignupScreen extends GetView<SignupController> {
  const InstituteSignupScreen({super.key});

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
              AppSpacing.v32,
              Container(
                margin: AppSpacing.x16,
                padding: const EdgeInsets.all(AppSpacing.s28),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('INSTITUTE NAME'),
                    AppSpacing.v8,
                    _buildTextField(
                      controller: controller.instituteNameController,
                      hint: 'e.g. Oxford Academy',
                      prefixIcon: Icons.business_outlined,
                    ),
                    AppSpacing.v24,
                    _buildLabel('EMAIL ADDRESS'),
                    AppSpacing.v8,
                    _buildTextField(
                      controller: controller.emailController,
                      hint: 'contact@institute.edu',
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppSpacing.v24,
                    _buildLabel('PASSWORD'),
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
                        label: 'Create Account',
                        onPressed: controller.register,
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
                  ],
                ),
              ),
              AppSpacing.v32,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      color: AppColors.blueSapphire,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                  ),
                ],
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
                  Icons.school,
                  color: AppColors.primaryBrand,
                  size: AppSpacing.s24,
                ),
              ),
            ),
            AppSpacing.h12,
            Text(
              'Tuoora',
              style: AppTextStyles.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
              ),
            ),
          ],
        ),
        AppSpacing.v32,
        Text(
          'REGISTRATION',
          style: AppTextStyles.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
            letterSpacing: 1.5,
          ),
        ),
        AppSpacing.v8,
        Text(
          'Complete these steps to register your institute.',
          textAlign: TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.blueSapphire,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: AppColors.brandAppBarColor,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
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
        style: AppTextStyles.outfit(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.outfit(
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
