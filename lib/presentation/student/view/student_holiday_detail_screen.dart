import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentHolidayDetailScreen extends StatelessWidget {
  const StudentHolidayDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(
              title: 'Holiday • Buddha Purnima',
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  children: [
                    _buildMainCard(),
                    const SizedBox(height: AppSpacing.s16),
                    _buildDetailsCard(),
                    const SizedBox(height: AppSpacing.s16),
                    _buildResumeCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        gradient: const LinearGradient(
          colors: [AppColors.warningBg, AppColors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          const Text(
            '🪔', // Emoji as placeholder for the diya icon
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Buddha Purnima',
            style: AppTextStyles.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Wednesday, 21 May 2026',
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          CustomPaint(
            painter: _DashedRectPainter(color: AppColors.borderGrey),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                'INSTITUTE CLOSED',
                style: AppTextStyles.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Text(
        'Marks the birth of Gautama Buddha. The institute will remain closed for the day. There are no assignment deadlines on this day; pending submissions roll over to Thursday.',
        style: AppTextStyles.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildResumeCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.studentPresentBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: AppColors.studentPresentText,
              size: 20,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CLASSES RESUME',
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Thursday, 22 May 2026 at 8:00 AM',
                  style: AppTextStyles.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
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
      const Radius.circular(20),
    );

    Path path = Path()..addRRect(rrect);
    PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final length = (dashWidth < (pathMetric.length - distance))
            ? dashWidth
            : (pathMetric.length - distance);
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
