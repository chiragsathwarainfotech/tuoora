import 'dart:math';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffAttendanceScreen extends GetView<StaffController> {
  const StaffAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staffName = controller.selectedStaff.value?.name ?? 'Staff Member';
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Attendance',
              subtitle: staffName,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  children: [
                    _buildSummaryCard(),
                    AppSpacing.v24,
                    _buildCalendarCard(),
                    AppSpacing.v24,
                    _buildRemarksCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildSummaryItem(Icons.check_circle, '22', 'PRESENT', AppColors.successGreen)),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(child: _buildSummaryItem(Icons.cancel, '02', 'ABSENT', AppColors.errorRed)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String count, String label, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color.withValues(alpha: 0.6), size: 24),
            AppSpacing.h12,
            Text(
              count,
              style: AppTextStyles.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Obx(() {
            final date = controller.selectedAttendanceMonth.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => controller.previousMonth(),
                  child: const Icon(Icons.chevron_left, color: AppColors.textTertiary),
                ),
                Text(
                  '${months[date.month - 1]} ${date.year}',
                  style: AppTextStyles.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.nextMonth(),
                  child: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                ),
              ],
            );
          }),
          AppSpacing.v24,
          const Divider(height: 1, color: AppColors.divider),
          AppSpacing.v24,
          Obx(() => _buildCalendarGrid(controller.selectedAttendanceMonth.value)),
          AppSpacing.v24,
          const Divider(height: 1, color: AppColors.divider),
          AppSpacing.v24,
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime currentMonth) {
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    
    // Get first day of month and last day of month
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 for Sunday
    
    List<Widget> rows = [];
    List<String> currentDates = [];
    List<int> currentStatuses = [];
    
    // Fill leading empty days
    for (int i = 0; i < startWeekday; i++) {
      currentDates.add('');
      currentStatuses.add(-1);
    }
    
    final random = Random(currentMonth.month + currentMonth.year); // Seed for consistency per month

    for (int day = 1; day <= daysInMonth; day++) {
      currentDates.add(day.toString());
      
      // Logic for status: 1: Present, 2: Absent, 0: Off, 3: Selected
      int status = 1; // Default present
      final weekday = (startWeekday + day - 1) % 7;
      
      if (weekday == 0) {
        status = 0; // Sundays are Off
      } else if (random.nextInt(10) > 8) {
        status = 2; // Random absences
      }
      
      // Highlight "16th" as selected for the mockup feel
      if (day == 16) status = 3;
      
      currentStatuses.add(status);
      
      if (currentDates.length == 7) {
        rows.add(_buildCalendarRow(List.from(currentDates), List.from(currentStatuses)));
        rows.add(AppSpacing.v20);
        currentDates.clear();
        currentStatuses.clear();
      }
    }
    
    // Fill trailing empty days
    if (currentDates.isNotEmpty) {
      while (currentDates.length < 7) {
        currentDates.add('');
        currentStatuses.add(-1);
      }
      rows.add(_buildCalendarRow(currentDates, currentStatuses));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekdays.map((d) => SizedBox(
            width: 32,
            child: Text(
              d,
              style: AppTextStyles.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          )).toList(),
        ),
        AppSpacing.v24,
        ...rows,
      ],
    );
  }

  Widget _buildCalendarRow(List<String> dates, List<int> statuses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final date = dates[i];
        final status = statuses[i];
        return _buildCalendarDay(date, status);
      }),
    );
  }

  Widget _buildCalendarDay(String date, int status) {
    if (date.isEmpty) return const SizedBox(width: 32);
    
    bool isSelected = status == 3;
    bool isOff = status == 0;
    
    return SizedBox(
      width: 32,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBrand : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                date,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.white : (isOff ? AppColors.textMuted : AppColors.textPrimary),
                ),
              ),
            ),
          ),
          if (status != -1 && !isSelected) ...[
            AppSpacing.v4,
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: status == 1 ? AppColors.successGreen.withValues(alpha: 0.6) : (status == 2 ? AppColors.errorRed.withValues(alpha: 0.6) : Colors.transparent),
                shape: BoxShape.circle,
              ),
            ),
          ],
          if (isSelected) ...[
            AppSpacing.v4,
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(AppColors.successGreen.withValues(alpha: 0.6), 'PRESENT'),
        AppSpacing.h24,
        _buildLegendItem(AppColors.errorRed.withValues(alpha: 0.6), 'ABSENT'),
        AppSpacing.h24,
        _buildLegendItem(AppColors.textMuted.withValues(alpha: 0.4), 'OFF'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.h8,
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRemarksCard() {
    return Obx(() {
      final date = controller.selectedAttendanceMonth.value;
      final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
      
      return Container(
        width: double.infinity,
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: AppSpacing.all8,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.speaker_notes, size: 20, color: AppColors.textTertiary),
                ),
                AppSpacing.h16,
                Text(
                  '${months[date.month - 1]} 16 REMARKS',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            AppSpacing.v20,
            Text(
              'Left early for dental appointment. Approved by lead.',
              style: AppTextStyles.lexend(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    });
  }
}
