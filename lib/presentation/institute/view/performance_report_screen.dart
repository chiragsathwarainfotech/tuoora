import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/reports_controller.dart';
import 'package:tuoora/presentation/institute/widgets/export_report.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/report_widgets.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';

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
            const InstituteAppBar(
              title: 'Student Performance Report',
              isRoot: false,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isPerformanceLoading.value) {
                  return const CommonLoading();
                }

                final report = controller.performanceReport.value;
                if (report == null) {
                  return const AppEmptyView(
                    icon: Icons.insights_outlined,
                    title: 'No performance data available',
                  );
                }

                return SingleChildScrollView(
                  padding: AppSpacing.all16,
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
            style: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.h16,
        ExportReport(onTap: () => controller.exportReport('Performance')),
      ],
    );
  }
}
