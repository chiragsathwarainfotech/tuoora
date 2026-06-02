import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/controllers/student_reports_controller.dart';

class StudentReportsScreen extends GetView<StudentReportsController> {
  const StudentReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(title: 'Reports', showDefaultActions: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildSegmentControl(),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryBrand,
                onRefresh: controller.fetchReport,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppSpacing.screenPaddingTop,
                  child: Column(
                    children: [
                      _buildAttendanceCard(),
                      const SizedBox(height: 16),
                      _buildAssignmentsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentControl() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Obx(
        () => Row(
          children: [
            _buildSegmentButton('This week', ReportPeriod.thisWeek),
            _buildSegmentButton('4 weeks', ReportPeriod.fourWeeks),
            _buildSegmentButton('12 weeks', ReportPeriod.twelveWeeks),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String text, ReportPeriod period) {
    final isSelected = controller.selectedPeriod.value == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changePeriod(period),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s10,
            horizontal: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBrand : AppColors.fieldBg,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return GestureDetector(
      onTap: () => Get.offAllNamed(AppRoutes.studentAttendance),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) return _buildCardShimmer();

          final data = controller.reportData.value;
          if (data == null) return const SizedBox();

          final attendance = data.attendance;
          final summary = attendance.summary;
          final weeks = attendance.weeks;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: AppColors.greenText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Attendance',
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${attendance.pct}%',
                    style: AppTextStyles.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.greenText,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${summary.present} of ${summary.total} days',
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      bottom: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomPaint(
                          painter: LineChartPainter(
                            weeks.map((e) => e.pct / 100.0).toList(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: weeks
                            .map(
                              (e) => Text(
                                e.label,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.outfit(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAssignmentsCard() {
    return GestureDetector(
      onTap: () => Get.offAllNamed(AppRoutes.studentHomework),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) return _buildCardShimmer();

          final data = controller.reportData.value;
          if (data == null) return const SizedBox();

          final assignments = data.assignments;
          final summary = assignments.summary;
          final weeks = assignments.weeks;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.book_outlined,
                      size: 18,
                      color: AppColors.brandAppBarColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Assignments',
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${assignments.pct}%',
                    style: AppTextStyles.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${summary.completed} completed - ${summary.pending} pending',
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weeks.map((e) {
                    final double maxBarHeight = 80;
                    final double total = (e.completed + e.pending).toDouble();
                    final double scale = total > 0 ? 1.0 / total : 1.0;
                    final double compH = e.completed * scale * maxBarHeight;
                    final double pendH = e.pending * scale * maxBarHeight;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              controller.selectedPeriod.value ==
                                  ReportPeriod.thisWeek
                              ? 6.0
                              : controller.selectedPeriod.value ==
                                    ReportPeriod.fourWeeks
                              ? 4.0
                              : 2.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (pendH > 0)
                              Container(
                                color: AppColors.instBrandOrange,
                                height: pendH,
                                width: double.infinity,
                              ),
                            if (compH > 0)
                              Container(
                                color: AppColors.greenText,
                                height: compH,
                                width: double.infinity,
                              ),
                            const SizedBox(height: 6),
                            Text(
                              e.label,
                              style: AppTextStyles.outfit(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(AppColors.greenText, 'Completed'),
                  const SizedBox(width: 16),
                  _buildLegendItem(AppColors.instBrandOrange, 'Pending'),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 100, height: 16, color: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(width: 60, height: 28, color: Colors.white),
              const SizedBox(width: 8),
              Container(width: 120, height: 11, color: Colors.white),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 100, width: double.infinity, color: Colors.white),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.greenText
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.successBg.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final pointPaint = Paint()
      ..color = AppColors.greenText
      ..style = PaintingStyle.fill;

    final pointInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final double stepX =
        size.width / (data.length - 1 == 0 ? 1 : data.length - 1);
    final double maxY = size.height;

    List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      // data is 0.0 to 1.0, 1.0 being top (y=0)
      final double y = maxY - (data[i] * maxY);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, maxY); // start from bottom left
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(
      points.isNotEmpty ? points.last.dx : 0,
      maxY,
    ); // down to bottom right
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 2.5, pointInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
