import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:get/get.dart';

class InstituteDrawer extends StatelessWidget {
  const InstituteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<InstituteProfileController>();

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.v24,
            Padding(
              padding: AppSpacing.x24,
              child: Obx(
                () => GestureDetector(
                  onTap: () {
                    Get.back(); // Close drawer
                    Get.toNamed(AppRoutes.instituteProfile);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: AppSpacing.s48,
                        height: AppSpacing.s48,
                        decoration: BoxDecoration(
                          color: AppColors.inputSolidGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: profileController.profileImagePath.value == null
                            ? const Center(
                                child: Icon(
                                  Icons.school_rounded,
                                  color: AppColors.instPrimaryBlue,
                                  size: 24,
                                ),
                              )
                            : null,
                      ),
                      AppSpacing.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileController.instituteName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.instPrimaryBlue,
                              ),
                            ),
                            Text(
                              AppStrings.instDrawerAdminRole,
                              style: AppTextStyles.lexend(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.v32,

            // Navigation Items
            _buildDrawerItem(
              icon: Icons.grid_view_rounded,
              label: AppStrings.instNavDashboard,
              isActive: true,
              onTap: () {
                Get.back();
              },
            ),
            _buildDrawerItem(
              icon: Icons.fact_check_outlined,
              label: AppStrings.instDrawerAttendance,
              isActive: false,
              onTap: () {
                Get.toNamed(AppRoutes.instituteAttendanceMarking);
              },
            ),
            _buildDrawerItem(
              icon: Icons.bar_chart_rounded,
              label: AppStrings.instDrawerReports,
              isActive: false,
              onTap: () => Get.toNamed(AppRoutes.instituteReports),
            ),
            _buildDrawerItem(
              icon: Icons.supervisor_account_rounded,
              label: AppStrings.instDrawerTeacherManagement,
              isActive: false,
              onTap: () {
                Get.back();
                Get.snackbar('Coming Soon', 'Teachers feature is under development');
              },
            ),
            _buildDrawerItem(
              icon: Icons.description_outlined,
              label: AppStrings.instDrawerNotesManagement,
              isActive: false,
              onTap: () {
                Get.back();
                Get.snackbar('Coming Soon', 'Notes feature is under development');
              },
            ),
            _buildDrawerItem(
              icon: Icons.receipt_long_outlined,
              label: AppStrings.instDrawerExpenseManagement,
              isActive: false,
              onTap: () {
                Get.back();
                Get.snackbar('Coming Soon', 'Expenses feature is under development');
              },
            ),
            _buildDrawerItem(
              icon: Icons.leaderboard_rounded,
              label: AppStrings.instDrawerLeadManagement,
              isActive: false,
              onTap: () {
                Get.back();
                Get.snackbar('Coming Soon', 'Leads feature is under development');
              },
            ),
            _buildDrawerItem(
              icon: Icons.campaign_rounded,
              label: AppStrings.instDrawerStudentEngagement,
              isActive: false,
              onTap: () {
                Get.back();
                Get.snackbar('Coming Soon', 'Engagement feature is under development');
              },
            ),
            _buildDrawerItem(
              icon: Icons.history_rounded,
              label: AppStrings.instDrawerUpdates,
              isActive: false,
              onTap: () => Get.toNamed(AppRoutes.instituteUpdates),
            ),

            const Spacer(),

            // Footer
            Container(height: 1, color: const Color(0xFFF3F4F6)),
            Padding(
              padding: AppSpacing.all24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.instDrawerAppVersion,
                    style: AppTextStyles.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.instPrimaryBlue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(
                        '/login',
                      ); // Assuming logout returns to shared login
                    },
                    child: const Icon(
                      Icons.logout_rounded, // or Icons.exit_to_app
                      color: AppColors.textTertiary,
                      size: AppSpacing.s20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: AppSpacing.x16.add(AppSpacing.y4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: AppSpacing.x16.add(
            const EdgeInsets.symmetric(vertical: AppSpacing.s14),
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.instLightBlueBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.instPrimaryBlue
                    : AppColors.textTertiary,
                size: AppSpacing.s22,
              ),
              AppSpacing.h16,
              Text(
                label,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive
                      ? AppColors.instPrimaryBlue
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
