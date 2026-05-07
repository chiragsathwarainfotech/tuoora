import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/expense_controller.dart';
import 'package:fee_easy/presentation/institute/models/expense_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends GetView<ExpenseController> {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Expenses',
              actions: [
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.instituteExpenseAnalysis),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: AppColors.brandAppBarColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: AppSpacing.all24,
                  itemCount: controller.expenses.length,
                  separatorBuilder: (context, index) => AppSpacing.v16,
                  itemBuilder: (context, index) {
                    final expense = controller.expenses[index];
                    return _buildExpenseCard(expense);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.resetForm();
          Get.toNamed(AppRoutes.instituteAddExpense);
        },
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseModel expense) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: expense.iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              expense.icon,
              color: _getIconColor(expense.iconBgColor),
              size: 24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  '${dateFormat.format(expense.date)} • ${expense.category}',
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
            '-${currencyFormat.format(expense.amount)}',
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

  Color _getIconColor(Color bgColor) {
    if (bgColor == const Color(0xFFFFF7ED)) return const Color(0xFF9A3412);
    if (bgColor == const Color(0xFFEFF6FF)) return const Color(0xFF1E40AF);
    if (bgColor == const Color(0xFFFAF5FF)) return const Color(0xFF6B21A8);
    if (bgColor == const Color(0xFFECFDF5)) return const Color(0xFF065F46);
    if (bgColor == const Color(0xFFF1F5F9)) return const Color(0xFF475569);

    return AppColors.primaryBrand;
  }
}
