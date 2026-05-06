import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
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
            const InstituteAppBar(title: 'Institute Profile', isRoot: false),
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
                    padding: AppSpacing.all24,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHeader(controller, p),
                        AppSpacing.v24,
                        _buildUnifiedInfoCard(context, controller, p),
                        AppSpacing.v40,
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
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.reportBorder,
                      borderRadius: BorderRadius.circular(32),
                      image: p.logoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(p.logoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: p.logoUrl == null
                        ? const Icon(
                            Icons.school_rounded,
                            size: 48,
                            color: AppColors.primaryBrand,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.instituteEditProfile),
                      child: Container(
                        padding: AppSpacing.all8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBrand,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.h8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.instituteName ?? p.name,
                    style: AppTextStyles.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    'Owner: ${p.name}',
                    style: AppTextStyles.lexend(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedInfoCard(
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

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.reportBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Contact Information',
            Icons.contact_page_rounded,
          ),
          Padding(
            padding: AppSpacing.x24,
            child: Column(
              children: [
                _buildInfoRow(Icons.email_outlined, 'Email', p.email),
                _buildInfoRow(Icons.phone_outlined, 'Phone', p.phone),
                if (p.website != null)
                  _buildInfoRow(Icons.language_rounded, 'Website', p.website!),
              ],
            ),
          ),
          _buildDivider(),
          _buildSectionHeader(
            'Location Information',
            Icons.location_on_rounded,
          ),
          Padding(
            padding: AppSpacing.x24,
            child: _buildInfoRow(
              Icons.map_outlined,
              'Address',
              address.isEmpty ? 'Not Provided' : address,
            ),
          ),
          _buildDivider(),
          _buildSectionHeader('Account Information', Icons.settings_rounded),
          _buildSettingsItem(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Update your login credentials',
            onTap: () => Get.toNamed(AppRoutes.instituteSecurity),
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
            onTap: () => Get.snackbar(
              'Coming Soon',
              'T&C details will be available soon.',
            ),
          ),
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Learn how we protect your data',
            onTap: () => Get.snackbar(
              'Coming Soon',
              'Privacy Policy will be available soon.',
            ),
          ),
          _buildSettingsItem(
            icon: Icons.help_center_outlined,
            title: 'Help Center',
            subtitle: 'Get assistance and FAQs',
            onTap: () => Get.snackbar(
              'Coming Soon',
              'Help details will be available soon.',
            ),
          ),
          _buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildSettingsItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              onTap: () => _showLogoutDialog(context, controller),
            ),
          ),
          AppSpacing.v12,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBrand),
          AppSpacing.h12,
          Text(
            title.toUpperCase(),
            style: AppTextStyles.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryBrand,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1.5,
      color: AppColors.reportBorder,
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
                  style: AppTextStyles.lexend(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.v2,
                Text(
                  value,
                  style: AppTextStyles.manrope(
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: iconColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.lexend(
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
          style: AppTextStyles.manrope(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure you want to log out from your account?',
          style: AppTextStyles.lexend(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.manrope(
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
              style: AppTextStyles.manrope(
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
