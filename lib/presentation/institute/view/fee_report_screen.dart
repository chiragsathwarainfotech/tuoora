import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';

class FeeReportScreen extends StatelessWidget {
  const FeeReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return Scaffold(
      backgroundColor: AppColors.reportScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Fee Report', isRoot: false),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(
                      title: 'Total Collection Across Batches',
                      amount: controller.totalFeeCollection.value,
                      trend: controller.feeTrend.value,
                      trendColor: AppColors.successGreen,
                      isPrimary: false,
                    ),
                    AppSpacing.v32,
                    _buildSectionHeader('Batch Summaries'),
                    AppSpacing.v16,
                    ...controller.feeBatches.map((batch) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                      child: _buildBatchSummaryItem(
                        name: batch['name'],
                        strength: batch['strength'],
                        collected: batch['collected'],
                        pending: '',
                        progress: batch['progress'],
                        showFooter: false,
                      ),
                    )),
                    AppSpacing.v32,
                  ],
                ),
              )),
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
              color: amountColor ?? AppColors.primaryBlueDark,
            ),
          ),
          if (trend != null) ...[
            AppSpacing.v8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (trendColor ?? AppColors.successGreen).withValues(
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
            color: AppColors.primaryBlueDark,
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
          arguments: {'batchName': name, 'reportType': 'Fee'},
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
                    color: AppColors.primaryBlueDark,
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
                backgroundColor: AppColors.reportProgressBg,
                color: AppColors.primaryBlueDark,
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
                            color: AppColors.darkRedText,
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
