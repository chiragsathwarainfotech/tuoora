import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/widgets/app_version_label.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
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
            InstituteAppBar(
              title: 'Institute Profile',
              isRoot: false,
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.instituteEditProfile),
                  icon: const AppActionIcon(asset: AppImages.icEdit),
                ),
                AppSpacing.h8,
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.profile.value == null) {
                  return const CommonLoading();
                }

                final p = controller.profile.value;
                if (p == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        AppSpacing.v16,
                        const Text('Failed to load profile'),
                        AppSpacing.v16,
                        ElevatedButton(
                          onPressed: () => controller.fetchProfile(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchProfile(),
                  color: AppColors.primaryBrand,
                  child: SingleChildScrollView(
                    padding: AppSpacing.all16,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(controller, p),
                        AppSpacing.v24,
                        _buildInfoAndSettings(context, controller, p),
                        AppSpacing.v24,
                        const AppVersionLabel(),
                        AppSpacing.v24,
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(InstituteProfileController controller, var p) {
    return Column(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.primaryBrandLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.fieldLabel),
            image: p.logoUrl != null
                ? DecorationImage(
                    image: NetworkImage(p.logoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: p.logoUrl == null
              ? const Center(
                  child: Icon(
                    Icons.school_rounded,
                    size: 56,
                    color: AppColors.primaryBrand,
                  ),
                )
              : null,
        ),
        AppSpacing.v16,
        Text(
          p.instituteName ?? p.name,
          textAlign: TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v4,
        Text(
          'Owner: ${p.name}',
          textAlign: TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoAndSettings(
    BuildContext context,
    InstituteProfileController controller,
    var p,
  ) {
    String address = [
      p.address,
      p.addressLine2,
      p.city,
      p.state,
      p.pincode,
    ].where((e) => e != null && e.toString().isNotEmpty).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Contact Information', Icons.contact_page_rounded),
        _buildInfoRow(Icons.email_outlined, 'Email', p.email),
        _buildInfoRow(Icons.phone_outlined, 'Phone', p.phone),
        if (p.website != null)
          _buildInfoRow(Icons.language_rounded, 'Website', p.website!),
        _buildDivider(),
        _buildSectionHeader('Location Information', Icons.location_on_rounded),
        _buildInfoRow(
          Icons.map_outlined,
          'Address',
          address.isEmpty ? 'Not Provided' : address,
        ),
        _buildDivider(),
        _buildSectionHeader('Account Information', Icons.settings_rounded),
        _buildSettingsItem(
          icon: Icons.lock_outline_rounded,
          title: 'Change Password',
          subtitle: 'Update your login credentials',
          onTap: () => Get.toNamed(AppRoutes.instituteChangePassword),
        ),
        _buildSettingsItem(
          icon: Icons.workspace_premium_outlined,
          title: 'Subscription',
          subtitle: 'Manage your active plan',
          onTap: () => Get.toNamed(AppRoutes.instituteSubscription),
        ),
        _buildSettingsItem(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'WhatsApp Integration',
          subtitle: 'Automate alerts via Meta API',
          onTap: () => Get.toNamed(AppRoutes.instituteWhatsApp),
        ),
        _buildDivider(),
        _buildSectionHeader('Support & Legal', Icons.info_outline_rounded),
        _buildSettingsItem(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          subtitle: 'Read our terms of service',
          onTap: () => AppSnackBar.warning('Coming soon'),
        ),
        _buildSettingsItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Learn how we protect your data',
          onTap: () => AppSnackBar.warning('Coming soon'),
        ),
        _buildSettingsItem(
          icon: Icons.help_center_outlined,
          title: 'Help Center',
          subtitle: 'Get assistance and FAQs',
          onTap: () => AppSnackBar.warning('Coming soon'),
        ),
        _buildDivider(),
        _buildSettingsItem(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          iconColor: AppColors.bohoRed,
          onTap: () => _showLogoutDialog(context, controller),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.fieldLabel),
          AppSpacing.h12,
          Text(
            title,
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.borderGrey.withValues(alpha: 0.5),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.v2,
                Text(
                  value,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.all10,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primaryBrand).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.primaryBrand,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: iconColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    InstituteProfileController controller,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: AppTextStyles.outfit(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure you want to log out from your account?',
          style: AppTextStyles.outfit(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.outfit(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.outfit(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
