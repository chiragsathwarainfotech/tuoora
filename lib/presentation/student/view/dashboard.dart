import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/controllers/student_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_section_header.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';

class StudentDashboard extends StatelessWidget {
  final bool showBottomNav;
  const StudentDashboard({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    final user = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>().currentUser
        : null;
    final firstName = (user?.name.split(' ').first ?? 'there').trim();
    final initials = _initialsFor(user?.name ?? '');

    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(firstName: firstName, initials: initials),
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
                    const _TodayClassCard(),
                    const SizedBox(height: AppSpacing.s24),
                    StudentSectionHeader(
                      title: "TODAY'S ASSIGNMENTS",
                      showSeeAll: true,
                      onActionTap: _openAssignmentsTab,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    GestureDetector(
                      onTap: () => _openAssignmentDetail(0),
                      child: const _AssignmentTile(
                        title: 'Trigonometry — Ch. 8 exercises',
                        subject: 'Mathematics',
                        dueLabel: 'Today',
                        isToday: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    GestureDetector(
                      onTap: () => _openAssignmentDetail(1),
                      child: const _AssignmentTile(
                        title: 'Light: Reflection notes',
                        subject: 'Physics',
                        dueLabel: 'Tomorrow',
                        isToday: false,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    const StudentSectionHeader(
                      title: "TODAY'S ATTENDANCE",
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    GestureDetector(
                      onTap: _openAttendanceTab,
                      child: const _AttendanceCard(
                        status: 'Present',
                        detail: 'Checked in at 8:00 AM • Mathematics',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    StudentSectionHeader(
                      title: 'STUDY MATERIAL THIS WEEK',
                      showSeeAll: true,
                      onActionTap: () => Get.toNamed(AppRoutes.studentStudyMaterial),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    GestureDetector(
                      onTap: () => _openStudyMaterialDetail({
                        'subject': 'Mathematics',
                        'date': 'Today',
                        'title': 'Trigonometry — quick reference',
                        'description': 'All Class X trig identities, complementary-angle formulas, and sign chart on one page. Print and stick inside your notebook.',
                        'fileCount': 1,
                        'isVideo': false,
                        'teacher': 'Mr. R. Verma',
                        'subjectBgColor': 0xFFFEF2F2,
                        'subjectTextColor': 0xFF991B1B,
                      }),
                      child: const _StudyMaterialTile(
                        title: 'Trigonometry — quick reference',
                        meta: 'Mathematics · 1 file · Today',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                    GestureDetector(
                      onTap: () => _openStudyMaterialDetail({
                        'subject': 'Physics',
                        'date': 'Wed',
                        'title': 'Reflection — concept video',
                        'description': 'A 6-minute walkthrough of plane mirrors, the angle of incidence/reflection, and image formation. Watch before...',
                        'fileCount': 1,
                        'isVideo': true,
                        'teacher': 'Mrs. Iyer',
                        'subjectBgColor': 0xFFFEF2F2,
                        'subjectTextColor': 0xFF991B1B,
                      }),
                      child: const _StudyMaterialTile(
                        title: 'Reflection — concept video',
                        meta: 'Physics · 1 file · Wed',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s24),
                    StudentSectionHeader(
                      title: 'PENDING FEES',
                      actionLabel: 'History',
                      onActionTap: _openFeesTab,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    GestureDetector(
                      onTap: _openFeesTab,
                      child: const _PendingFeeTile(
                        title: 'May 2026 · ₹4,500 due',
                        detail: 'Due 25 May · pay at institute',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          showBottomNav ? const StudentBottomNav(currentIndex: 0) : null,
    );
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty);
    if (parts.isEmpty) return 'AS';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// Switches the bottom-nav `PageView` to the Assignments tab. When the
  /// dashboard is opened standalone (no surrounding StudentController, e.g.
  /// during testing), it falls back to a route push.
  static void _openAssignmentsTab() {
    if (Get.isRegistered<StudentController>()) {
      Get.find<StudentController>().changePage(1);
    } else {
      Get.toNamed(AppRoutes.studentHomework);
    }
  }

  static void _openAssignmentDetail(int index) {
    if (!Get.isRegistered<AssignmentsController>()) {
      Get.put(AssignmentsController());
    }
    final ctrl = Get.find<AssignmentsController>();
    if (ctrl.pending.length > index) {
      ctrl.openAssignment(ctrl.pending[index]);
    }
  }

  static void _openAttendanceTab() {
    if (Get.isRegistered<StudentController>()) {
      Get.find<StudentController>().changePage(3);
    }
  }

  static void _openStudyMaterialDetail(Map<String, dynamic> material) {
    Get.toNamed(AppRoutes.studentStudyMaterialDetail, arguments: material);
  }

  static void _openFeesTab() {
    if (Get.isRegistered<StudentController>()) {
      Get.find<StudentController>().changePage(2);
    }
  }
}

class _Header extends StatelessWidget {
  final String firstName;
  final String initials;
  const _Header({required this.firstName, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
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
                    child: Row(
                      children: [
                        Text(
                          'Hi, $firstName',
                          style: AppTextStyles.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.h4,
                        const Text('👋', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _HeaderIconButton(
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () => Get.toNamed(AppRoutes.studentChat),
          ),
          AppSpacing.h8,
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            hasBadge: true,
            onTap: () => Get.toNamed(AppRoutes.studentNotifications),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;
  final VoidCallback onTap;
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.s40,
        height: AppSpacing.s40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.s12),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Icon(icon, size: 18, color: AppColors.textPrimary),
            ),
            if (hasBadge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.bohoRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TodayClassCard extends StatelessWidget {
  const _TodayClassCard();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final day = today.day.toString().padLeft(2, '0');
    final month = _shortMonth(today.month).toUpperCase();
    final weekdayLabel = _weekdayShort(today.weekday).toUpperCase();

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
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 8,
            bottom: 8,
            child: Opacity(
              opacity: 0.08,
              child: Text(
                'Σ',
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
                  decoration: BoxDecoration(
                    color: AppColors.studentBrand,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.s20),
                      bottomLeft: Radius.circular(AppSpacing.s20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: AppTextStyles.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        month,
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
                          '$weekdayLabel • TODAY\'S CLASS',
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mathematics',
                          style: AppTextStyles.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '8:00 AM • Mr. Verma • Trigonometry, Ch. 8',
                          style: AppTextStyles.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        _WeekStrip(activeWeekday: today.weekday),
                      ],
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

  String _shortMonth(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m - 1];
  }

  String _weekdayShort(int wd) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[wd - 1];
  }
}

class _WeekStrip extends StatelessWidget {
  final int activeWeekday;
  const _WeekStrip({required this.activeWeekday});

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final wd = i + 1;
        final isPast = wd < activeWeekday;
        final isActive = wd == activeWeekday;
        final Color dotColor = isActive
            ? AppColors.studentBrandAccent
            : isPast
                ? AppColors.successGreen
                : AppColors.borderGrey;
        return Column(
          children: [
            Text(
              labels[i],
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
      }),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final String title;
  final String subject;
  final String dueLabel;
  final bool isToday;
  const _AssignmentTile({
    required this.title,
    required this.subject,
    required this.dueLabel,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final pillBg = isToday
        ? AppColors.studentTodayPillBg
        : AppColors.studentTomorrowPillBg;
    final pillText = isToday
        ? AppColors.studentTodayPillText
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
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$subject • $dueLabel',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
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
              color: pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Text(
              dueLabel,
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
              color: AppColors.studentPresentBg,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.studentPresentText,
              size: 20,
            ),
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
                    color: AppColors.studentPresentText,
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
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
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
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

class _PendingFeeTile extends StatelessWidget {
  final String title;
  final String detail;
  const _PendingFeeTile({required this.title, required this.detail});

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
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
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
          AppSpacing.h8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: AppColors.studentTomorrowPillBg,
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

class _UpdateTile extends StatelessWidget {
  final String title;
  final String timestamp;
  final String body;
  const _UpdateTile({
    required this.title,
    required this.timestamp,
    required this.body,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.studentUpdateIconBg,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.studentUpdateIconColor,
              size: 20,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      timestamp,
                      style: AppTextStyles.lexend(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
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
}
