import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_month_picker.dart';
import 'package:get/get.dart';

class MonthSelectorWidget extends StatelessWidget {
  final DateTime selectedMonth;
  final Function(DateTime) onMonthChanged;
  final String? helpText;
  final bool isNextEnabled;
  final bool isPrevEnabled;
  final DateTime? maxDate;

  const MonthSelectorWidget({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
    this.helpText,
    this.isNextEnabled = true,
    this.isPrevEnabled = true,
    this.maxDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Month Picker with Dropdown Icon
        GestureDetector(
          onTap: () async {
            final picked = await Get.dialog<DateTime>(
              AppMonthPicker(
                initialDate: selectedMonth,
                firstDate: DateTime(2020),
                lastDate: maxDate ?? DateTime.now(),
              ),
            );
            if (picked != null) {
              onMonthChanged(DateTime(picked.year, picked.month));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 22,
                  color: AppColors.primaryBrand,
                ),
                AppSpacing.h12,
                Text(
                  DateFormat('MMMM yyyy').format(selectedMonth),
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.h8,
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),

        // Right: Navigation Arrows
        Row(
          children: [
            _buildArrowButton(
              icon: Icons.chevron_left_rounded,
              onTap: () {
                onMonthChanged(
                  DateTime(selectedMonth.year, selectedMonth.month - 1),
                );
              },
              isEnabled: isPrevEnabled,
            ),
            AppSpacing.h12,
            _buildArrowButton(
              icon: Icons.chevron_right_rounded,
              onTap: () {
                onMonthChanged(
                  DateTime(selectedMonth.year, selectedMonth.month + 1),
                );
              },
              isEnabled: isNextEnabled,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.3,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(icon, size: 24, color: AppColors.primaryBrand),
        ),
      ),
    );
  }
}
