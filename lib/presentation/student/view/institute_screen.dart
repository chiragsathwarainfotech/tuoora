import 'package:cached_network_image/cached_network_image.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteScreen extends StatelessWidget {
  final bool showBottomNav;
  const InstituteScreen({super.key, this.showBottomNav = true});

  String _getProfileRoute() => AppRoutes.studentSettings;

  String _getUpdatesRoute() => AppRoutes.studentNotifications;

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Column(
        children: [
          AppSpacing.v20,
          _buildInstituteDetailsCard(),
          AppSpacing.v24,
          _buildConnectSection(),
          AppSpacing.v24,
          _buildPresenceCard(),
          AppSpacing.v40,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(_getProfileRoute()),
              child: CircleAvatar(
                radius: AppSpacing.s18,
                backgroundImage: CachedNetworkImageProvider(
                  'https://i.pravatar.cc/150?img=11',
                ),
              ),
            ),
            AppSpacing.h12,
            Text(
              AppStrings.appName,
              style: AppTextStyles.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(_getUpdatesRoute()),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.fieldLabel,
              size: AppSpacing.s26,
            ),
          ),
          AppSpacing.h8,
        ],
      ),
      body: content,
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 3)
          : null,
    );
  }

  Widget _buildInstituteDetailsCard() {
    return Container(
      margin: AppSpacing.x20,
      padding: AppSpacing.x24.add(
        const EdgeInsets.symmetric(vertical: AppSpacing.s32),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: AppSpacing.s100,
            width: AppSpacing.s100,
            padding: const EdgeInsets.all(AppSpacing.s18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.s32),
              image: const DecorationImage(
                image: AssetImage('assets/institute_header.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.v20,
          Text(
            AppStrings.appName,
            style: AppTextStyles.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          const Divider(
            height: AppSpacing.s48,
            thickness: 1,
            color: AppColors.background,
          ),
          _buildInfoTile(
            icon: Icons.person_outline_rounded,
            label: 'Owner & Founder',
            value: 'Dr. Alistair Aeon',
            iconColor: AppColors.primaryBrand,
            bgColor: AppColors.subjectPhysicsSoft,
          ),
          AppSpacing.v16,
          _buildInfoTile(
            icon: Icons.email_outlined,
            label: 'Email Address',
            value: 'info@aeon.edu',
            iconColor: AppColors.primaryBrand,
            bgColor: AppColors.subjectPhysicsSoft,
          ),
          AppSpacing.v16,
          _buildInfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: '+1 (555) 0100',
            iconColor: AppColors.primaryBrand,
            bgColor: AppColors.subjectPhysicsSoft,
          ),
          AppSpacing.v16,
          _buildInfoTile(
            icon: Icons.location_on_outlined,
            label: 'Physical Address',
            value:
                '1221 Academic Circle, Innovation District, San Francisco, CA 94105, USA',
            iconColor: AppColors.bohoRed,
            bgColor: AppColors.errorBg,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: AppSpacing.s20),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
                AppSpacing.v2,
                Text(
                  value,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkSlate,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectSection() {
    return Container(
      margin: AppSpacing.x20,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect with Us',
            style: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.darkSlate,
            ),
          ),
          AppSpacing.v20,
          Row(
            children: [
              _buildSocialIcon(
                Icons.link,
                AppColors.subjectPhysics,
              ), // LinkedIn (approx)
              AppSpacing.h16,
              _buildSocialIcon(
                Icons.flutter_dash,
                AppColors.subjectPhysics,
              ), // Twitter (approx)
              AppSpacing.h16,
              _buildSocialIcon(
                Icons.facebook,
                AppColors.subjectPhysics,
              ), // Facebook
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      height: AppSpacing.s52,
      width: AppSpacing.s52,
      decoration: BoxDecoration(
        color: AppColors.subjectPhysicsSoft,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildPresenceCard() {
    return Container(
      margin: AppSpacing.x20,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        color: AppColors.primaryBrand,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBrand.withValues(alpha: 0.25),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.explore_outlined,
                color: AppColors.white,
                size: 24,
              ),
              AppSpacing.h12,
              Text(
                'Our Presence',
                style: AppTextStyles.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            'Located in the heart of the Innovation District, providing a world-class environment for academic excellence.',
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          AppSpacing.v24,
          Container(
            padding: AppSpacing.x24.add(AppSpacing.y14),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.s16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Get Directions',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                AppSpacing.h8,
                Icon(Icons.arrow_forward, color: AppColors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
