import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/shared/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Forgot Password',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter your institutional email address and we\'ll send you a security code to reset your access key.',
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF917B6B),
                        height: 1.5,
                      ),
                    ),
                    AppSpacing.v40,
                    Container(
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
                          Text(
                            'INSTITUTIONAL EMAIL',
                            style: AppTextStyles.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF663322),
                              letterSpacing: 1.0,
                            ),
                          ),
                          AppSpacing.v8,
                          _buildTextField(
                            controller: controller.emailController,
                            hint: 'your@email.com',
                            prefixIcon: Icons.alternate_email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          AppSpacing.v32,
                          Obx(
                            () => AppButton(
                              label: 'Send Recovery Code',
                              onPressed: controller.sendOtp,
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
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(AppSpacing.s16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.lexend(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: const Color(0xFF917B6B),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF917B6B),
            size: AppSpacing.s20,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }
}
