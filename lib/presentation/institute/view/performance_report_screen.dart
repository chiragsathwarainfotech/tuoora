import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

class PerformanceReportScreen extends StatelessWidget {
  const PerformanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return Scaffold(
      backgroundColor: AppColors.reportScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Performance Report', isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isPerformanceLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: AppSpacing.all24,
                  child: Column(
                    children: [
                      _buildPerformanceGraph(),
                      AppSpacing.v32,
                      _buildSectionHeader('Batch Performance Summary'),
                      AppSpacing.v16,
                      ...controller.batchPerformances.map((batchPerf) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.s12,
                          ),
                          child: _buildBatchSummaryItem(
                            batchId: batchPerf.batchId,
                            name: batchPerf.batchName,
                            strength: batchPerf.totalStudents,
                            collected:
                                '${(batchPerf.averageRating * 10).toStringAsFixed(1)}%',
                            pending:
                                '${batchPerf.studentPerformances.where((s) => s.averageRating < 7.5).length} Concerns',
                            progress: batchPerf.averageRating / 10,
                            labelType: 'Average Grade',
                            pendingLabel: 'ACADEMIC CONCERNS',
                            showFooter: false,
                          ),
                        );
                      }),
                      AppSpacing.v32,
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceGraph() {
    final List<double> data = [0.78, 0.85, 0.82, 0.88, 0.84, 0.90, 0.86];
    final List<String> weeks = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'];

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Trends',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: AppColors.successGreen,
                    ),
                    AppSpacing.h4,
                    Text(
                      '5.2%',
                      style: AppTextStyles.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: 100 * data[index],
                      decoration: BoxDecoration(
                        color: index == 5
                            ? AppColors.primaryBlueDark
                            : AppColors.lightBlueBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    AppSpacing.v8,
                    Text(
                      weeks[index],
                      style: AppTextStyles.lexend(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
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
    required String batchId,
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
          arguments: {
            'batchId': batchId,
            'batchName': name,
            'reportType': 'Performance',
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
