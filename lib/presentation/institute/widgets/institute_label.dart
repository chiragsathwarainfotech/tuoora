import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class InstituteLabel extends StatelessWidget {
  final String label;

  const InstituteLabel(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: AppTextStyles.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF663322),
        ),
      ),
    );
  }
}
