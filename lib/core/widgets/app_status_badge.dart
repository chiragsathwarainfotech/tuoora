import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';

class AppStatusBadge extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const AppStatusBadge({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: AppTextStyles.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
