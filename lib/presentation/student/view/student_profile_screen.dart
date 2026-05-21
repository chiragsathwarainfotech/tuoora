import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/widgets/profile_grid_action.dart';
import 'package:tuoora/presentation/student/widgets/profile_menu_tile.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/controllers/student_profile_controller.dart';
import 'package:tuoora/data/models/student_profile_model.dart';
import 'dart:io';

class StudentProfileScreen extends GetView<StudentProfileController> {
  final bool showBottomNav;

  const StudentProfileScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBrand),
            );
          }
          final profile = controller.profileData.value;
          if (profile == null) {
            return const Center(child: Text('Failed to load profile data'));
          }

          return Column(
            children: [
              const StudentAppBar(title: 'Profile', isRoot: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeroCard(profile.header),
                      const SizedBox(height: 12),
                      _buildStatsRow(profile.stats),
                      const SizedBox(height: 12),
                      _buildQRCard(profile.studentQr),
                      const SizedBox(height: 16),
                      _buildGridActions(),
                      const SizedBox(height: 32),
                      _buildSectionTitle('YOUR INFO'),
                      const SizedBox(height: 8),
                      _buildYourInfoCard(profile.info),
                      const SizedBox(height: 24),
                      _buildSectionTitle('SETTINGS'),
                      const SizedBox(height: 8),
                      _buildSettingsCard(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('HELP & INFO'),
                      const SizedBox(height: 8),
                      _buildHelpCard(),
                      const SizedBox(height: 24),
                      _buildLogOutButton(),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 4)
          : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildHeroCard(StudentProfileHeader header) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFDF7634),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header.name,
                      style: AppTextStyles.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Class ${header.standard} • ${header.subject} • Roll ${header.rollNo}',
                      style: AppTextStyles.lexend(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.insights_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Member since   ${header.memberSince}',
                          style: AppTextStyles.lexend(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(() {
                  final controller = Get.find<StudentProfileController>();
                  final imagePath = controller.profileImagePath.value;
                  return Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF2F2),
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imagePath.isNotEmpty
                        ? Image.file(File(imagePath), fit: BoxFit.cover)
                        : (header.avatarUrl.isNotEmpty &&
                                  header.avatarUrl.startsWith('http')
                              ? Image.network(
                                  header.avatarUrl,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                    header.initials,
                                    style: AppTextStyles.manrope(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF78350F),
                                    ),
                                  ),
                                )),
                  );
                }),
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: GestureDetector(
                    onTap: () {
                      Get.find<StudentProfileController>()
                          .showImagePickerOptions();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF92400E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(StudentProfileStats stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'ATTENDANCE',
            value: '${stats.attendancePct}%',
            valueColor: const Color(0xFF0F766E),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            label: 'COMPLETED',
            value: '${stats.assignmentsPct}%',
            valueColor: const Color(0xFF78350F),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard(StudentProfileQr qr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.qr_code_2_rounded,
            size: 72,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STUDENT QR',
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  qr.displayId,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  qr.hint,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textSecondary,
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

  Widget _buildGridActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileGridAction(
                icon: Icons.show_chart_rounded,
                label: 'Reports',
                iconBgColor: const Color(0xFFFEF2F2),
                iconColor: const Color(0xFF7F1D1D),
                onTap: () => Get.toNamed(AppRoutes.studentReports),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileGridAction(
                icon: Icons.book_outlined,
                label: 'Study\nmaterial',
                iconBgColor: const Color(0xFFFEF9C3),
                iconColor: const Color(0xFF713F12),
                onTap: () => Get.toNamed(AppRoutes.studentStudyMaterial),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileGridAction(
                icon: Icons.domain_rounded,
                label: 'Institute',
                iconBgColor: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF14532D),
                onTap: () => Get.toNamed(AppRoutes.studentInstitute),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileGridAction(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                iconBgColor: const Color(0xFFFEF2F2),
                iconColor: const Color(0xFF78350F),
                onTap: () => Get.toNamed(AppRoutes.studentChat),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ProfileGridAction(
                icon: Icons.download_rounded,
                label: 'Receipts',
                iconBgColor: const Color(0xFFCCFBF1),
                iconColor: const Color(0xFF134E4A),
                onTap: () => Get.toNamed(AppRoutes.studentReceiptsList),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildCardWrap({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildYourInfoCard(StudentProfileInfo info) {
    return _buildCardWrap(
      children: [
        _buildInfoRow('Phone', '+91 ${info.phone}'),
        Divider(height: 1, color: AppColors.borderGrey.withValues(alpha: 0.5)),
        _buildInfoRow('Email', info.email),
        if (info.parentName != null) ...[
          Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          _buildInfoRow(
            info.parentRelation,
            '${info.parentName} • +91 ${info.parentPhone ?? ''}',
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.lexend(
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return _buildCardWrap(
      children: [
        ProfileMenuTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notification preferences',
          onTap: () => Get.toNamed(AppRoutes.studentNotificationPreferences),
        ),
        // Divider(height: 1, color: AppColors.borderGrey.withValues(alpha: 0.5)),
        // const ProfileMenuTile(
        //   icon: Icons.article_outlined,
        //   title: 'Language',
        //   trailingText: 'English',
        // ),
        // Divider(height: 1, color: AppColors.borderGrey.withValues(alpha: 0.5)),
        // const ProfileMenuTile(
        //   icon: Icons.brightness_auto_rounded,
        //   title: 'Theme',
        //   trailingText: 'Light',
        // ),
      ],
    );
  }

  Widget _buildHelpCard() {
    return _buildCardWrap(
      children: [
        const ProfileMenuTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Help & support',
        ),
        Divider(height: 1, color: AppColors.borderGrey.withValues(alpha: 0.5)),
        const ProfileMenuTile(
          icon: Icons.shield_outlined,
          title: 'Privacy & terms',
        ),
        Divider(height: 1, color: AppColors.borderGrey.withValues(alpha: 0.5)),
        ProfileMenuTile(
          icon: Icons.add_circle_outline_rounded,
          title: 'Tell us what\'s missing',
          onTap: () => Get.toNamed(AppRoutes.studentFeedback),
        ),
      ],
    );
  }

  Widget _buildLogOutButton() {
    return ElevatedButton(
      onPressed: () async {
        final authService = Get.find<AuthService>();
        await authService.clearSession();
        Get.offAllNamed(AppRoutes.login, arguments: 'STUDENT');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFEF2F2),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_forward_rounded,
            color: Color(0xFF991B1B),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Log out',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF991B1B),
            ),
          ),
        ],
      ),
    );
  }
}
