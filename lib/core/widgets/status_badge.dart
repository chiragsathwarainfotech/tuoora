import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;

  const StatusBadge._({required this.label, required this.backgroundColor});

  factory StatusBadge.success(String label) =>
      StatusBadge._(label: label, backgroundColor: AppColors.successGreen);

  factory StatusBadge.danger(String label) =>
      StatusBadge._(label: label, backgroundColor: AppColors.bohoRed);
  factory StatusBadge.fromLabel(String label) {
    final first = label.trim().toUpperCase().split(RegExp(r'\s+')).first;
    const successTokens = {'ACTIVE', 'SUBMITTED', 'OPEN', 'PAID'};
    const dangerTokens = {'PENDING', 'CLOSED', 'OVERDUE', 'DUE', 'INACTIVE'};
    if (successTokens.contains(first)) return StatusBadge.success(label);
    if (dangerTokens.contains(first)) return StatusBadge.danger(label);
    return StatusBadge.danger(label);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.white,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
