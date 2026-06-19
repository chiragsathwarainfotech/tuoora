import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

/// Semicircle gauge inspired by Google Play's credit-score visual.
/// Renders a 180° arc with 4 colored zones (Poor / Fair / Good /
/// Excellent), a needle pointing to the current [score], and a
/// centered numeric label + status text.
///
/// [score] is clamped to 0-100. Color band thresholds:
/// - 0-24  → Poor      (red)
/// - 25-49 → Fair      (orange)
/// - 50-74 → Good      (amber)
/// - 75-100→ Excellent (green)
class PerformanceGauge extends StatelessWidget {
  final int score;
  final double size;

  const PerformanceGauge({super.key, required this.score, this.size = 180});

  static const Color _bandPoor = AppColors.bohoRed;
  static const Color _bandFair = AppColors.primaryBrand;
  static const Color _bandGood = AppColors.subjectPhysics;
  static const Color _bandExcellent = AppColors.green;

  static String statusLabel(int score) {
    if (score < 25) return 'Poor';
    if (score < 50) return 'Fair';
    if (score < 75) return 'Good';
    return 'Excellent';
  }

  static Color statusColor(int score) {
    if (score < 25) return _bandPoor;
    if (score < 50) return _bandFair;
    if (score < 75) return _bandGood;
    return _bandExcellent;
  }

  @override
  Widget build(BuildContext context) {
    final clamped = score.clamp(0, 100);
    final activeColor = statusColor(clamped);
    final label = statusLabel(clamped);

    return SizedBox(
      width: size,
      child: CustomPaint(
        painter: _GaugePainter(scorePercent: clamped / 100),
        child: Padding(
          padding: EdgeInsets.only(top: size * 0.20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$clamped',
                style: AppTextStyles.outfit(
                  fontSize: size * 0.20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.outfit(
                  fontSize: size * 0.10,
                  fontWeight: FontWeight.w600,
                  color: activeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  /// 0.0 — 1.0 fraction of the arc that should be filled / where the
  /// needle should land.
  final double scorePercent;

  _GaugePainter({required this.scorePercent});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final arcThickness = width * 0.07;

    // Centre the arc bottom on the canvas — gives equal room either side.
    final center = Offset(width / 2, width / 2);
    final radius = (width / 2) - arcThickness;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 4 zones, each spans 45° (quarter of the 180° arc).
    const startAngle = math.pi; // 180° (left side)
    const totalSweep = math.pi; // 180° (to right side)
    const zoneSweep = totalSweep / 4; // 45° per band
    const gap = 0.04; // small visual gap between bands

    final bands = <Color>[
      PerformanceGauge._bandPoor,
      PerformanceGauge._bandFair,
      PerformanceGauge._bandGood,
      PerformanceGauge._bandExcellent,
    ];

    for (var i = 0; i < bands.length; i++) {
      final paint = Paint()
        ..color = bands[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = arcThickness
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect,
        startAngle + (zoneSweep * i) + gap,
        zoneSweep - (gap * 2),
        false,
        paint,
      );
    }

    // Indicator dot sitting *on* the arc curve at the score position —
    // mirrors Google Play's credit-score view. Outer ring uses the
    // active band color, inner fill is white, with a soft shadow halo
    // behind so it lifts off the arc visually.
    final markerAngle = startAngle + (totalSweep * scorePercent);
    final markerCenter = Offset(
      center.dx + math.cos(markerAngle) * radius,
      center.dy + math.sin(markerAngle) * radius,
    );
    final activeColor = _bandColorForPercent(scorePercent);

    // Soft shadow halo for depth.
    canvas.drawCircle(
      markerCenter.translate(0, 1.5),
      arcThickness * 0.85,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // White outer ring so the marker reads cleanly against any band color.
    canvas.drawCircle(
      markerCenter,
      arcThickness * 0.85,
      Paint()..color = Colors.white,
    );

    // Coloured inner fill matching the band the score landed in.
    canvas.drawCircle(
      markerCenter,
      arcThickness * 0.55,
      Paint()..color = activeColor,
    );
  }

  Color _bandColorForPercent(double p) {
    if (p < 0.25) return PerformanceGauge._bandPoor;
    if (p < 0.50) return PerformanceGauge._bandFair;
    if (p < 0.75) return PerformanceGauge._bandGood;
    return PerformanceGauge._bandExcellent;
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.scorePercent != scorePercent;
}
