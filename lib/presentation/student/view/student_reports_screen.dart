import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

enum ReportPeriod { thisWeek, fourWeeks, twelveWeeks }

class ReportData {
  final String label;
  final double attendance;
  final double completed;
  final double pending;

  ReportData(this.label, this.attendance, this.completed, this.pending);
}

class StudentReportsScreen extends StatelessWidget {
  final Rx<ReportPeriod> selectedPeriod = ReportPeriod.thisWeek.obs;

  StudentReportsScreen({super.key});

  final Map<ReportPeriod, List<ReportData>> mockData = {
    ReportPeriod.thisWeek: [
      ReportData('Mon', 1.0, 1.0, 0.0),
      ReportData('Tue', 1.0, 1.0, 0.0),
      ReportData('Wed', 0.0, 0.0, 0.0),
      ReportData('Thu', 1.0, 1.0, 0.0),
      ReportData('Fri', 1.0, 0.5, 0.5), // Sum = 1.0
      ReportData('Sat', 1.0, 0.0, 0.0),
    ],
    ReportPeriod.fourWeeks: [
      ReportData('W1', 0.4, 0.6, 0.1),
      ReportData('W2', 0.8, 0.7, 0.0),
      ReportData('W3', 0.5, 0.9, 0.1),
      ReportData('W4', 0.6, 0.8, 0.2),
    ],
    ReportPeriod.twelveWeeks: [
      ReportData('W1', 0.3, 0.5, 0.2),
      ReportData('W2', 0.5, 0.6, 0.1),
      ReportData('W3', 0.6, 0.7, 0.2),
      ReportData('W4', 0.4, 0.6, 0.3),
      ReportData('W5', 0.7, 0.7, 0.0),
      ReportData('W6', 0.5, 0.7, 0.1),
      ReportData('W7', 0.6, 0.7, 0.0),
      ReportData('W8', 0.4, 0.6, 0.2),
      ReportData('W9', 0.7, 0.9, 0.0),
      ReportData('W10', 0.6, 0.8, 0.1),
      ReportData('W11', 0.5, 0.7, 0.2),
      ReportData('W12', 0.6, 0.7, 0.3),
    ],
  };

  final Map<ReportPeriod, Map<String, String>> mockStats = {
    ReportPeriod.thisWeek: {
      'att_pct': '100%',
      'att_sub': '5 of 5 days',
      'ass_pct': '80%',
      'ass_sub': '4 completed · 1 pending',
    },
    ReportPeriod.fourWeeks: {
      'att_pct': '94%',
      'att_sub': '17 of 18 days',
      'ass_pct': '88%',
      'ass_sub': '28 completed · 4 pending',
    },
    ReportPeriod.twelveWeeks: {
      'att_pct': '92%',
      'att_sub': '52 of 56 days',
      'ass_pct': '85%',
      'ass_sub': '75 completed · 13 pending',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(title: 'Reports', showDefaultActions: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSegmentControl(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Obx(() => _buildAttendanceCard(selectedPeriod.value)),
                    const SizedBox(height: 16),
                    Obx(() => _buildAssignmentsCard(selectedPeriod.value)),
                  ],
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
        color: AppColors.borderGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
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
    final isSelected = selectedPeriod.value == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedPeriod.value = period,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
                )
              : null,
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(ReportPeriod period) {
    final data = mockData[period]!;
    final stats = mockStats[period]!;

    return GestureDetector(
      onTap: () => Get.offAllNamed(AppRoutes.studentAttendance),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: Color(0xFF14532D),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Attendance',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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
                  stats['att_pct']!,
                  style: AppTextStyles.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF14532D),
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  stats['att_sub']!,
                  style: AppTextStyles.lexend(
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
                          data.map((e) => e.attendance).toList(),
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
                      children: data
                          .map(
                            (e) => Text(
                              e.label,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.lexend(
                                fontSize: 9, // Reduced slightly to fit 12 weeks
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
        ),
      ),
    );
  }

  Widget _buildAssignmentsCard(ReportPeriod period) {
    final data = mockData[period]!;
    final stats = mockStats[period]!;

    return GestureDetector(
      onTap: () => Get.offAllNamed(AppRoutes.studentHomework),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.book_outlined,
                    size: 18,
                    color: Color(0xFF713F12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Assignments',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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
                  stats['ass_pct']!,
                  style: AppTextStyles.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  stats['ass_sub']!,
                  style: AppTextStyles.lexend(
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
                children: data.map((e) {
                  final double maxBarHeight = 80;
                  // Avoid overflow if data somehow exceeds 1.0 total
                  final double total = e.completed + e.pending;
                  final double scale = total > 1.0 ? 1.0 / total : 1.0;
                  final double compH = e.completed * scale * maxBarHeight;
                  final double pendH = e.pending * scale * maxBarHeight;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: period == ReportPeriod.thisWeek
                            ? 6.0
                            : period == ReportPeriod.fourWeeks
                            ? 4.0
                            : 2.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (pendH > 0)
                            Container(
                              color: const Color(0xFFF97316),
                              height: pendH,
                              width: double.infinity,
                            ),
                          if (compH > 0)
                            Container(
                              color: const Color(0xFF166534),
                              height: compH,
                              width: double.infinity,
                            ),
                          const SizedBox(height: 6),
                          Text(
                            e.label,
                            style: AppTextStyles.lexend(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildLegendItem(const Color(0xFF166534), 'Completed'),
                const SizedBox(width: 16),
                _buildLegendItem(const Color(0xFFF97316), 'Pending'),
              ],
            ),
          ],
        ),
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
          style: AppTextStyles.lexend(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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
      ..color = const Color(0xFF166534)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFFDCFCE7).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final pointPaint = Paint()
      ..color = const Color(0xFF166534)
      ..style = PaintingStyle.fill;

    final pointInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final double stepX = size.width / (data.length - 1);
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

    fillPath.lineTo(points.last.dx, maxY); // down to bottom right
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
