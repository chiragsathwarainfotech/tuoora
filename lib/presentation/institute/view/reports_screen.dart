import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.reportScaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Reports Dashboard', isRoot: false),
            Expanded(
              child: ListView(
                padding: AppSpacing.all24,
                children: [
                  _buildReportCard(
                    title: 'Fee Reports',
                    subtitle: 'Collection summaries, pending dues, and batch-wise financial insights.',
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.primaryBlueDark,
                    onTap: () => Get.toNamed(AppRoutes.instituteFeeReport),
                  ),
                  AppSpacing.v16,
                  _buildReportCard(
                    title: 'Attendance Reports',
                    subtitle: 'Daily attendance rates, absentee tracking, and batch consistency trends.',
                    icon: Icons.calendar_today_rounded,
                    color: AppColors.successGreen,
                    onTap: () => Get.toNamed(AppRoutes.instituteAttendanceReport),
                  ),
                  AppSpacing.v16,
                  _buildReportCard(
                    title: 'Performance Reports',
                    subtitle: 'Academic progress, average grades, and performance analysis across batches.',
                    icon: Icons.insights_rounded,
                    color: AppColors.warningAmber,
                    onTap: () => Get.toNamed(AppRoutes.institutePerformanceReport),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            AppSpacing.h20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    subtitle,
                    style: AppTextStyles.lexend(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.h12,
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
