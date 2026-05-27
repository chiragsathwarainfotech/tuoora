import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/staff_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/institute/widgets/month_selector_widget.dart';
import 'package:tuoora/presentation/institute/widgets/common_state_widget.dart';
import 'package:intl/intl.dart';

class SalaryManagementScreen extends GetView<StaffController> {
  const SalaryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.globalSalaryList.isEmpty) {
      controller.fetchGlobalSalaries(page: 1);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Salary Management'),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchGlobalSalaries(page: 1),
                color: AppColors.primaryBrand,
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
      () => MonthSelectorWidget(
        selectedMonth: controller.selectedSalaryMonth.value,
        onMonthChanged: (date) {
          controller.selectedSalaryMonth.value = date;
          controller.fetchGlobalSalaries(page: null);
        },
        isNextEnabled: controller.canGoToNextSalaryMonth,
        maxDate: DateTime.now(),
        helpText: 'Select Payout Month',
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
                  'Total Paid this Month â€¢ ${DateFormat('MMMM yyyy').format(controller.selectedSalaryMonth.value)}',
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                AppSpacing.v8,
                Text(
                  '₹${controller.totalGlobalSalaryAmount.value}',
                  style: AppTextStyles.outfit(
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
    return Obx(() {
      return CommonStateWidget(
        isLoading: controller.isLoadingGlobalSalaries.value,
        isEmpty: controller.globalSalaryList.isEmpty,
        emptyTitle: 'No Records Found',
        emptySubtitle: 'No salary payout records found for this month.',
        emptyIcon: Icons.receipt_long_rounded,
        child: Container(
          padding: AppSpacing.all24,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.background),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payout History',
                    style: AppTextStyles.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              AppSpacing.v24,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.globalSalaryList.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.background),
                itemBuilder: (context, index) {
                  final salary = controller.globalSalaryList[index];
                  final date = DateFormat(
                    'MMM dd, yyyy',
                  ).format(DateTime.parse(salary.paymentDate));
                  return _buildPayoutItem(
                    salary.staff?.fullName ?? 'Unknown Staff',
                    '$date â€¢ ${salary.paymentMethod}',
                    '₹${salary.netSalary}',
                    salary.staff?.profileUrl ?? '',
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPayoutItem(
    String name,
    String sub,
    String amount,
    String imageUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _buildStaffAvatar(name, imageUrl),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  sub,
                  style: AppTextStyles.outfit(
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
                style: AppTextStyles.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'PAID',
                style: AppTextStyles.outfit(
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

  Widget _buildStaffAvatar(String name, String? profileUrl) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primaryBrand.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: profileUrl != null && profileUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                profileUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildInitials(name),
              ),
            )
          : _buildInitials(name),
    );
  }

  Widget _buildInitials(String name) {
    return Center(
      child: Text(
        getInitials(name),
        style: AppTextStyles.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryBrand,
        ),
      ),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return 'S';
    List<String> names = name.split(' ');
    if (names.length > 1) {
      return (names[0][0] + names[names.length - 1][0]).toUpperCase();
    }
    return names[0][0].toUpperCase();
  }
}
