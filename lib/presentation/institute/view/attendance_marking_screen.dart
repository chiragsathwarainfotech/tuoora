import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_drawer.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceMarkingScreen extends StatelessWidget {
  const AttendanceMarkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: const InstituteDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Attendance'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDateSelector(),
                    AppSpacing.v32,
                    _buildSelectionLabel(),
                    AppSpacing.v24,
                    _buildBatchCard(
                      AppStrings.instBatchPhysics,
                      '09:00 AM - 10:30 AM',
                      isSelected: true,
                    ),
                    AppSpacing.v16,
                    _buildBatchCard(
                      AppStrings.instBatchChemistry,
                      '11:00 AM - 12:30 PM',
                    ),
                    AppSpacing.v16,
                    _buildBatchCard(
                      AppStrings.instBatchMathematics,
                      '02:00 PM - 03:30 PM',
                    ),
                    AppSpacing.v16,
                    _buildBatchCard(
                      AppStrings.instBatchHistory,
                      '04:00 PM - 05:30 PM',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.instAccentBlue,
            size: AppSpacing.s20,
          ),
          AppSpacing.h12,
          Text(
            AppStrings.instSampleDateLabel,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instSelectActiveBatchHeading,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.instAccentBlue,
            letterSpacing: 0.5,
          ),
        ),
        AppSpacing.v8,
        Text(
          AppStrings.instSelectClassDesc,
          style: AppTextStyles.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildBatchCard(String title, String time, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.instituteMarkAttendance),
      child: Container(
        padding: AppSpacing.all20,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.instSelectedBatchBg : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.s20),
          border: Border.all(
            color: isSelected
                ? AppColors.instSelectedBatchBorder
                : const Color(0xFFE5E7EB),
            width: isSelected ? AppSpacing.s2 : AppSpacing.s2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: AppSpacing.s10,
                offset: const Offset(0, AppSpacing.s4),
              ),
          ],
        ),
        child: Row(
          children: [
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
                  AppSpacing.v8,
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_filled,
                        size: AppSpacing.s16,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.h8,
                      Text(
                        time,
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: AppSpacing.all4,
                decoration: const BoxDecoration(
                  color: AppColors.instSelectedBatchBorder,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: AppSpacing.s16,
                ),
              ),
            AppSpacing.h16,
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: AppSpacing.s28,
            ),
          ],
        ),
      ),
    );
  }
}
