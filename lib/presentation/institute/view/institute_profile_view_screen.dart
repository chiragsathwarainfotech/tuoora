import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_drawer.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/view/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fee_easy/presentation/institute/widgets/institute_root_scaffold.dart';

class InstituteProfileViewScreen extends StatelessWidget {
  final bool showShell;
  const InstituteProfileViewScreen({super.key, this.showShell = true});

  @override
  Widget build(BuildContext context) {
    return InstituteRootScaffold(
      title: "St. Augustine's Institute",
      currentIndex: 4,
      showShell: showShell,
      body: SingleChildScrollView(
        padding: AppSpacing.x24.add(AppSpacing.y20),
        child: Column(
          children: [
            _buildInstituteIdentityCard(),
            AppSpacing.v24,
            _buildAccountManagementCard(),
            AppSpacing.v24,
            _buildPremiumPlanCard(),
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }

  Widget _buildInstituteIdentityCard() {
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
      child: Column(
        children: [
          _buildLogoHeader(),
          AppSpacing.v24,
          Text(
            "St. Augustine's Institute of Research",
            textAlign: TextAlign.center,
            style: AppTextStyles.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF003082),
            ),
          ),
          AppSpacing.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: AppSpacing.s16,
                color: AppColors.textTertiary,
              ),
              AppSpacing.h8,
              Text(
                'Academic District, Cambridge',
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          _buildInfoChip(Icons.email_rounded, 'admin@st-augustine.edu'),
          AppSpacing.v12,
          _buildInfoChip(Icons.phone_rounded, '+44 20 7946 0123'),
        ],
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Stack(
      children: [
        Container(
          width: AppSpacing.s100,
          height: AppSpacing.s100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
          ),
          child: const Center(
            child: Icon(
              Icons.school_rounded,
              color: Color(0xFF5B98A6),
              size: AppSpacing.s48,
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.s4,
          right: AppSpacing.s4,
          child: GestureDetector(
            onTap: () => Get.to(() => const InstituteEditProfileScreen()),
            child: Container(
              padding: AppSpacing.all6,
              decoration: const BoxDecoration(
                color: Color(0xFF003082),
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
    return Container(
      padding: AppSpacing.x16.add(AppSpacing.y12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.s18, color: const Color(0xFF003082)),
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
      ),
    );
  }

  Widget _buildAccountManagementCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.instAccountManagement,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF003D99),
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
          const Divider(height: AppSpacing.s40, color: Color(0xFFF9FAFB)),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteSubscription),
            child: _buildManagementItem(
              icon: Icons.workspace_premium_rounded,
              title: AppStrings.instSubscriptionPlan,
              subtitle: 'Manage your active tier and billing',
              iconColor: const Color(0xFFFEF08A),
            ),
          ),
          const Divider(height: AppSpacing.s40, color: Color(0xFFF9FAFB)),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteWhatsApp),
            child: _buildManagementItem(
              icon: Icons.chat_bubble_rounded,
              title: AppStrings.instWhatsAppIntegration,
              subtitle: 'Automate alerts via Meta API',
              iconColor: const Color(0xFFDCFCE7),
            ),
          ),
          const Divider(height: AppSpacing.s40, color: Color(0xFFF9FAFB)),
          _buildManagementItem(
            icon: Icons.visibility_rounded,
            title: AppStrings.instPrivacySettings,
            subtitle: AppStrings.instManageVisibility,
            iconColor: const Color(0xFFC7D2FE),
          ),
          const Divider(height: AppSpacing.s40, color: Color(0xFFF9FAFB)),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteNotifications),
            child: _buildManagementItem(
              icon: Icons.notifications_rounded,
              title: AppStrings.instNotificationPrefs,
              subtitle: AppStrings.instEmailSmsSettings,
              iconColor: const Color(0xFFDBEAFE),
            ),
          ),
          const Divider(
            height: AppSpacing.s40,
            color: Color(0xFFF3F4F6),
            thickness: 1,
          ),
          AppSpacing.v8,
          _buildSignOutItem(),
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
            color: const Color(0xFF1E40AF),
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

  Widget _buildSignOutItem() {
    return InkWell(
      onTap: () => Get.offAllNamed(AppRoutes.login),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Color(0xFF991B1B),
              size: AppSpacing.s20,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.instSignOutLabel,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF991B1B),
                  ),
                ),
                Text(
                  AppStrings.instTerminateSession,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            color: Color(0xFF991B1B),
            size: AppSpacing.s20,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPlanCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        color: const Color(0xFF003E8C),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003E8C).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: AppSpacing.x14.add(AppSpacing.y8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppStrings.instActivePlan,
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Icon(
                Icons.verified_rounded,
                color: Color(0xFF60A5FA),
                size: AppSpacing.s28,
              ),
            ],
          ),
          AppSpacing.v20,
          Text(
            AppStrings.instInstitutionPremium,
            style: AppTextStyles.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          AppSpacing.v32,
          _buildPlanInfoRow(AppStrings.instMemberSince, 'Sept 2021'),
          const Divider(height: AppSpacing.s32, color: Colors.white10),
          _buildPlanInfoRow(AppStrings.instNextRenewal, 'Oct 12, 2024'),
          AppSpacing.v32,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.instMonthlyUsage,
                style: AppTextStyles.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              Text(
                '65%',
                style: AppTextStyles.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.65,
              minHeight: AppSpacing.s12,
              backgroundColor: Colors.white12,
              color: Color(0xFF60A5FA),
            ),
          ),
          AppSpacing.v32,
          Container(
            width: double.infinity,
            padding: AppSpacing.y20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.instUpgradePlanBtn,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF003E8C),
                  ),
                ),
                AppSpacing.h8,
                const Icon(
                  Icons.arrow_upward_rounded,
                  color: Color(0xFF003E8C),
                  size: AppSpacing.s18,
                ),
              ],
            ),
          ),
          AppSpacing.v24,
          Center(
            child: Text(
              AppStrings.instViewBillingHistory,
              style: AppTextStyles.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white54,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white60,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
