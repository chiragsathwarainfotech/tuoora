import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalaryManagementScreen extends GetView<StaffController> {
  const SalaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Salary Management'),
            Expanded(
              child: ListView(
                padding: AppSpacing.all24,
                children: [
                  _buildTotalPaidCard(),
                  AppSpacing.v24,
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildMonthPicker(context),
                  ),
                  AppSpacing.v24,
                  _buildPayoutHistory(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.instituteAddSalary),
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white, size: 32),
      ),
    );
  }

  Widget _buildMonthPicker(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: controller.selectedSalaryMonth.value,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            helpText: 'Select Payout Month',
          );
          if (picked != null) {
            controller.selectSalaryMonth(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.paleSilver,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat(
                  'MMM yyyy',
                ).format(controller.selectedSalaryMonth.value),
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.h8,
              const Icon(
                Icons.calendar_month_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPaidCard() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: AppSpacing.all32,
        decoration: BoxDecoration(
          color: AppColors.primaryBrand,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Paid this Month • ${DateFormat('MMMM yyyy').format(controller.selectedSalaryMonth.value)}',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                AppSpacing.v8,
                Text(
                  '\$4,850.00',
                  style: AppTextStyles.manrope(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                Icons.verified_rounded,
                size: 80,
                color: AppColors.white.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutHistory() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payout History',
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.file_download_outlined,
                    size: 18,
                    color: AppColors.primaryBrand,
                  ),
                  AppSpacing.h4,
                  Text(
                    'Statement',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.v24,
          const Divider(height: 1, color: AppColors.divider),
          _buildPayoutItem(
            'Sarah Jenkins',
            'Oct 24, 2023 • Online',
            '\$1,200.00',
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildPayoutItem('Michael Chen', 'Oct 22, 2023 • Cash', '\$850.00'),
          const Divider(height: 1, color: AppColors.divider),
          _buildPayoutItem(
            'Elena Rodriguez',
            'Oct 20, 2023 • Online',
            '\$1,500.00',
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildPayoutItem('David Kim', 'Oct 18, 2023 • Online', '\$1,300.00'),
        ],
      ),
    );
  }

  Widget _buildPayoutItem(String name, String sub, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(
              color: AppColors.primaryBrand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_rounded,
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
                  name,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  sub,
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
                amount,
                style: AppTextStyles.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'PAID',
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.successGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
