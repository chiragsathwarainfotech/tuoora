import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/core/widgets/portal_app_bar.dart';
import 'package:tuoora/core/widgets/section_header.dart';
import 'package:tuoora/core/widgets/app_status_badge.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/homework_tile.dart';
import 'package:get/get.dart';

class StudentDashboard extends StatelessWidget {
  final bool showBottomNav;
  const StudentDashboard({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              AppStrings.studentOverviewLabel,
              style: AppTextStyles.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
                letterSpacing: 1.5,
              ),
            ),
            AppSpacing.v4,
            Text(
              AppStrings.dummyStudentGreeting,
              style: AppTextStyles.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v4,
            Text(
              AppStrings.dummyStudentSubtitle,
              style: AppTextStyles.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
                height: 1.5,
              ),
            ),
            AppSpacing.v24,
            Container(
              padding: AppSpacing.all24,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.s16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: AppSpacing.s16,
                    offset: const Offset(0, AppSpacing.s8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Circular Progress
                  SizedBox(
                    width: AppSpacing.s140,
                    height: AppSpacing.s140,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CommonLoading(
                          value: 0.92,
                          strokeWidth: AppSpacing.s12,
                          color: AppColors.primaryBrand,
                          size: AppSpacing.s140,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              100.toInt() ==
                                      100 // dummy logic for safety
                                  ? Text(
                                      '92%',
                                      style: AppTextStyles.manrope(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    )
                                  : const SizedBox(),
                              Text(
                                'ATTENDANCE',
                                style: AppTextStyles.manrope(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textTertiary,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.v32,
                  Row(
                    children: [
                      Text(
                        AppStrings.academicProgress,
                        style: AppTextStyles.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.h8,
                      const AppStatusBadge(
                        text: 'TOP\n5%',
                        textColor: AppColors.white,
                        backgroundColor: AppColors.primaryBrand,
                      ),
                    ],
                  ),
                  AppSpacing.v4,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Consistency is the key to\nmastery.',
                      style: AppTextStyles.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  AppSpacing.v24,

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: AppSpacing.all16,
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(AppSpacing.s16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CURRENT GPA',
                                style: AppTextStyles.manrope(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              AppSpacing.v4,
                              Text(
                                '3.92',
                                style: AppTextStyles.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryBrand,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.h16,
                      Expanded(
                        child: Container(
                          padding: AppSpacing.all16,
                          decoration: BoxDecoration(
                            color: AppColors.inputBg,
                            borderRadius: BorderRadius.circular(AppSpacing.s16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CREDITS',
                                style: AppTextStyles.manrope(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              AppSpacing.v4,
                              Text(
                                '24/30',
                                style: AppTextStyles.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryBrand,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.v24,
            Container(
              padding: AppSpacing.all24,
              decoration: BoxDecoration(
                color: AppColors.primaryBrand,
                borderRadius: BorderRadius.circular(AppSpacing.s24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBrand.withValues(alpha: 0.2),
                    blurRadius: AppSpacing.s16,
                    offset: const Offset(0, AppSpacing.s8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: AppSpacing.all12,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppSpacing.s12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.white,
                          size: AppSpacing.s24,
                        ),
                      ),
                      const AppStatusBadge(
                        text: 'PAID',
                        textColor: AppColors.white,
                        backgroundColor: AppColors.orangeTag,
                      ),
                    ],
                  ),
                  AppSpacing.v24,
                  Text(
                    AppStrings.financialHealth,
                    style: AppTextStyles.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  AppSpacing.v8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹ ',
                        style: AppTextStyles.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '0.00',
                        style: AppTextStyles.manrope(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v12,
                  Text(
                    'BALANCE DUE FOR TERM 2',
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.0,
                    ),
                  ),
                  AppSpacing.v24,
                  AppButton(
                    label: AppStrings.viewFeeHistory,
                    onPressed: () => Get.toNamed(AppRoutes.studentFeeHistory),
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primaryBrand,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
            AppSpacing.v32,
            SectionHeader(
              title: AppStrings.homeworkTracker,
              actionLabel: AppStrings.viewAll,
              onActionPressed: () =>
                  Get.toNamed(AppRoutes.parentHomeworkTracker),
            ),
            AppSpacing.v12,
            HomeworkTile(
              onTap: () => Get.toNamed(
                AppRoutes.parentHomeworkDetail,
                arguments: {
                  'title': 'Advanced Calculus',
                  'subject': 'Mathematics',
                  'status': 'DUE TODAY',
                  'statusColor': AppColors.error,
                },
              ),
              icon: Icons.functions,
              title: 'Advanced Calculus',
              subject: 'Mathematics',
              dueDate: 'DUE TODAY',
              status: 'High Priority',
            ),
            AppSpacing.v12,
            HomeworkTile(
              onTap: () => Get.toNamed(
                AppRoutes.parentHomeworkDetail,
                arguments: {
                  'title': 'Molecular Biology',
                  'subject': 'Biology',
                  'status': 'NOV 24',
                  'statusColor': AppColors.textSecondary,
                },
              ),
              icon: Icons.science_outlined,
              title: 'Molecular Biology',
              subject: 'Biology',
              dueDate: 'NOV 24',
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PortalAppBar(
        title: "Julian Smith", // Student name
        profileRoute: AppRoutes.studentSettings,
        notificationsRoute: AppRoutes.studentNotifications,
      ),
      body: content,
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 0)
          : null,
    );
  }
}
