import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/expense_controller.dart';
import 'package:tuoora/presentation/institute/models/expense_model.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/common_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/institute/widgets/month_selector_widget.dart';
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
            const InstituteAppBar(title: AppStrings.expenseAnalysis),
            Expanded(
              child: Obx(() {
                final analysis = controller.expenseAnalysis.value;
                return RefreshIndicator(
                  color: AppColors.primaryBrand,
                  onRefresh: () => controller.loadExpenseAnalysis(),
                  child: ListView(
                    padding: AppSpacing.screenPaddingTop,
                    children: [
                      _buildTotalSpendingCard(analysis),
                      AppSpacing.v24,
                      _buildDateAndNavHeader(context),
                      AppSpacing.v24,
                      Text(
                        AppStrings.categoriesBreakdown,
                        style: AppTextStyles.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.v16,
                      CommonStateWidget(
                        isLoading: controller.isAnalysisLoading.value,
                        isEmpty:
                            analysis == null || analysis.categories.isEmpty,
                        emptyTitle: AppStrings.noDataForThisMonth,
                        emptySubtitle: AppStrings.addExpensesToSeeTheAnalysis,
                        emptyIcon: Icons.analytics_outlined,
                        child: _buildCategoryList(analysis),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSpendingCard(ExpenseAnalysis? analysis) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.primaryBrand,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.totalSpending,
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
              if (analysis != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Text(
                    analysis.monthName,
                    style: AppTextStyles.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
          AppSpacing.v12,
          Text(
            analysis != null
                ? currencyFormat.format(analysis.totalSpending)
                : '₹0.00',
            style: AppTextStyles.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndNavHeader(BuildContext context) {
    return Obx(() {
      final selectedDate = controller.selectedAnalysisMonth.value;
      final isPrevEnabled = selectedDate.year > 2026 ||
          (selectedDate.year == 2026 && selectedDate.month > 1);

      return MonthSelectorWidget(
        selectedMonth: selectedDate,
        onMonthChanged: (date) {
          controller.setAnalysisMonth(date);
        },
        isNextEnabled: controller.canGoToNextMonth,
        isPrevEnabled: isPrevEnabled,
        minDate: DateTime(2026, 1),
        maxDate: DateTime.now(),
        helpText: 'Select Analysis Month',
      );
    });
  }

  Widget _buildCategoryList(ExpenseAnalysis? analysis) {
    if (analysis == null) return const SizedBox.shrink();

    return Column(
      children: analysis.categories.map((cat) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildCategoryProgressItem(
            cat.categoryName,
            '₹${cat.amount.toStringAsFixed(2)}',
            cat.percentage / 100,
            _getCategoryIcon(cat.categoryName),
            _getCategoryColor(cat.categoryName),
          ),
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bills':
        return Icons.bolt_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Food & Drink':
        return Icons.local_cafe_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bills':
        return AppColors.studentProgressBlue;
      case 'Shopping':
        return AppColors.warningAmber;
      case 'Entertainment':
        return AppColors.warningAmber;
      case 'Food & Drink':
        return AppColors.successGreen;
      case 'Transport':
        return AppColors.subjectPhysics;
      default:
        return AppColors.primaryBrand;
    }
  }

  Widget _buildCategoryProgressItem(
    String title,
    String amount,
    double progress,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
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
                      style: AppTextStyles.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      amount,
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
