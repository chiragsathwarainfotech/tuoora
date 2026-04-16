import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/widgets/student_bottom_nav.dart';
import 'package:fee_easy/core/widgets/portal_app_bar.dart';
import 'package:fee_easy/core/widgets/section_header.dart';
import 'package:fee_easy/core/widgets/app_status_badge.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/homework_tile.dart';
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
                color: AppColors.primaryBlue,
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
                color: Colors.white,
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
                        CircularProgressIndicator(
                          value: 0.92,
                          strokeWidth: AppSpacing.s12,
                          backgroundColor: AppColors.divider,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryBlue,
                          ),
                          strokeCap: StrokeCap.round,
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
                        textColor: Colors.white,
                        backgroundColor: AppColors.intenseBlue,
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
                                  color: AppColors.primaryBlue,
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
                                  color: AppColors.primaryBlue,
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
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(AppSpacing.s24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
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
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppSpacing.s12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: AppSpacing.s24,
                        ),
                      ),
                      const AppStatusBadge(
                        text: 'PAID',
                        textColor: Colors.white,
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
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  AppSpacing.v8,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$ ',
                        style: AppTextStyles.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '0.00',
                        style: AppTextStyles.manrope(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.0,
                    ),
                  ),
                  AppSpacing.v24,
                  AppButton(
                    label: AppStrings.viewFeeHistory,
                    onPressed: () => Get.toNamed(AppRoutes.studentFeeHistory),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
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
                  'statusColor': AppColors.redDot,
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
            AppSpacing.v32,
            Text(
              AppStrings.latestNews,
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v16,
            Container(
              height: AppSpacing.s240,
              decoration: BoxDecoration(
                color: const Color(0xFF0052C2),
                borderRadius: BorderRadius.circular(AppSpacing.s32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: AppSpacing.s12,
                    offset: const Offset(0, AppSpacing.s6),
                  ),
                ],
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.s24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                padding: AppSpacing.all24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s10,
                        vertical: AppSpacing.s4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppSpacing.s20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'CAMPUS LIFE',
                        style: AppTextStyles.manrope(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    AppSpacing.v12,
                    Text(
                      'New Innovation Hub\nOpening This Fall',
                      style: AppTextStyles.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    AppSpacing.v8,
                    Text(
                      'Aeon Academy is proud to announce the\ncompletion of our state-of-the-art...',
                      style: AppTextStyles.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.v32,
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PortalAppBar(
        title: AppStrings.appName,
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
