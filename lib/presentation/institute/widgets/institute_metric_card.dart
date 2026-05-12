import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class InstituteMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isCentered;

  const InstituteMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isCentered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v4,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.primaryBrand,
            ),
          ),
        ],
      ),
    );
  }
}
