import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/presentation/institute/controllers/security_controller.dart';
import 'package:get/get.dart';

class InstituteChangePasswordScreen extends GetView<SecurityController> {
  const InstituteChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const InstituteAppBar(title: 'Change Password', isRoot: false),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPaddingTop,
                    child: _buildUpdatePasswordCard(),
                  ),
                ),
              ],
            ),
            Obx(
              () => controller.isLoading.value
                  ? Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const CommonLoading(color: AppColors.white),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdatePasswordCard() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
            style: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v24,
          Obx(
            () => _buildPasswordField(
              label: AppStrings.instCurrentPasswordLabel,
              hint: '••••••••',
              controller: controller.currentPasswordController,
              isVisible: controller.isCurrentPasswordVisible,
              onToggle: controller.toggleCurrentPasswordVisibility,
              errorText: controller.currentPasswordError.value,
            ),
          ),
          AppSpacing.v24,
          Obx(
            () => _buildPasswordField(
              label: AppStrings.instNewPasswordLabel,
              hint: 'Enter new password',
              controller: controller.newPasswordController,
              isVisible: controller.isNewPasswordVisible,
              onToggle: controller.toggleNewPasswordVisibility,
              errorText: controller.newPasswordError.value,
            ),
          ),
          AppSpacing.v24,
          Obx(
            () => _buildPasswordField(
              label: AppStrings.instConfirmPasswordLabel,
              hint: 'Confirm new password',
              controller: controller.confirmPasswordController,
              isVisible: controller.isConfirmPasswordVisible,
              onToggle: controller.toggleConfirmPasswordVisibility,
              errorText: controller.confirmPasswordError.value,
            ),
          ),
          AppSpacing.v32,
          AppButton(
            label: AppStrings.instUpdatePasswordBtn,
            icon: Icons.lock_reset_rounded,
            onPressed: () => controller.updatePassword(),
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
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.outfit(
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
              color: AppColors.paleSilver,
              borderRadius: BorderRadius.circular(12),
              border: errorText != null
                  ? Border.all(color: Colors.redAccent, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: !isVisible.value,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: AppTextStyles.outfit(
                        fontSize: 14,
                        color: AppColors.fieldLabel,
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
                    color: AppColors.fieldLabel,
                    size: AppSpacing.s20,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
