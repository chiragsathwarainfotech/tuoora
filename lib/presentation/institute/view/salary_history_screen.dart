import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:fee_easy/presentation/shared/widgets/common_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalaryHistoryScreen extends GetView<StaffController> {
  const SalaryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Salary History'),
            Expanded(
              child: Obx(() {
                final salaries = controller.salaryList;
                return CommonStateWidget(
                  isLoading:
                      controller.isLoadingSalary.value && salaries.isEmpty,
                  isEmpty: salaries.isEmpty,
                  emptyTitle: 'No Salary Records',
                  emptySubtitle:
                      'No salary payments found for this staff member.',
                  emptyIcon: Icons.payments_outlined,
                  child: ListView.separated(
                    padding: AppSpacing.all24,
                    itemCount: salaries.length,
                    separatorBuilder: (_, _) => AppSpacing.v16,
                    itemBuilder: (context, index) {
                      final salary = salaries[index];
                      return _buildSalaryCard(salary);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryCard(StaffSalary salary) {
    DateTime paymentDate;
    try {
      paymentDate = DateTime.parse(salary.paymentDate);
    } catch (e) {
      paymentDate = DateTime.now();
    }

    final monthStr = DateFormat('MMMM yyyy').format(paymentDate);
    final dateStr = 'Paid on ${DateFormat('MMM dd, yyyy').format(paymentDate)}';

    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: const BoxDecoration(
              color: AppColors.primaryBrandLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payments_rounded,
              color: AppColors.primaryBrand,
              size: 24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthStr,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  dateStr,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${salary.netSalary}',
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                salary.paymentMethod,
                style: AppTextStyles.lexend(
                  fontSize: 10,
                  color: AppColors.primaryBrand,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
