import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';

class ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;

  const ReportSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: valueColor ?? AppColors.primaryBrand,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportBatchItemCard extends StatelessWidget {
  final String name;
  final int strength;
  final String metricLabel;
  final String metricValue;
  final double progress;
  final VoidCallback onTap;

  const ReportBatchItemCard({
    super.key,
    required this.name,
    required this.strength,
    required this.metricLabel,
    required this.metricValue,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.all20,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Batch Strength: $strength Students',
              style: AppTextStyles.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.v20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metricLabel,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  metricValue,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                  ),
                ),
              ],
            ),
            AppSpacing.v8,
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.reportBorder,
                color: AppColors.primaryBrand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportStudentItemCard extends StatelessWidget {
  final String name;
  final String metric;
  final String? subtitle;
  final Color metricColor;

  const ReportStudentItemCard({
    super.key,
    required this.name,
    required this.metric,
    this.subtitle,
    required this.metricColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.reportBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  AppSpacing.v4,
                  Text(
                    subtitle!,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: metricColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              metric,
              style: AppTextStyles.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: metricColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
