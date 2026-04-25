import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Attendance Statement',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _buildMonthHeader('September 2024'),
          _buildHistoryCard(
            date: 'Sept 17, 2024',
            subtitle: AppStrings.attendanceSubtitlePresent,
            status: AppStrings.attendanceStatusPresent,
            isPresent: true,
          ),
          AppSpacing.v16,
          _buildHistoryCard(
            date: 'Sept 16, 2024',
            subtitle: AppStrings.attendanceSubtitlePresent,
            status: AppStrings.attendanceStatusPresent,
            isPresent: true,
          ),
          AppSpacing.v16,
          _buildHistoryCard(
            date: 'Sept 13, 2024',
            subtitle: AppStrings.attendanceSubtitleAbsent,
            status: AppStrings.attendanceStatusAbsent,
            isPresent: false,
          ),
          AppSpacing.v16,
          _buildHistoryCard(
            date: 'Sept 12, 2024',
            subtitle: AppStrings.attendanceSubtitlePresent,
            status: AppStrings.attendanceStatusPresent,
            isPresent: true,
          ),
          AppSpacing.v16,
          _buildHistoryCard(
            date: 'Sept 11, 2024',
            subtitle: AppStrings.attendanceSubtitlePresent,
            status: AppStrings.attendanceStatusPresent,
            isPresent: true,
          ),
          AppSpacing.v32,
          _buildMonthHeader('August 2024'),
          _buildHistoryCard(
            date: 'Aug 30, 2024',
            subtitle: 'Last Day of Summer Term',
            status: 'HOLIDAY',
            isPresent: true, // Styling for holiday is different, but for now we follow the pattern
            customStatusColor: const Color(0xFF92400E),
            customBgColor: const Color(0xFFFEFCE8),
            customIcon: Icons.event_note,
          ),
          AppSpacing.v16,
          _buildHistoryCard(
            date: 'Aug 29, 2024',
            subtitle: AppStrings.attendanceSubtitlePresent,
            status: AppStrings.attendanceStatusPresent,
            isPresent: true,
          ),
          AppSpacing.v24,
        ],
      ),
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Text(
        month.toUpperCase(),
        style: AppTextStyles.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String date,
    required String subtitle,
    required String status,
    required bool isPresent,
    Color? customStatusColor,
    Color? customBgColor,
    IconData? customIcon,
  }) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        border: !isPresent && customStatusColor == null
            ? const Border(
                left: BorderSide(
                  color: Color(0xFFB91C1C),
                  width: AppSpacing.s4,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s44,
            height: AppSpacing.s44,
            decoration: BoxDecoration(
              color: customBgColor ?? (isPresent ? const Color(0xFFEFF6FF) : const Color(0xFFFEF2F2)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              customIcon ?? (isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded),
              color: customStatusColor ?? (isPresent ? AppColors.deepBlue : const Color(0xFFB91C1C)),
              size: AppSpacing.s24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: customStatusColor ?? (isPresent ? AppColors.deepBlue : const Color(0xFFB91C1C)),
            ),
          ),
        ],
      ),
    );
  }
}
