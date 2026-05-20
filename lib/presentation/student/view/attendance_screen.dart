import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/controllers/attendance_history_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_section_header.dart';

class AttendanceScreen extends GetView<AttendanceHistoryController> {
  final bool showBottomNav;
  const AttendanceScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
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
                    StudentSectionHeader(title: 'TODAY'),
                    const SizedBox(height: AppSpacing.s12),
                    _buildTodayCard(),
                    const SizedBox(height: AppSpacing.s24),
                    StudentSectionHeader(title: 'MONTH'),
                    const SizedBox(height: AppSpacing.s12),
                    _buildMonthCard(),
                    const SizedBox(height: AppSpacing.s24),
                    StudentSectionHeader(title: 'MONTHLY SUMMARY'),
                    const SizedBox(height: AppSpacing.s12),
                    _buildSummaryCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 3)
          : null,
    );
  }

  Widget _buildHeader() {
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
            child: Obx(
              () => Text(
                '${controller.currentMonthName} ${controller.currentYear}',
                style: AppTextStyles.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          HeaderIconButton(
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () => Get.toNamed(AppRoutes.studentChat),
          ),
          AppSpacing.h8,
          HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            hasBadge: true,
            onTap: () => Get.toNamed(controller.updatesRoute),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayCard() {
    final now = DateTime.now();
    final dayStr =
        '${_weekdayName(now.weekday)}, ${now.day} ${_shortMonth(now.month)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.studentPresentBg,
              borderRadius: BorderRadius.circular(AppSpacing.s8),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.studentPresentText,
              size: 24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Present',
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.studentPresentText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dayStr - checked in at 8:00 AM',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: AppSpacing.s16),
          _buildGoToTodayButton(),
          const SizedBox(height: AppSpacing.s16),
          _buildCalendarGrid(),
          const SizedBox(height: AppSpacing.s24),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircleNavButton(Icons.chevron_left, controller.prevMonth),
        Obx(
          () => Text(
            '${controller.currentMonthName} ${controller.currentYear}',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        _buildCircleNavButton(Icons.chevron_right, controller.nextMonth),
      ],
    );
  }

  Widget _buildCircleNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.s36,
        height: AppSpacing.s36,
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppSpacing.s8),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
    );
  }

  Widget _buildGoToTodayButton() {
    final now = DateTime.now();
    final todayStr =
        '${now.day} ${_shortMonth(now.month).toUpperCase()} ${now.year}';
    return GestureDetector(
      onTap: controller.goToToday,
      child: CustomPaint(
        painter: _DashedRectPainter(color: AppColors.studentBrandAccent),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s10,
            horizontal: AppSpacing.s12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    size: 16,
                    color: AppColors.studentBrandAccent,
                  ),
                  AppSpacing.h8,
                  Text(
                    'TODAY - $todayStr',
                    style: AppTextStyles.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.studentBrandAccent,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'GO TO TODAY',
                    style: AppTextStyles.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.studentBrandAccent,
                    ),
                  ),
                  AppSpacing.h4,
                  Icon(
                    Icons.arrow_right_alt,
                    size: 16,
                    color: AppColors.studentBrandAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Obx(() {
      final now = DateTime.now();
      final viewDate = controller.viewDate.value;
      final isCurrentMonth =
          viewDate.year == now.year && viewDate.month == now.month;

      int daysInMonth = DateTime(viewDate.year, viewDate.month + 1, 0).day;
      int firstWeekday = DateTime(viewDate.year, viewDate.month, 1).weekday;

      // Convert to 0-6 where 0 is Sunday
      int startOffset = firstWeekday == 7 ? 0 : firstWeekday;

      List<Widget> rows = [];

      // Header
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: AppTextStyles.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
      rows.add(const SizedBox(height: AppSpacing.s12));

      List<Widget> currentRow = [];

      // Previous month days (dashed)
      int prevDaysInMonth = DateTime(viewDate.year, viewDate.month, 0).day;
      for (int i = 0; i < startOffset; i++) {
        int d = prevDaysInMonth - startOffset + i + 1;
        currentRow.add(Expanded(child: _buildDateBubble('$d', 'p_dashed')));
      }

      for (int day = 1; day <= daysInMonth; day++) {
        String type = 'p';

        int currentWeekday = DateTime(
          viewDate.year,
          viewDate.month,
          day,
        ).weekday;

        if (currentWeekday == 6 || currentWeekday == 7) {
          type = 'p';
        } else if (isCurrentMonth) {
          if (day > now.day) {
            type = 'p';
          } else {
            if (day % 7 == 0) {
              type = 'a';
            } else if (day % 13 == 0) {
              type = 'h';
            } else {
              type = 'p';
            }
          }
        } else if (viewDate.isAfter(now)) {
          type = 'p';
        } else {
          if (day % 8 == 0) {
            type = 'a';
          } else if (day % 15 == 0) {
            type = 'h';
          } else {
            type = 'p';
          }
        }

        currentRow.add(Expanded(child: _buildDateBubble('$day', type)));

        if (currentRow.length == 7) {
          rows.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: currentRow,
            ),
          );
          if (day < daysInMonth) {
            rows.add(const SizedBox(height: AppSpacing.s8));
          }
          currentRow = [];
        }
      }

      if (currentRow.isNotEmpty) {
        while (currentRow.length < 7) {
          currentRow.add(const Expanded(child: SizedBox()));
        }
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: currentRow,
          ),
        );
      }

      return Column(children: rows);
    });
  }

  Widget _buildDateBubble(String day, String type) {
    Color bg;
    Color fg;
    bool isDashed = false;

    switch (type) {
      case 'p': // Present
        bg = const Color(0xFFDCFCE7); // studentPresentBg
        fg = const Color(0xFF15803D); // studentPresentText
        break;
      case 'a': // Absent
        bg = const Color(0xFFFEF2F2);
        fg = const Color(0xFFB91C1C);
        break;
      case 'h': // Holiday
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
        break;
      case 'p_dashed': // Previous month (dashed)
        bg = Colors.transparent;
        fg = AppColors.textTertiary;
        isDashed = true;
        break;
      default:
        bg = AppColors.scaffoldBg;
        fg = AppColors.textTertiary;
    }

    Widget content = Center(
      child: Text(
        day,
        style: AppTextStyles.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );

    if (isDashed) {
      return Center(
        child: CustomPaint(
          painter: _DashedRectPainter(color: AppColors.borderLightGray),
          child: SizedBox(
            width: AppSpacing.s36,
            height: AppSpacing.s36,
            child: content,
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          width: AppSpacing.s36,
          height: AppSpacing.s36,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSpacing.s8),
          ),
          child: content,
        ),
      );
    }
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(const Color(0xFF15803D), 'Present'),
        AppSpacing.h12,
        _legendItem(const Color(0xFFB91C1C), 'Absent'),
        AppSpacing.h12,
        _legendItem(const Color(0xFF92400E), 'Holiday'),
        AppSpacing.h12,
        _legendItem(AppColors.borderLightGray, 'No class'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        ),
        AppSpacing.h4,
        Text(
          label,
          style: AppTextStyles.lexend(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final stats = controller.currentMonthStats;
        final total = stats['total']!;
        final present = stats['present']!;
        final percent = total > 0 ? ((present / total) * 100).round() : 100;

        return Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CustomPaint(
                painter: _SummaryRingPainter(percent: percent),
                child: Center(
                  child: Text(
                    '$percent%',
                    style: AppTextStyles.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF15803D),
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.currentMonthName.toUpperCase()} OVERALL',
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$percent%',
                    style: AppTextStyles.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${stats['present']} present - ${stats['absent']} absent - ${stats['holiday']} holiday',
                    style: AppTextStyles.lexend(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _shortMonth(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }

  String _weekdayName(int wd) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[wd - 1];
  }
}

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;
  final VoidCallback onTap;
  const HeaderIconButton({
    super.key,
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
            Center(child: Icon(icon, size: 18, color: AppColors.textPrimary)),
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

class _SummaryRingPainter extends CustomPainter {
  final int percent;

  _SummaryRingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 6.0;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - stroke) / 2,
    );
    final track = Paint()
      ..color = const Color(0xFFDCFCE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    if (percent <= 0) return;
    final progress = Paint()
      ..color = const Color(0xFF15803D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final sweep = (percent.clamp(0, 100) / 100) * 2 * math.pi;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, progress);
  }

  @override
  bool shouldRepaint(covariant _SummaryRingPainter old) =>
      old.percent != percent;
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double dashWidth = 4;
    final double dashSpace = 4;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    Path path = Path()..addRRect(rrect);
    PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final length = math.min(dashWidth, pathMetric.length - distance);
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + length),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter old) => old.color != color;
}
