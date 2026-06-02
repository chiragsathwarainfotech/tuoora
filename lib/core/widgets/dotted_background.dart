import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
class DottedBackground extends StatelessWidget {
  final Widget child;

  const DottedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: const _DottedBackgroundPainter(),
        child: child,
      ),
    );
  }
}

class _DottedBackgroundPainter extends CustomPainter {
  const _DottedBackgroundPainter();

  static const Color _baseColor = AppColors.surfaceBg;
  static const Color _dotColor = Color(0xFFB0B6C4);
  static const double _dotOpacity = 0.55;
  static const double _spacing = 28.0;
  static const double _radius = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..color = _baseColor;
    canvas.drawRect(Offset.zero & size, basePaint);

    final dotPaint = Paint()
      ..color = _dotColor.withValues(alpha: _dotOpacity)
      ..style = PaintingStyle.fill;

    final start = _spacing / 2;
    for (double y = start; y < size.height; y += _spacing) {
      for (double x = start; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBackgroundPainter oldDelegate) => false;
}
