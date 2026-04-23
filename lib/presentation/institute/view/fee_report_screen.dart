import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

class FeeReportScreen extends StatelessWidget {
  const FeeReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Fee Report', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(
                      title: 'Total Collection Across Batches',
                      amount: '₹42,850.00',
                      trend: '12.5% increase from last month',
                      trendColor: const Color(0xFF10B981),
                      isPrimary: false,
                    ),
                    AppSpacing.v32,
                    _buildSectionHeader('Batch Summaries'),
                    AppSpacing.v16,
                    _buildBatchSummaryItem(
                      name: 'Advanced Physics (A1)',
                      strength: 42,
                      tag: 'MORNING',
                      collected: '₹8,400',
                      pending: '',
                      progress: 0.85,
                      showFooter: false,
                    ),
                    AppSpacing.v12,
                    _buildBatchSummaryItem(
                      name: 'Data Structures (DS2)',
                      strength: 30,
                      tag: 'EVENING',
                      collected: '₹12,000',
                      pending: '',
                      progress: 0.6,
                      showFooter: false,
                    ),
                    AppSpacing.v12,
                    _buildBatchSummaryItem(
                      name: 'Web Architecture (W4)',
                      strength: 18,
                      tag: 'WEEKEND',
                      collected: '₹9,500',
                      pending: '',
                      progress: 0.95,
                      showFooter: false,
                    ),
                    AppSpacing.v12,
                    _buildBatchSummaryItem(
                      name: 'Graphic Design (GD1)',
                      strength: 25,
                      tag: 'MORNING',
                      collected: '₹6,250',
                      pending: '',
                      progress: 0.5,
                      showFooter: false,
                    ),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    String? trend,
    Color? trendColor,
    Color? amountColor,
    required bool isPrimary,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
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
            amount,
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: amountColor ?? const Color(0xFF003D99),
            ),
          ),
          if (trend != null) ...[
            AppSpacing.v8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (trendColor ?? const Color(0xFF10B981)).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up_rounded, size: 14, color: trendColor),
                  AppSpacing.h4,
                  Text(
                    trend,
                    style: AppTextStyles.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: trendColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.h16,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF003D99),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 16,
              ),
              AppSpacing.h8,
              Text(
                'Export',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBatchSummaryItem({
    required String name,
    required int strength,
    required String tag,
    required String collected,
    required String pending,
    required double progress,
    String labelType = 'Total Collected',
    String pendingLabel = 'PENDING',
    bool showFooter = true,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.instituteBatchReportDetail,
          arguments: {
            'batchName': name,
            'reportType': 'Fee',
          },
        );
      },
      child: Container(
        padding: AppSpacing.all20,
        decoration: BoxDecoration(
          color: Colors.white,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF003D99),
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.v20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  labelType,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(
                  collected,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF003D99),
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
                backgroundColor: const Color(0xFFF1F5F9),
                color: const Color(0xFF003D99),
              ),
            ),
            if (showFooter) ...[
              AppSpacing.v16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pendingLabel,
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          pending,
                          style: AppTextStyles.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF991B1B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
