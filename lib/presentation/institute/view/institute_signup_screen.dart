import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
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
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppSpacing.v32,
                    _buildHeader(),
                    AppSpacing.v32,
                    Container(
                      margin: AppSpacing.x16,
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
                          _buildLabel('Institute Name'),
                          AppSpacing.v8,
                          _buildTextField(
                            controller: controller.instituteNameController,
                            hint: 'Enter institute name',
                            prefixIcon: Icons.business_outlined,
                          ),
                          AppSpacing.v24,
                          _buildLabel('Owner Name'),
                          AppSpacing.v8,
                          _buildTextField(
                            controller: controller.instituteOwnerNameController,
                            hint: 'Enter owner name',
                            prefixIcon: Icons.person,
                          ),
                          AppSpacing.v24,
                          _buildLabel('Email Address'),
                          AppSpacing.v8,
                          _buildTextField(
                            controller: controller.emailController,
                            hint: 'Enter email',
                            prefixIcon: Icons.mail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          AppSpacing.v24,
                          _buildLabel('Password'),
                          AppSpacing.v8,
                          Obx(
                            () => _buildTextField(
                              controller: controller.passwordController,
                              hint: '••••••••',
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
                              borderRadius: AppSpacing.cardRadius,
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
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(AppImages.logoWithName, height: AppSpacing.s48),
        AppSpacing.v12,
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
        fontSize: 12,
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
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
