import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/widgets/export_report.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';

import 'package:tuoora/presentation/institute/controllers/reports_controller.dart';
import 'package:tuoora/presentation/institute/widgets/report_widgets.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Attendance Report', isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isAttendanceLoading.value) {
                  return const CommonLoading();
                }

                final report = controller.attendanceReport.value;
                if (report == null) {
                  return const AppEmptyView(
                    icon: Icons.fact_check_outlined,
                    title: 'No attendance data available',
                  );
                }

                final double attendancePercentage = report.summary.total > 0
                    ? (report.summary.present / report.summary.total) * 100
                    : 0.0;

                return SingleChildScrollView(
                  padding: AppSpacing.all16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReportSummaryCard(
                        title: 'Overall Attendance Percentage',
                        value: '${attendancePercentage.toStringAsFixed(1)}%',
                      ),
                      AppSpacing.v32,
                      _buildSectionHeader('Attendance Summary', controller),
                      AppSpacing.v16,
                      ...report.batches.map(
                        (batch) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.s12,
                          ),
                          child: ReportBatchItemCard(
                            name: batch.batchName,
                            strength: batch.studentsCount,
                            metricLabel: 'Attendance Rate',
                            metricValue:
                                '${batch.avgAttendance.toStringAsFixed(1)}%',
                            progress: batch.avgAttendance / 100,
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.instituteBatchReportDetail,
                                arguments: {
                                  'batchId': batch.batchId,
                                  'batchName': batch.batchName,
                                  'reportType': 'Attendance',
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
        ExportReport(onTap: () => controller.exportReport('Attendance')),
      ],
    );
  }
}
