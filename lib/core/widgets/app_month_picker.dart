import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppMonthPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const AppMonthPicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<AppMonthPicker> createState() => _AppMonthPickerState();
}

class _AppMonthPickerState extends State<AppMonthPicker> {
  late DateTime _selectedDate;
  late int _viewYear;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(widget.initialDate.year, widget.initialDate.month);
    _viewYear = _selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_viewYear > widget.firstDate.year) _viewYear--;
                    });
                  },
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Text(
                  _viewYear.toString(),
                  style: AppTextStyles.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_viewYear < widget.lastDate.year) _viewYear++;
                    });
                  },
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            AppSpacing.v16,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final isSelected =
                    _selectedDate.year == _viewYear &&
                    _selectedDate.month == month;
                final date = DateTime(_viewYear, month);
                final isEnabled =
                    (date.isAfter(widget.firstDate) ||
                        date.isAtSameMomentAs(widget.firstDate)) &&
                    (date.isBefore(widget.lastDate) ||
                        date.isAtSameMomentAs(widget.lastDate));

                return GestureDetector(
                  onTap:
                      isEnabled
                          ? () {
                            setState(() {
                              _selectedDate = DateTime(_viewYear, month);
                            });
                          }
                          : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryBrand
                              : (isEnabled
                                  ? AppColors.primaryBrand.withValues(
                                    alpha: 0.05,
                                  )
                                  : Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primaryBrand
                                : (isEnabled
                                    ? AppColors.primaryBrand.withValues(
                                      alpha: 0.1,
                                    )
                                    : AppColors.background.withValues(alpha: 0.5)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('MMM').format(DateTime(2000, month)),
                        style: AppTextStyles.outfit(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color:
                              isSelected
                                  ? AppColors.white
                                  : (isEnabled
                                      ? AppColors.textPrimary
                                      : AppColors.textTertiary),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            AppSpacing.v24,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    AppStrings.labelCancel,
                    style: AppTextStyles.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                AppSpacing.h16,
                ElevatedButton(
                  onPressed: () => Get.back(result: _selectedDate),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrand,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: AppTextStyles.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
