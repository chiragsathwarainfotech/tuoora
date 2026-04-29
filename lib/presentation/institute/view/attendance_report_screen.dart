import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/report_widgets.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return Scaffold(
      backgroundColor: AppColors.reportScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Attendance Report', isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isAttendanceLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final report = controller.attendanceReport.value;
                if (report == null) {
                  return const Center(
                    child: Text('No attendance data available'),
                  );
                }

                final double attendancePercentage = report.summary.total > 0
                    ? (report.summary.present / report.summary.total) * 100
                    : 0.0;

                return SingleChildScrollView(
                  padding: AppSpacing.all24,
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
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.h16,
        GestureDetector(
          onTap: () => controller.exportReport('Attendance'),
          child: Container(
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
        ),
      ],
    );
  }
}
