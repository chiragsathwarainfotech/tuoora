import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchReportDetailScreen extends StatelessWidget {
  const BatchReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String batchName = Get.arguments['batchName'] ?? 'Batch Details';
    final String reportType = Get.arguments['reportType'] ?? 'Fee';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
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
                    _buildOverviewCard(reportType),
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
                    _buildStudentList(reportType),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String reportType) {
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
      label1 = 'Avg Grade';
      value1 = 'A-';
      label2 = 'Pass Rate';
      value2 = '96%';
    }

    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: const Color(0xFF003D99),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003D99).withValues(alpha: 0.2),
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

  Widget _buildStudentList(String reportType) {
    final List<Map<String, String>> allStudents = [
      {
        'name': 'Rahul Sharma',
        'metric': reportType == 'Fee'
            ? 'Paid'
            : reportType == 'Attendance'
            ? '95%'
            : 'A',
        'pending': '0',
      },
      {
        'name': 'Sneha Patel',
        'metric': reportType == 'Fee'
            ? 'Paid'
            : reportType == 'Attendance'
            ? '82%'
            : 'B+',
        'pending': '0',
      },
      {
        'name': 'Amit Kumar',
        'metric': reportType == 'Fee'
            ? 'Pending'
            : reportType == 'Attendance'
            ? '70%'
            : 'B-',
        'pending': '1500',
      },
      {
        'name': 'Priya Singh',
        'metric': reportType == 'Fee'
            ? 'Paid'
            : reportType == 'Attendance'
            ? '98%'
            : 'A+',
        'pending': '0',
      },
      {
        'name': 'Vikram Mehra',
        'metric': reportType == 'Fee'
            ? 'Pending'
            : reportType == 'Attendance'
            ? '60%'
            : 'C',
        'pending': '2400',
      },
      {
        'name': 'Ananya Roy',
        'metric': reportType == 'Fee'
            ? 'Paid'
            : reportType == 'Attendance'
            ? '88%'
            : 'A-',
        'pending': '0',
      },
    ];

    final students = reportType == 'Fee'
        ? allStudents
              .where((s) => s['metric'] == 'Paid' || s['metric'] == 'Pending')
              .toList()
        : allStudents;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      separatorBuilder: (_, _) => AppSpacing.v12,
      itemBuilder: (context, index) {
        final student = students[index];
        final bool isFeePending =
            reportType == 'Fee' && student['metric'] == 'Pending';

        return Container(
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
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
                    if (isFeePending) ...[
                      AppSpacing.v4,
                      Text(
                        'Pending: ₹${student['pending']}',
                        style: AppTextStyles.lexend(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
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
                    student['metric']!,
                    reportType,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  student['metric']!,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _getMetricColor(student['metric']!, reportType),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getMetricColor(String metric, String type) {
    if (type == 'Fee') {
      if (metric == 'Paid') return const Color(0xFF10B981);
      if (metric == 'Partial') return const Color(0xFFF59E0B);
      return const Color(0xFFEF4444);
    }
    if (type == 'Attendance') {
      double val = double.parse(metric.replaceAll('%', ''));
      if (val >= 90) return const Color(0xFF10B981);
      if (val >= 75) return const Color(0xFFF59E0B);
      return const Color(0xFFEF4444);
    }
    if (metric.startsWith('A')) return const Color(0xFF10B981);
    if (metric.startsWith('B')) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}
