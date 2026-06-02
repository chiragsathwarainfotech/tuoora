import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/controllers/attendance_history_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/widgets/student_section_header.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceScreen extends GetView<AttendanceHistoryController> {
  final bool showBottomNav;
  const AttendanceScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            StudentAppBar(
              isRoot: true,
              titleWidget: Obx(
                () => Text(
                  '${controller.currentMonthName} ${controller.currentYear}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchAttendance,
                color: AppColors.primaryBrand,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppSpacing.screenPaddingTop,
                  child: Obx(() {
                    if (!controller.isLoading.value &&
                        controller.attendanceData.value == null) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: AppEmptyView(
                          icon: Icons.event_busy_outlined,
                          title: 'No attendance records',
                          message:
                              'Your attendance will appear here once your institute starts marking it.',
                        ),
                      );
                    }
                    return Column(
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
                        const SizedBox(height: AppSpacing.s8),
                      ],
                    );
                  }),
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

  Widget _buildTodayCard() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildTodayCardShimmer();
        }

        final data = controller.attendanceData.value?.today;
        if (data == null) return const SizedBox();

        final isNotMarked = data.status == 'Not Marked';

        return Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isNotMarked
                    ? AppColors.primaryBrand
                    : AppColors.successBg,
                borderRadius: BorderRadius.circular(AppSpacing.s8),
              ),
              child: Icon(
                isNotMarked ? Icons.close_rounded : Icons.check_rounded,
                color: isNotMarked ? AppColors.white : AppColors.successGreen,
                size: 24,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.status,
                    style: AppTextStyles.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isNotMarked
                          ? AppColors.textPrimary
                          : AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.text,
                    style: AppTextStyles.outfit(
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

  Widget _buildMonthCard() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        // Next arrow disables itself when the user is already on the
        // current month — there's no future-month attendance to view.
        Obx(
          () => _buildCircleNavButton(
            Icons.chevron_right,
            controller.nextMonth,
            enabled: controller.canGoNext,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleNavButton(
    IconData icon,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: AppSpacing.s36,
        height: AppSpacing.s36,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primaryBrand
              : AppColors.primaryBrand.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }

  Widget _buildGoToTodayButton() {
    return GestureDetector(
      onTap: controller.goToToday,
      child: CustomPaint(
        painter: _DashedRectPainter(color: AppColors.orangeTag),
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
                    color: AppColors.orangeTag,
                  ),
                  AppSpacing.h8,
                  Obx(() {
                    final data = controller.attendanceData.value;
                    final todayStr = data?.calendar.todayLabel ?? 'TODAY';
                    return Text(
                      todayStr,
                      style: AppTextStyles.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orangeTag,
                      ),
                    );
                  }),
                ],
              ),
              Row(
                children: [
                  Text(
                    'GO TO TODAY',
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orangeTag,
                    ),
                  ),
                  AppSpacing.h4,
                  Icon(
                    Icons.arrow_right_alt,
                    size: 16,
                    color: AppColors.orangeTag,
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
      if (controller.isLoading.value) {
        return _buildCalendarGridShimmer();
      }

      final calendarData = controller.attendanceData.value?.calendar;
      final Map<int, String> statusDays = calendarData?.days ?? {};

      final viewDate = controller.viewDate.value;

      int daysInMonth = DateTime(viewDate.year, viewDate.month + 1, 0).day;
      int firstWeekday = DateTime(viewDate.year, viewDate.month, 1).weekday;

      int startOffset = firstWeekday == 7 ? 0 : firstWeekday;

      List<Widget> rows = [];

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: AppTextStyles.outfit(
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

      int prevDaysInMonth = DateTime(viewDate.year, viewDate.month, 0).day;
      for (int i = 0; i < startOffset; i++) {
        int d = prevDaysInMonth - startOffset + i + 1;
        currentRow.add(Expanded(child: _buildDateBubble('$d', 'p_dashed')));
      }

      for (int day = 1; day <= daysInMonth; day++) {
        String type = statusDays[day] ?? 'no_class';

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
      case 'present':
      case 'p':
        bg = AppColors.successBg;
        fg = AppColors.successGreen;
        break;
      case 'absent':
      case 'a':
        bg = AppColors.errorBg;
        fg = AppColors.bohoRed;
        break;
      case 'holiday':
      case 'h':
        bg = AppColors.errorBg;
        fg = AppColors.bohoRed;
        break;
      case 'p_dashed':
        bg = Colors.transparent;
        fg = AppColors.textTertiary;
        isDashed = true;
        break;
      case 'no_class':
      default:
        bg = AppColors.scaffoldBg;
        fg = AppColors.textTertiary;
    }

    Widget content = Center(
      child: Text(
        day,
        style: AppTextStyles.outfit(
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
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
        _legendItem(AppColors.successGreen, 'Present'),
        AppSpacing.h12,
        _legendItem(AppColors.bohoRed, 'Absent'),
        AppSpacing.h12,
        _legendItem(AppColors.bohoRed, 'Holiday'),
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
          style: AppTextStyles.outfit(
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
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildSummaryCardShimmer();
        }

        final data = controller.attendanceData.value;
        if (data == null) return const SizedBox();

        final summary = data.summary;
        final percent = summary.pct;

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
                    style: AppTextStyles.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.successGreen,
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
                    summary.label,
                    style: AppTextStyles.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$percent%',
                    style: AppTextStyles.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${summary.present} present - ${summary.absent} absent',
                    style: AppTextStyles.outfit(
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
}

Widget _buildTodayCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s8),
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 100, height: 16, color: Colors.white),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 12,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSummaryCardShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 80, height: 12, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 60, height: 24, color: Colors.white),
              const SizedBox(height: 8),
              Container(width: 150, height: 12, color: Colors.white),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildCalendarGridShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
              (i) => Container(
                width: AppSpacing.s36,
                height: AppSpacing.s36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.s8),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
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
      ..color = AppColors.successBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    if (percent <= 0) return;
    final progress = Paint()
      ..color = AppColors.successGreen
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
