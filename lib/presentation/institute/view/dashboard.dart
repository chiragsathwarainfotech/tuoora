import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:get/get.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:flutter/material.dart';

class InstituteDashboard extends StatelessWidget {
  const InstituteDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderTitles(),
          AppSpacing.v16,
          _buildTotalStudentsCard(),
          AppSpacing.v16,
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  AppStrings.instPendingFees,
                  '\$4,200',
                  Icons.assignment_late_outlined,
                  AppColors.orangeTag,
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: _buildMetricCard(
                  AppStrings.instAttendance,
                  '85%',
                  Icons.calendar_today_outlined,
                  AppColors.instAccentBlue,
                ),
              ),
            ],
          ),
          AppSpacing.v32,
          _buildSectionHeader(AppStrings.instActiveBatches, true),
          AppSpacing.v16,
          GetBuilder<BatchController>(
            init: BatchController(),
            builder: (batchController) {
              final batches = batchController.batchesList;
              if (batches.isEmpty) return const SizedBox.shrink();
              return Column(
                children: batches.take(2).map((batch) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                    child: _buildBatchItem(batch),
                  );
                }).toList(),
              );
            },
          ),
          AppSpacing.v32,
          _buildStudentListHeader(),
          AppSpacing.v16,
          _buildDashboardStudentItem(
            'Aarav Sharma',
            'Roll No: #M-001 • Joined 12 Jan',
            'https://i.pravatar.cc/150?u=aarav',
          ),
          _buildDashboardStudentItem(
            'Ishani Verma',
            'Roll No: #M-002 • Joined 14 Jan',
            'https://i.pravatar.cc/150?u=ishani',
          ),
          _buildDashboardStudentItem(
            'Rohan Das',
            'Roll No: #M-003 • Joined 15 Jan',
            'https://i.pravatar.cc/150?u=rohan',
          ),
          AppSpacing.v32,
        ],
      ),
    );
  }

  Widget _buildHeaderTitles() {
    return Text(
      AppStrings.instSummary,
      style: AppTextStyles.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTotalStudentsCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.instCardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.people_alt,
            color: Colors.white70,
            size: AppSpacing.s24,
          ),
          AppSpacing.v12,
          Text(
            AppStrings.instTotalStudents,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          AppSpacing.v4,
          Text(
            '1,240',
            style: AppTextStyles.manrope(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.s24),
          AppSpacing.v24,
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v6,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool showViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: () => Get.offAllNamed(AppRoutes.instituteBatches),
            child: Text(
              AppStrings.viewAllAlt,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2B5BCC),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBatchItem(BatchModel batch) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.instituteBatchDetails, arguments: batch),
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: batch.leftBorderColor, width: 4),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.s48,
              height: AppSpacing.s48,
              decoration: BoxDecoration(
                color: batch.statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  batch.subject == 'Mathematics'
                      ? Icons.functions
                      : Icons.science,
                  color: batch.statusTextColor,
                  size: AppSpacing.s24,
                ),
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    batch.title,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    '${batch.studentCount} • ${batch.time}',
                    style: AppTextStyles.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.instStudentListLabel,
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () => Get.find<InstituteController>().setIndex(1),
          child: Text(
            'View All',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B5BCC),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardStudentItem(
    String name,
    String subText,
    String avatarUrl,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.instituteStudentProfile),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: AppSpacing.y12,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.s48,
              height: AppSpacing.s48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v2,
                  Text(
                    subText,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
