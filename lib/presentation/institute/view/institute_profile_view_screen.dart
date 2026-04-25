import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteProfileViewScreen extends StatelessWidget {
  const InstituteProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InstituteProfileController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Profile', isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SingleChildScrollView(
                  padding: AppSpacing.x24.add(AppSpacing.y20),
                  child: Column(
                    children: [
                      _buildInstituteIdentityCard(controller),
                      AppSpacing.v24,
                      _buildAccountManagementCard(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstituteIdentityCard(InstituteProfileController controller) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLogoHeader(controller),
          AppSpacing.h12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.instituteName.value,
                textAlign: TextAlign.center,
                style: AppTextStyles.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue,
                ),
              ),
              AppSpacing.v6,
              _buildInfoChip(Icons.email_rounded, controller.email.value),
              AppSpacing.v6,
              _buildInfoChip(Icons.phone_rounded, controller.phone.value),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoHeader(InstituteProfileController controller) {
    return Stack(
      children: [
        Container(
          width: AppSpacing.s100,
          height: AppSpacing.s100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderGrey, width: 1.5),
          ),
          child: controller.profileImagePath.value == null
              ? const Center(
                  child: Icon(
                    Icons.school_rounded,
                    color: Color(0xFF5B98A6),
                    size: AppSpacing.s48,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: AppSpacing.s4,
          right: AppSpacing.s4,
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteEditProfile),
            child: Container(
              padding: AppSpacing.all6,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: AppSpacing.s12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.s18, color: AppColors.primaryBlue),
        AppSpacing.h12,
        Text(
          text,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountManagementCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.instAccountManagement,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBlueDark,
            ),
          ),
          AppSpacing.v24,
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteSecurity),
            child: _buildManagementItem(
              icon: Icons.lock_rounded,
              title: AppStrings.instPasswordSecurity,
              subtitle: AppStrings.instUpdateCredentials,
              iconColor: const Color(0xFFB4C7F2),
            ),
          ),
          const Divider(height: AppSpacing.s40, color: AppColors.scaffoldBg),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteSubscription),
            child: _buildManagementItem(
              icon: Icons.workspace_premium_rounded,
              title: AppStrings.instSubscriptionPlan,
              subtitle: 'Manage your active tier and billing',
              iconColor: const Color(0xFFFEF08A),
            ),
          ),
          const Divider(height: AppSpacing.s40, color: AppColors.scaffoldBg),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteWhatsApp),
            child: _buildManagementItem(
              icon: Icons.chat_bubble_rounded,
              title: AppStrings.instWhatsAppIntegration,
              subtitle: 'Automate alerts via Meta API',
              iconColor: const Color(0xFFDCFCE7),
            ),
          ),
          const Divider(height: AppSpacing.s40, color: AppColors.scaffoldBg),
          GestureDetector(
            onTap: () => Get.snackbar('Coming Soon', 'Terms & Conditions will be available soon.'),
            child: _buildManagementItem(
              icon: Icons.description_rounded,
              title: 'Terms & Conditions',
              subtitle: 'Read our terms of service',
              iconColor: AppColors.indigoLight,
            ),
          ),
          const Divider(height: AppSpacing.s40, color: AppColors.scaffoldBg),
          GestureDetector(
            onTap: () => Get.snackbar('Coming Soon', 'Privacy Policy will be available soon.'),
            child: _buildManagementItem(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              subtitle: 'Learn how we protect your data',
              iconColor: const Color(0xFFFCE7F3),
            ),
          ),
          const Divider(height: AppSpacing.s40, color: AppColors.scaffoldBg),
          GestureDetector(
            onTap: () => Get.snackbar('Coming Soon', 'Help Center will be available soon.'),
            child: _buildManagementItem(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'Get assistance and FAQs',
              iconColor: const Color(0xFFFEF3C7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: AppSpacing.all12,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.oceanBlue,
            size: AppSpacing.s20,
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v2,
              Text(
                subtitle,
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted,
          size: 20,
        ),
      ],
    );
  }
}
