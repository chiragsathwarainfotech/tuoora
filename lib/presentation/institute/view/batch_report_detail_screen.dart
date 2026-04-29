import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/report_widgets.dart';

class BatchReportDetailScreen extends StatelessWidget {
  const BatchReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String batchName = Get.arguments['batchName'] ?? 'Batch Details';
    final String reportType = Get.arguments['reportType'] ?? 'Fee';
    final int? batchId = Get.arguments['batchId'] is int
        ? Get.arguments['batchId']
        : int.tryParse(Get.arguments['batchId']?.toString() ?? '');

    final reportsController = Get.find<ReportsController>();

    if (batchId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (reportsController.selectedBatchId.value != batchId ||
            reportsController.selectedReportType.value != reportType) {
          reportsController.loadBatchDetail(batchId, reportType);
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.reportScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(title: batchName, isRoot: false),
            Expanded(
              child: Obx(() {
                if (reportsController.isBatchDetailLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  padding: AppSpacing.all24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewCard(reportType, reportsController),
                      AppSpacing.v32,
                      Text(
                        'Student Breakdown',
                        style: AppTextStyles.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.v16,
                      _buildStudentList(reportType, reportsController),
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

  Widget _buildOverviewCard(String reportType, ReportsController controller) {
    String title = '';
    String value = '';

    if (reportType == 'Fee') {
      final summary = controller.batchFeeDetail.value?.summary;
      title = 'Batch Collected Total';
      value = '₹${summary?.totalAmount.toStringAsFixed(0) ?? '0'}';
    } else if (reportType == 'Attendance') {
      final summary = controller.batchAttendanceDetail.value?.summary;
      final total = summary?.total ?? 1;
      final present = summary?.present ?? 0;
      title = 'Batch Attendance Percentage';
      value = '${((present / total) * 100).toStringAsFixed(1)}%';
    } else if (reportType == 'Performance') {
      final summary = controller.batchPerformanceDetail.value?.summary;
      title = 'Average Performance Percentage';
      value = summary?.averagePerformance ?? '0%';
    }

    return ReportSummaryCard(title: title, value: value);
  }

  Widget _buildStudentList(String reportType, ReportsController controller) {
    final List<Widget> items = [];

    if (reportType == 'Fee') {
      final fees = controller.batchFeeDetail.value?.fees ?? [];
      for (var f in fees) {
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: ReportStudentItemCard(
              name: f.student?.name ?? '',
              metric: 'Paid',
              metricColor: AppColors.successGreen,
              subtitle: 'Collected: ₹${f.totalAmount.toStringAsFixed(0)}',
            ),
          ),
        );
      }
    } else if (reportType == 'Attendance') {
      final detail = controller.batchAttendanceDetail.value;
      final attendance = detail?.attendance ?? [];
      final total = detail?.summary.total ?? 1;

      for (var a in attendance) {
        final percentage = (a.presentDays / total) * 100;
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: ReportStudentItemCard(
              name: a.studentName,
              metric: '${percentage.toStringAsFixed(1)}%',
              metricColor: _getMetricColor(percentage),
              subtitle: 'Attendance Rate',
            ),
          ),
        );
      }
    } else if (reportType == 'Performance') {
      final detail = controller.batchPerformanceDetail.value;
      final students = detail?.students ?? [];

      for (var s in students) {
        final score = double.tryParse(s.avgScore.replaceAll('%', '')) ?? 0.0;
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: ReportStudentItemCard(
              name: s.studentName,
              metric: s.avgScore,
              metricColor: _getMetricColor(score),
              subtitle: 'Average Score',
            ),
          ),
        );
      }
    }

    return Column(children: items);
  }

  Color _getMetricColor(double value) {
    if (value >= 70) return AppColors.successGreen;
    if (value >= 30) return AppColors.warningAmber;
    return AppColors.errorRed;
  }
}
