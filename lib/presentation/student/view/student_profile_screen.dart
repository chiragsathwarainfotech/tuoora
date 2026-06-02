import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/widgets/app_network_image.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:tuoora/core/widgets/app_version_label.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
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
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CommonLoading(color: AppColors.primaryBrand);
          }
          final profile = controller.profileData.value;
          if (profile == null) {
            return const AppEmptyView(
              icon: Icons.person_off_outlined,
              title: 'Profile unavailable',
              message:
                  'We couldn\'t load your profile right now. Please try again later.',
            );
          }

          return Column(
            children: [
              const StudentAppBar(title: 'Profile', isRoot: true),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryBrand,
                  onRefresh: controller.fetchProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.screenPaddingTop,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeroCard(profile.header),
                        const SizedBox(height: 12),
                        _buildStatsRow(profile.stats),
                        const SizedBox(height: 12),
                        _buildGridActions(),
                        const SizedBox(height: 16),
                        _buildSectionTitle('YOUR INFO'),
                        const SizedBox(height: 8),
                        _buildYourInfoCard(profile.info),
                        const SizedBox(height: 16),
                        _buildSectionTitle('SETTINGS'),
                        const SizedBox(height: 8),
                        _buildSettingsCard(),
                        const SizedBox(height: 16),
                        _buildSectionTitle('HELP & INFO'),
                        const SizedBox(height: 8),
                        _buildHelpCard(),
                        const SizedBox(height: 16),
                        _buildLogOutButton(),
                        const SizedBox(height: 16),
                        const AppVersionLabel(),
                        const SizedBox(height: 16),
                      ],
                    ),
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
      style: AppTextStyles.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildHeroCard(StudentProfileHeader header) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(100, 14, 16, 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.instBrandOrange,
                      AppColors.instBrandOrangeLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Text(
                  header.name,
                  style: AppTextStyles.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class ${header.standard} • ${header.subject} • Roll ${header.rollNo}',
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.insights_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Member since: ${header.memberSince}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.outfit(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
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
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrandLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imagePath.isNotEmpty
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const _AvatarPersonFallback(),
                          )
                        : (header.avatarUrl.isNotEmpty &&
                                  header.avatarUrl.startsWith('http')
                              ? AppNetworkImage(
                                  url: header.avatarUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: const _AvatarPersonFallback(),
                                )
                              : Center(
                                  child: Text(
                                    header.initials,
                                    style: AppTextStyles.outfit(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryBrand,
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
                      controller.showImagePickerOptions();
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
                          color: AppColors.primaryBrand,
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
            valueColor: AppColors.primaryBrand,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            label: 'ASSIGNMENT COMPLETED',
            value: '${stats.assignmentsPct}%',
            valueColor: AppColors.primaryBrand,
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
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
              height: 1,
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
                iconBgColor: AppColors.primaryBrandLight,
                iconColor: AppColors.primaryBrand,
                onTap: () => Get.toNamed(AppRoutes.studentReports),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProfileGridAction(
                icon: Icons.book_outlined,
                label: 'Study material',
                iconBgColor: AppColors.successBg,
                iconColor: AppColors.successGreen,
                onTap: () => Get.toNamed(AppRoutes.studentStudyMaterial),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ProfileGridAction(
                icon: Icons.domain_rounded,
                label: 'Institute',
                iconBgColor: AppColors.subjectPhysicsSoft,
                iconColor: AppColors.subjectPhysics,
                onTap: () => Get.toNamed(AppRoutes.studentInstitute),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProfileGridAction(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                iconBgColor: AppColors.errorBg,
                iconColor: AppColors.bohoRed,
                onTap: () => Get.toNamed(AppRoutes.studentChat),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ProfileGridAction(
                icon: Icons.download_rounded,
                label: 'Receipts',
                iconBgColor: AppColors.primaryBrandLight,
                iconColor: AppColors.orangeTag,
                onTap: () => Get.toNamed(AppRoutes.studentReceiptsList),
              ),
            ),
            const SizedBox(width: 8),
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
        _buildInfoRow('Phone', info.phone),
        Divider(height: 1, color: AppColors.borderGrey.withValues(alpha: 0.5)),
        _buildInfoRow('Email', info.email),
        if (info.parentName != null) ...[
          Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          _buildInfoRow(
            info.parentRelation,
            '${info.parentName} • ${info.parentPhone ?? ''}',
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.outfit(
                fontSize: 14,
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
        Get.offAllNamed(AppRoutes.roleSelection);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.errorBg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Log out',
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPersonFallback extends StatelessWidget {
  const _AvatarPersonFallback();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.person_rounded,
        size: 44,
        color: AppColors.primaryBrand,
      ),
    );
  }
}
