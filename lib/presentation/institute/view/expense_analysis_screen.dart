import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/expense_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseAnalysisScreen extends GetView<ExpenseController> {
  const ExpenseAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Expense Analysis'),
            Expanded(
              child: ListView(
                padding: AppSpacing.all24,
                children: [
                  Obx(() => _buildTotalSpendingCard()),
                  AppSpacing.v24,
                  _buildDateAndNavHeader(context),
                  AppSpacing.v24,
                  Text(
                    'Categories',
                    style: AppTextStyles.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v16,
                  Obx(() => _buildCategoryList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSpendingCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spending',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.v8,
          Text(
            '₹3,428.50',
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndNavHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: controller.selectedAnalysisMonth.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              helpText: 'Select Month',
            );
            if (picked != null) {
              controller.setAnalysisMonth(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                AppSpacing.h8,
                Obx(
                  () => Text(
                    DateFormat(
                      'MMMM yyyy',
                    ).format(controller.selectedAnalysisMonth.value),
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                AppSpacing.h4,
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            _buildSmallNavButton(
              Icons.chevron_left_rounded,
              onTap: () => controller.prevAnalysisMonth(),
            ),
            AppSpacing.h12,
            _buildSmallNavButton(
              Icons.chevron_right_rounded,
              onTap: () => controller.nextAnalysisMonth(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallNavButton(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildCategoryList() {
    // Mocking data that "changes" with the month
    final month = controller.selectedAnalysisMonth.value.month;
    return Column(
      children: [
        _buildCategoryProgressItem(
          'Food & Dining',
          '₹${1200 + month * 10}',
          0.45,
          Icons.restaurant_rounded,
          const Color(0xFFB45309),
        ),
        AppSpacing.v16,
        _buildCategoryProgressItem(
          'Shopping',
          '₹${800 + month * 5}',
          0.30,
          Icons.shopping_bag_rounded,
          const Color(0xFF005C70),
        ),
        AppSpacing.v16,
        _buildCategoryProgressItem(
          'Transport',
          '₹${400 + month * 3}',
          0.15,
          Icons.directions_car_rounded,
          const Color(0xFF059669),
        ),
      ],
    );
  }

  Widget _buildCategoryProgressItem(
    String title,
    String amount,
    double progress,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  amount,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
