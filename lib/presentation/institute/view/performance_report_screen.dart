import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/report_widgets.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

class PerformanceReportScreen extends StatelessWidget {
  const PerformanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Performance Report', isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isPerformanceLoading.value) {
                  return const CommonLoading();
                }

                final report = controller.performanceReport.value;
                if (report == null) {
                  return const Center(
                    child: Text('No performance data available'),
                  );
                }

                return SingleChildScrollView(
                  padding: AppSpacing.all24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReportSummaryCard(
                        title: 'Overall Average Performance',
                        value: report.summary.averagePerformance,
                      ),
                      AppSpacing.v32,
                      _buildSectionHeader('Batch Summaries', controller),
                      AppSpacing.v16,
                      ...report.batches.map(
                        (batch) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.s12,
                          ),
                          child: ReportBatchItemCard(
                            name: batch.batchName,
                            strength: batch.studentsCount,
                            metricLabel: 'Average Score',
                            metricValue: batch.avgScore,
                            progress:
                                double.tryParse(
                                      batch.avgScore.replaceAll('%', ''),
                                    ) !=
                                    null
                                ? double.parse(
                                        batch.avgScore.replaceAll('%', ''),
                                      ) /
                                      100
                                : 0.0,
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.instituteBatchReportDetail,
                                arguments: {
                                  'batchId': batch.batchId,
                                  'batchName': batch.batchName,
                                  'reportType': 'Performance',
                                },
                              );
                            },
                          ),
                        ),
                      ),
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

  Widget _buildSectionHeader(String title, ReportsController controller) {
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
        GestureDetector(
          onTap: () => controller.exportReport('Performance'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBrand,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.file_download_outlined,
                  color: AppColors.white,
                  size: 16,
                ),
                AppSpacing.h8,
                Text(
                  'Export',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

