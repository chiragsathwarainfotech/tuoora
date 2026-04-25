import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/presentation/institute/controllers/security_controller.dart';
import 'package:get/get.dart';

class InstituteSecurityScreen extends GetView<SecurityController> {
  const InstituteSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Security', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: _buildUpdatePasswordCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdatePasswordCard() {
    return Container(
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.instUpdatePasswordLabel,
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v24,
          _buildPasswordField(
            label: AppStrings.instCurrentPasswordLabel,
            hint: '••••••••',
            controller: controller.currentPasswordController,
            isVisible: controller.isCurrentPasswordVisible,
            onToggle: controller.toggleCurrentPasswordVisibility,
          ),
          AppSpacing.v24,
          _buildPasswordField(
            label: AppStrings.instNewPasswordLabel,
            hint: 'Min. 8 characters',
            controller: controller.newPasswordController,
            isVisible: controller.isNewPasswordVisible,
            onToggle: controller.toggleNewPasswordVisibility,
          ),
          AppSpacing.v24,
          _buildPasswordField(
            label: AppStrings.instConfirmPasswordLabel,
            hint: 'Repeat password',
            controller: controller.confirmPasswordController,
            isVisible: controller.isConfirmPasswordVisible,
            onToggle: controller.toggleConfirmPasswordVisibility,
          ),
          AppSpacing.v32,
          ElevatedButton(
            onPressed: controller.updatePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004CB3),
              foregroundColor: Colors.white,
              padding: AppSpacing.x28.add(AppSpacing.y18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              AppStrings.instUpdatePasswordBtn,
              style: AppTextStyles.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required RxBool isVisible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDarkGrey,
          ),
        ),
        AppSpacing.v12,
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: !isVisible.value,
                    style: AppTextStyles.lexend(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTextStyles.lexend(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggle,
                  icon: Icon(
                    isVisible.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textTertiary,
                    size: AppSpacing.s20,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
