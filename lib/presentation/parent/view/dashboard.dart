import 'package:fee_easy/core/widgets/app_status_badge.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/parent_bottom_nav.dart';
import 'package:fee_easy/core/widgets/task_card.dart';
import 'package:fee_easy/core/widgets/portal_app_bar.dart';
import 'package:fee_easy/core/widgets/section_header.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:get/get.dart';

class ParentDashboard extends StatelessWidget {
  final bool showBottomNav;
  const ParentDashboard({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.parentDashboardLabel,
              style: AppTextStyles.manrope(
                fontSize: AppSpacing.s10,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
              ),
            ),
            AppSpacing.v8,
            Text(
              AppStrings.dummyParentMonitoring,
              style: AppTextStyles.manrope(
                fontSize: AppSpacing.s24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v12,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSpacing.s8,
                      height: AppSpacing.s8,
                      decoration: const BoxDecoration(
                        color: AppColors.redDot, // Dark Red Dot
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppSpacing.h8,
                    Text(
                      AppStrings.dummyParentClass,
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.v24,

            // Attendance Status Card
            Container(
              padding: AppSpacing.all24,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.s24),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: AppSpacing.all12,
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(AppSpacing.s12),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryBrand,
                          size: AppSpacing.s24,
                        ),
                      ),
                      AppSpacing.h16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.attendanceStatus,
                              style: AppTextStyles.manrope(
                                fontSize: AppSpacing.s16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            AppSpacing.v4,
                            Text(
                              'Today, Oct 24th',
                              style: AppTextStyles.lexend(
                                fontSize: AppSpacing.s12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const AppStatusBadge(
                        text: 'PRESENT',
                        textColor: AppColors.greenText,
                        backgroundColor: AppColors.greenBg,
                      ),
                    ],
                  ),
                  AppSpacing.v24,
                  const Divider(color: AppColors.divider, thickness: 1.5),
                  AppSpacing.v24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ARRIVAL TIME',
                            style: AppTextStyles.manrope(
                              fontSize: AppSpacing.s10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                              letterSpacing: AppSpacing.s2,
                            ),
                          ),
                          AppSpacing.v4,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '08:15',
                                style: AppTextStyles.manrope(
                                  fontSize: AppSpacing.s24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.h4,
                              Text(
                                'AM',
                                style: AppTextStyles.manrope(
                                  fontSize: AppSpacing.s14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'MONTHLY RATE',
                            style: AppTextStyles.manrope(
                              fontSize: AppSpacing.s10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                              letterSpacing: AppSpacing.s2,
                            ),
                          ),
                          AppSpacing.v4,
                          Text(
                            '98.2%',
                            style: AppTextStyles.manrope(
                              fontSize: AppSpacing.s24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBrand,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.v24,

            // Fee Summary Card
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
                      Row(
                        children: [
                          Container(
                            padding: AppSpacing.all10,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.s12,
                              ),
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: AppSpacing.s20,
                            ),
                          ),
                          AppSpacing.h12,
                          Text(
                            AppStrings.feeSummary,
                            style: AppTextStyles.lexend(
                              fontSize: AppSpacing.s16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      AppButton(
                        label: AppStrings.payNow,
                        onPressed: () {},
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryBrand,
                        padding: AppSpacing.x16.add(AppSpacing.y8),
                        borderRadius: AppSpacing.s12,
                        fontSize: AppSpacing.s12,
                      ),
                    ],
                  ),
                  AppSpacing.v32,
                  Text(
                    '\$1,240.00',
                    style: AppTextStyles.manrope(
                      fontSize: AppSpacing.s32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  AppSpacing.v8,
                  Text(
                    'Outstanding Balance for Q4',
                    style: AppTextStyles.manrope(
                      fontSize: AppSpacing.s12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.v32,

            // Homework Tracker Section
            SectionHeader(
              title: AppStrings.homeworkTracker,
              actionLabel: AppStrings.viewAllAlt,
              onActionPressed: () =>
                  Get.toNamed(AppRoutes.parentHomeworkTracker),
            ),
            AppSpacing.v12,

            TaskCard(
              onTap: () => Get.toNamed(
                AppRoutes.parentHomeworkDetail,
                arguments: {
                  'title': 'Advanced Calculus: PS4',
                  'subject': 'Mathematics',
                  'status': 'Due in 2 days',
                  'statusColor': AppColors.textSecondary,
                },
              ),
              icon: Icons.functions,
              iconColor: AppColors.indigoDark,
              iconBgColor: AppColors.primaryBrandLight,
              title: 'Advanced Calculus: PS4',
              subject: 'Mathematics',
              statusText: 'Due in 2 days',
              statusColor: AppColors.textSecondary,
              progressValue: 0.5,
            ),
            AppSpacing.v12,
            TaskCard(
              onTap: () => Get.toNamed(
                AppRoutes.parentHomeworkDetail,
                arguments: {
                  'title': 'Photosynthesis Lab Report',
                  'subject': 'Biology',
                  'status': 'Completed Today',
                  'statusColor': AppColors.checkGreen,
                },
              ),
              icon: Icons.science_outlined,
              iconColor: AppColors.amberDark,
              iconBgColor: AppColors.amberLight,
              title: 'Photosynthesis Lab Report',
              subject: 'Biology',
              statusText: 'Completed Today',
              statusColor: AppColors.checkGreen,
              completed: true,
            ),
            AppSpacing.v12,
            TaskCard(
              icon: Icons.menu_book,
              iconColor: AppColors.primaryBrand,
              iconBgColor: AppColors.primaryBrandLight,
              title: 'Modern Literature Analysis',
              subject: 'English',
              statusText: 'Due Tomorrow',
              statusColor: AppColors.orangeDue,
              progressValue: 0.2,
            ),

            AppSpacing.v32,

            // Recent Updates Section
            Row(
              children: [
                const Icon(
                  Icons.history,
                  color: AppColors.primaryBrand,
                  size: AppSpacing.s24,
                ),
                AppSpacing.h8,
                Text(
                  AppStrings.recentUpdates,
                  style: AppTextStyles.manrope(
                    fontSize: AppSpacing.s18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            AppSpacing.v24,

            // Timeline View
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s8),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Line configuration
                        SizedBox(
                          width: AppSpacing.s16,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: AppSpacing.s2,
                                color: AppColors.borderGrey,
                              ),
                              Container(
                                width: AppSpacing.s12,
                                height: AppSpacing.s12,
                                margin: const EdgeInsets.only(
                                  top: AppSpacing.s2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrand,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryBrandLight,
                                    width: AppSpacing.s4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.h16,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.s32,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First Update Item
                                Text(
                                  'TODAY, 10:30 AM',
                                  style: AppTextStyles.manrope(
                                    fontSize: AppSpacing.s10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryBrand,
                                    letterSpacing: AppSpacing.s2,
                                  ),
                                ),
                                AppSpacing.v8,
                                _buildTimelineCard(
                                  title: 'New Grade Posted',
                                  description:
                                      'Leo scored an A- in the Biology midterm assessment. Significant improvement in lab technique.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: AppSpacing.s16,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: AppSpacing.s12,
                                height: AppSpacing.s12,
                                margin: const EdgeInsets.only(
                                  top: AppSpacing.s2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: AppSpacing.s4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.h16,
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.s16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Second Update Item
                                Text(
                                  'YESTERDAY',
                                  style: AppTextStyles.manrope(
                                    fontSize: AppSpacing.s10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textSecondary,
                                    letterSpacing: AppSpacing.s2,
                                  ),
                                ),
                                AppSpacing.v8,
                                _buildTimelineCard(
                                  title: 'Event Invitation',
                                  description:
                                      'Annual Science Fair registration is now open. Click to view schedule and requirements.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
        title: "Julian Smith", // Student name
        profileRoute: AppRoutes.parentStudentProfile,
        notificationsRoute: AppRoutes.parentUpdates,
      ),
      body: content,
      bottomNavigationBar: showBottomNav
          ? const ParentBottomNav(currentIndex: 0)
          : null,
    );
  }

  Widget _buildTimelineCard({
    required String title,
    required String description,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: AppSpacing.s14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            description,
            style: AppTextStyles.lexend(
              fontSize: AppSpacing.s12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
