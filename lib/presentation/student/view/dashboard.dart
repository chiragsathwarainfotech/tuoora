import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/controllers/student_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/widgets/student_section_header.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';
import 'package:tuoora/presentation/student/controllers/student_dashboard_controller.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/data/models/student_dashboard_model.dart';
import 'package:tuoora/data/models/student_resource_model.dart';

class StudentDashboard extends GetView<StudentDashboardController> {
  final bool showBottomNav;
  const StudentDashboard({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.studentBrand),
            );
          }
          final data = controller.dashboardData.value;
          if (data == null) {
            return const Center(child: Text('No dashboard data found'));
          }

          final todayClass = controller.todayClassDisplay;
          final assignmentItems = controller.dashboardAssignments;

          return Column(
            children: [
              StudentAppBar(
                isRoot: true,
                titleWidget: _GreetingTitle(
                  firstName: controller.studentFirstName,
                  initials: controller.studentInitials,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s16,
                    AppSpacing.s8,
                    AppSpacing.s16,
                    AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (todayClass != null) ...[
                        _TodayClassCard(
                          display: todayClass,
                          weekDays: data.weekAttendanceDays,
                        ),
                        const SizedBox(height: AppSpacing.s24),
                      ],
                      if (assignmentItems.isNotEmpty) ...[
                        StudentSectionHeader(
                          title: "ASSIGNMENTS",
                          showSeeAll: true,
                          onActionTap: _openAssignmentsTab,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ...assignmentItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.s8,
                            ),
                            child: GestureDetector(
                              onTap: () =>
                                  _openAssignmentDetail(item.assignment),
                              child: _AssignmentTile(item: item),
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.s16),
                      ],
                      const StudentSectionHeader(title: "TODAY'S ATTENDANCE"),
                      const SizedBox(height: AppSpacing.s12),
                      GestureDetector(
                        onTap: _openAttendanceTab,
                        child: _AttendanceCard(
                          status: data.todayAttendance.status,
                          detail: data.todayAttendance.text,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      if (data.studyMaterials.isNotEmpty) ...[
                        StudentSectionHeader(
                          title: 'STUDY MATERIAL THIS WEEK',
                          showSeeAll: true,
                          onActionTap: () =>
                              Get.toNamed(AppRoutes.studentStudyMaterial),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ...data.studyMaterials.take(2).map((material) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.s8,
                            ),
                            child: GestureDetector(
                              onTap: () => _openStudyMaterialDetail(material),
                              child: _StudyMaterialTile(
                                title: material.title,
                                meta:
                                    "${material.subject} • ${material.timeLabel}",
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.s16),
                      ],
                      if (data.pendingFees.isNotEmpty) ...[
                        StudentSectionHeader(
                          title: 'PENDING FEES',
                          actionLabel: 'History',
                          onActionTap: _openFeesTab,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ...data.pendingFees.take(2).map((fee) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.s8,
                            ),
                            child: GestureDetector(
                              onTap: _openFeesTab,
                              child: _PendingFeeTile(
                                date: fee.monthYear,
                                dueAmount: fee.dueAmount.toString(),
                                status: fee.status,
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 0)
          : null,
    );
  }

  static void _openAssignmentsTab() {
    if (Get.isRegistered<StudentController>()) {
      Get.find<StudentController>().changePage(1);
    } else {
      Get.toNamed(AppRoutes.studentHomework);
    }
  }

  static void _openAssignmentDetail(Assignment assignment) {
    if (!Get.isRegistered<AssignmentsController>()) {
      Get.put(AssignmentsController());
    }
    final ctrl = Get.find<AssignmentsController>();
    ctrl.openAssignment(assignment);
  }

  static void _openAttendanceTab() {
    if (Get.isRegistered<StudentController>()) {
      Get.find<StudentController>().changePage(3);
    }
  }

  static void _openStudyMaterialDetail(StudentResourceModel material) {
    Get.toNamed(AppRoutes.studentStudyMaterialDetail, arguments: material);
  }

  static void _openFeesTab() {
    if (Get.isRegistered<StudentController>()) {
      Get.find<StudentController>().changePage(2);
    }
  }
}

class _GreetingTitle extends StatelessWidget {
  final String firstName;
  final String initials;
  const _GreetingTitle({required this.firstName, required this.initials});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<StudentController>()) {
          Get.find<StudentController>().changePage(4);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.s18,
            backgroundColor: AppColors.studentBrandSoft,
            child: Text(
              initials,
              style: AppTextStyles.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.studentBrand,
              ),
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Text(
              'Hi, $firstName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayClassCard extends StatelessWidget {
  final TodayClassDisplay display;
  final List<WeekAttendanceDay> weekDays;

  const _TodayClassCard({required this.display, required this.weekDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: 8,
              bottom: 8,
              child: Opacity(
                opacity: 0.08,
                child: Text(
                  'S',
                  style: AppTextStyles.manrope(
                    fontSize: 160,
                    fontWeight: FontWeight.w800,
                    color: AppColors.studentBrand,
                    height: 1,
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.studentBrand,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          display.dayNumber,
                          style: AppTextStyles.manrope(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          display.monthLabel,
                          style: AppTextStyles.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${display.weekdayLabel}  •  ${display.headerLabel}',
                            style: AppTextStyles.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textTertiary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            display.subject,
                            style: AppTextStyles.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            display.subtitle,
                            style: AppTextStyles.lexend(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          _WeekStrip(weekDays: weekDays),
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
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final List<WeekAttendanceDay> weekDays;
  const _WeekStrip({required this.weekDays});

  @override
  Widget build(BuildContext context) {
    if (weekDays.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((day) {
        final isActive = day.date == DateTime.now().toString().substring(0, 10);
        final isPresent = day.status.toLowerCase() == 'present';
        final isAbsent = day.status.toLowerCase() == 'absent';

        Color dotColor = AppColors.borderGrey;
        if (isPresent) {
          dotColor = AppColors.successGreen;
        } else if (isAbsent) {
          dotColor = AppColors.bohoRed;
        } else if (isActive) {
          dotColor = AppColors.orangeTag;
        }

        return Column(
          children: [
            Text(
              day.day,
              style: AppTextStyles.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final DashboardAssignmentDisplay item;
  const _AssignmentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final pillBg = item.isSubmitted
        ? AppColors.studentBrandSoft
        : AppColors.amberLight;
    final pillText = item.isSubmitted
        ? AppColors.studentBrand
        : AppColors.studentTomorrowPillText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.studentBrandSoft,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: AppColors.studentBrand,
              size: 20,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.dueLabel.isEmpty
                      ? item.subject
                      : '${item.subject}  •  ${item.dueLabel}',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppSpacing.h8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Text(
              item.status,
              style: AppTextStyles.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: pillText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final String status;
  final String detail;
  const _AttendanceCard({required this.status, required this.detail});

  @override
  Widget build(BuildContext context) {
    final isNotMarked = status.toLowerCase() == 'not marked';
    final bgColor = isNotMarked
        ? AppColors.primaryBrand
        : AppColors.studentPresentBg;
    final iconColor = isNotMarked
        ? AppColors.white
        : AppColors.studentPresentText;
    final textColor = isNotMarked
        ? AppColors.textPrimary
        : AppColors.studentPresentText;
    final icon = isNotMarked ? Icons.close_rounded : Icons.check_rounded;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _StudyMaterialTile extends StatelessWidget {
  final String title;
  final String meta;
  const _StudyMaterialTile({required this.title, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.studentBrandSoft,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: AppColors.studentBrand,
              size: 20,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _PendingFeeTile extends StatelessWidget {
  final String date;
  final String dueAmount;
  final String status;

  const _PendingFeeTile({
    required this.date,
    required this.dueAmount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.studentBrandSoft,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(
              Icons.currency_rupee_rounded,
              color: AppColors.studentBrand,
              size: 20,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$dueAmount • $status",
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.h8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.amberLight,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Text(
              'Pending',
              style: AppTextStyles.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.studentTomorrowPillText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
