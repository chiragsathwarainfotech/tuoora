import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/models/batch_performance_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';

class BatchReportDetailScreen extends StatelessWidget {
  const BatchReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String batchName = Get.arguments['batchName'] ?? 'Batch Details';
    final String reportType = Get.arguments['reportType'] ?? 'Fee';
    final String? batchId = Get.arguments['batchId'];

    final reportsController = Get.find<ReportsController>();
    final batchPerf = (reportType == 'Performance' && batchId != null)
        ? reportsController.getBatchPerformance(batchId)
        : null;

    return Scaffold(
      backgroundColor: AppColors.reportScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(title: batchName, isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewCard(reportType, batchPerf: batchPerf),
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
                    _buildStudentList(reportType, batchPerf: batchPerf),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String reportType, {BatchPerformance? batchPerf}) {
    String label1 = '';
    String value1 = '';
    String label2 = '';
    String value2 = '';

    if (reportType == 'Fee') {
      label1 = 'Total Collected';
      value1 = '₹12,400';
      label2 = 'Collected %';
      value2 = '92%';
    } else if (reportType == 'Attendance') {
      label1 = 'Avg Attendance';
      value1 = '88%';
      label2 = 'Total Sessions';
      value2 = '24';
    } else {
      label1 = 'Overall Rating';
      value1 = batchPerf != null
          ? '${(batchPerf.averageRating).toStringAsFixed(1)} / 10'
          : 'A-';
      label2 = 'Performance';
      value2 = batchPerf != null
          ? '${(batchPerf.averageRating * 10).toStringAsFixed(1)}%'
          : '96%';
    }

    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.primaryBlueDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlueDark.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildStatItem(label1, value1)),
          Container(height: 40, width: 1, color: Colors.white24),
          Expanded(child: _buildStatItem(label2, value2)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        AppSpacing.v4,
        Text(
          value,
          style: AppTextStyles.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList(String reportType, {BatchPerformance? batchPerf}) {
    // Standardize data for all report types
    final List<Map<String, String>> students = [];

    if (reportType == 'Performance' && batchPerf != null) {
      for (var p in batchPerf.studentPerformances) {
        students.add({
          'name': p.studentName,
          'metric': p.averageRating.toStringAsFixed(1),
          'subtitle':
              'Performance: ${(p.averageRating * 10).toStringAsFixed(0)}%',
          'color_value': p.averageRating.toString(),
        });
      }
    } else {
      final List<Map<String, String>> mockStudents = [
        {
          'name': 'Rahul Sharma',
          'metric': reportType == 'Fee' ? 'Paid' : '95%',
          'subtitle': reportType == 'Fee' ? '' : 'Attendance Rate',
        },
        {
          'name': 'Sneha Patel',
          'metric': reportType == 'Fee' ? 'Paid' : '82%',
          'subtitle': reportType == 'Fee' ? '' : 'Attendance Rate',
        },
        {
          'name': 'Amit Kumar',
          'metric': reportType == 'Fee' ? 'Pending' : '70%',
          'subtitle': reportType == 'Fee'
              ? 'Pending: ₹1500'
              : 'Attendance Rate',
        },
        {
          'name': 'Priya Singh',
          'metric': reportType == 'Fee' ? 'Paid' : '98%',
          'subtitle': reportType == 'Fee' ? '' : 'Attendance Rate',
        },
        {
          'name': 'Vikram Mehra',
          'metric': reportType == 'Fee' ? 'Pending' : '60%',
          'subtitle': reportType == 'Fee'
              ? 'Pending: ₹2400'
              : 'Attendance Rate',
        },
        {
          'name': 'Ananya Roy',
          'metric': reportType == 'Fee' ? 'Paid' : '88%',
          'subtitle': reportType == 'Fee' ? '' : 'Attendance Rate',
        },
      ];

      if (reportType == 'Fee') {
        students.addAll(
          mockStudents.where(
            (s) => s['metric'] == 'Paid' || s['metric'] == 'Pending',
          ),
        );
      } else {
        students.addAll(mockStudents);
      }
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (_, _) => AppSpacing.v12,
      itemBuilder: (context, index) {
        final student = students[index];
        final String metric = student['metric']!;
        final String subtitle = student['subtitle'] ?? '';
        final bool hasSubtitle = subtitle.isNotEmpty;

        return Container(
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: Colors.white,
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
                      student['name']!,
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (hasSubtitle) ...[
                      AppSpacing.v4,
                      Text(
                        subtitle,
                        style: AppTextStyles.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getMetricColor(
                            metric,
                            reportType,
                            student['color_value'],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getMetricColor(
                    metric,
                    reportType,
                    student['color_value'],
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  metric,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _getMetricColor(
                      metric,
                      reportType,
                      student['color_value'],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getMetricColor(String metric, String type, String? colorValue) {
    if (type == 'Performance' && colorValue != null) {
      double rating = double.parse(colorValue);
      if (rating >= 8.5) return AppColors.successGreen;
      if (rating >= 7.0) return AppColors.warningAmber;
      return AppColors.errorRed;
    }
    if (type == 'Fee') {
      if (metric == 'Paid') return AppColors.successGreen;
      if (metric == 'Partial') return AppColors.warningAmber;
      return AppColors.errorRed;
    }
    if (type == 'Attendance') {
      double val = double.tryParse(metric.replaceAll('%', '')) ?? 0.0;
      if (val >= 90) return AppColors.successGreen;
      if (val >= 75) return AppColors.warningAmber;
      return AppColors.errorRed;
    }
    // Fallback for letters A, B, C etc.
    if (metric.startsWith('A')) return AppColors.successGreen;
    if (metric.startsWith('B')) return AppColors.warningAmber;
    if (metric.startsWith('C') || metric.startsWith('D'))
      return AppColors.errorRed;

    return AppColors.successGreen;
  }
}
