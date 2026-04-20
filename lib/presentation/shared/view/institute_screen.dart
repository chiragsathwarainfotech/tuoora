import 'package:fee_easy/core/widgets/parent_bottom_nav.dart';
import 'package:fee_easy/core/widgets/student_bottom_nav.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteScreen extends StatelessWidget {
  final bool showBottomNav;
  const InstituteScreen({super.key, this.showBottomNav = true});

  String _getProfileRoute() {
    return Get.currentRoute.contains('/parent')
        ? AppRoutes.parentStudentProfile
        : AppRoutes.studentSettings;
  }

  String _getUpdatesRoute() {
    return Get.currentRoute.contains('/parent')
        ? AppRoutes.parentUpdates
        : AppRoutes.studentNotifications;
  }

  @override
  Widget build(BuildContext context) {
    final bool isParent = Get.currentRoute.contains('/parent');

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(_getProfileRoute()),
              child: const CircleAvatar(
                radius: AppSpacing.s18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=11',
                ),
              ),
            ),
            AppSpacing.h12,
            Text(
              AppStrings.appName,
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(_getUpdatesRoute()),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF111827),
              size: AppSpacing.s26,
            ),
          ),
          AppSpacing.h8,
        ],
      ),
      body: content,
      bottomNavigationBar: showBottomNav
          ? (isParent
                ? const ParentBottomNav(currentIndex: 4)
                : const StudentBottomNav(currentIndex: 3))
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s32),
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
            style: AppTextStyles.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
            ),
          ),
          AppSpacing.v4,
          const Divider(
            height: AppSpacing.s48,
            thickness: 1,
            color: Color(0xFFF3F4F6),
          ),
          _buildInfoTile(
            icon: Icons.person_outline_rounded,
            label: 'Owner & Founder',
            value: 'Dr. Alistair Aeon',
            iconColor: Color(0xFF2B5BCC),
            bgColor: Color(0xFFEFF6FF),
          ),
          AppSpacing.v16,
          _buildInfoTile(
            icon: Icons.email_outlined,
            label: 'Email Address',
            value: 'info@aeon.edu',
            iconColor: Color(0xFF2B5BCC),
            bgColor: Color(0xFFEFF6FF),
          ),
          AppSpacing.v16,
          _buildInfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: '+1 (555) 0100',
            iconColor: Color(0xFF2B5BCC),
            bgColor: Color(0xFFEFF6FF),
          ),
          AppSpacing.v16,
          _buildInfoTile(
            icon: Icons.location_on_outlined,
            label: 'Physical Address',
            value:
                '1221 Academic Circle, Innovation District, San Francisco, CA 94105, USA',
            iconColor: Color(0xFF92400E),
            bgColor: Color(0xFFFEF3C7),
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
        color: const Color(0xFFF8FAFC),
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
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
                AppSpacing.v2,
                Text(
                  value,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect with Us',
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          AppSpacing.v20,
          Row(
            children: [
              _buildSocialIcon(
                Icons.link,
                const Color(0xFF0077B5),
              ), // LinkedIn (approx)
              AppSpacing.h16,
              _buildSocialIcon(
                Icons.flutter_dash,
                const Color(0xFF1DA1F2),
              ), // Twitter (approx)
              AppSpacing.h16,
              _buildSocialIcon(
                Icons.facebook,
                const Color(0xFF1877F2),
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
        color: const Color(0xFFEFF6FF),
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
        color: const Color(0xFF003781),
        borderRadius: BorderRadius.circular(AppSpacing.s32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003781).withValues(alpha: 0.25),
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
              const Icon(Icons.explore_outlined, color: Colors.white, size: 24),
              AppSpacing.h12,
              Text(
                'Our Presence',
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            'Located in the heart of the Innovation District, providing a world-class environment for academic excellence.',
            style: AppTextStyles.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          AppSpacing.v24,
          Container(
            padding: AppSpacing.x24.add(AppSpacing.y14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
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
                    color: Colors.white,
                  ),
                ),
                AppSpacing.h8,
                Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
