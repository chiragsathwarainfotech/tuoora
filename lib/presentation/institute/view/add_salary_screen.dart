import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddSalaryScreen extends GetView<StaffController> {
  const AddSalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Add Salary'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      label: 'SELECT STAFF MEMBER',
                      child: Obx(() {
                        if (controller.selectedAddSalaryStaff.value != null) {
                          return _buildSelectedStaffCard(
                            controller.selectedAddSalaryStaff.value!,
                          );
                        } else {
                          return _buildStaffSearchField();
                        }
                      }),
                    ),
                    AppSpacing.v20,
                    Obx(
                      () => AppInputField(
                        label: 'PAYMENT DATE',
                        hint: 'MM/dd/yyyy',
                        icon: Icons.calendar_today_rounded,
                        controller: TextEditingController(
                          text: DateFormat(
                            'MM/dd/yyyy',
                          ).format(controller.selectedSalaryDate.value),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: controller.selectedSalaryDate.value,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            controller.selectSalaryDate(picked);
                          }
                        },
                      ),
                    ),
                    AppSpacing.v20,
                    AppInputField(
                      label: 'SALARY AMOUNT',
                      controller: controller.salaryAmountController,
                      hint: '0.00',
                      icon: Icons.currency_rupee_sharp,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => controller.update(),
                    ),
                    AppSpacing.v24,
                    Text(
                      'PAYMENT METHOD',
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandAppBarColor,
                      ),
                    ),
                    AppSpacing.v12,
                    _buildPaymentMethodToggle(),
                    AppSpacing.v24,
                    AppInputField(
                      label: 'NOTES (OPTIONAL)',
                      controller: controller.salaryNotesController,
                      hint: 'Add any specific details regarding bonuses...',
                      maxLines: 3,
                    ),
                    AppSpacing.v32,
                    _buildDisbursementSummary(),
                    AppSpacing.v32,
                    _buildSaveButton(),
                    AppSpacing.v40,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String label, required Widget child}) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v12,
          child,
        ],
      ),
    );
  }

  Widget _buildStaffSearchField() {
    return Column(
      children: [
        AppSearchField(
          hintText: 'Search by name or role...',
          onChanged: (val) => controller.searchSalaryStaff(val),
        ),
        Obx(() {
          if (controller.filteredSalaryStaffs.isEmpty ||
              controller.salarySearchQuery.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: controller.filteredSalaryStaffs.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final staff = controller.filteredSalaryStaffs[index];
                return ListTile(
                  leading: const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                  ),
                  title: Text(
                    staff.name,
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    staff.role,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  onTap: () => controller.setSalaryStaff(staff),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSelectedStaffCard(Staff staff) {
    return Container(
      padding: AppSpacing.all12,
      decoration: BoxDecoration(
        color: AppColors.paleSilver.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBrand.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  staff.role,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.removeSalaryStaff(),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.bohoRed,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodToggle() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.togglePaymentMethod(false),
              child: _buildToggleButton(
                'Cash',
                Icons.payments_rounded,
                AppColors.primaryBrand,
                !controller.isOnlinePayment.value,
              ),
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: GestureDetector(
              onTap: () => controller.togglePaymentMethod(true),
              child: _buildToggleButton(
                'Online',
                Icons.account_balance_rounded,
                AppColors.primaryBrand,
                controller.isOnlinePayment.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? color : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? color : AppColors.textTertiary,
            size: 28,
          ),
          AppSpacing.v12,
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected ? color : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisbursementSummary() {
    return GetBuilder<StaffController>(
      builder: (controller) {
        final amount = controller.salaryAmountController.text.isEmpty
            ? '0.00'
            : controller.salaryAmountController.text;
        return Container(
          padding: AppSpacing.all24,
          decoration: BoxDecoration(
            color: AppColors.primaryBrand.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryBrand.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Disbursement',
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '₹$amount',
                    style: AppTextStyles.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ],
              ),
              AppSpacing.v16,
              const Divider(height: 1),
              AppSpacing.v16,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryBrand,
                    size: 16,
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: Text(
                      'This payment will be recorded in the general ledger and deducted from the monthly payroll budget.',
                      style: AppTextStyles.lexend(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return AppButton(
      onPressed: () {
        final staffError = ValidationUtils.validateStaffSelection(
          controller.selectedAddSalaryStaff.value,
        );
        if (staffError != null) {
          Get.snackbar(
            'Selection Required',
            staffError,
            backgroundColor: Colors.orange.withValues(alpha: 0.1),
            colorText: AppColors.textPrimary,
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            snackPosition: SnackPosition.BOTTOM,
            margin: AppSpacing.all16,
          );
          return;
        }

        final amountStr = controller.salaryAmountController.text;
        final amountError = ValidationUtils.validateAmount(
          amountStr,
          'Salary amount',
        );
        if (amountError != null) {
          Get.snackbar(
            'Invalid Amount',
            amountError,
            backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
            colorText: AppColors.textPrimary,
            icon: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorRed,
            ),
            snackPosition: SnackPosition.BOTTOM,
            margin: AppSpacing.all16,
          );
          return;
        }

        final staffName = controller.selectedAddSalaryStaff.value!.name;
        Get.back();
        Get.snackbar(
          'Payment Recorded',
          'Salary payout of ₹$amountStr for $staffName saved successfully.',
          backgroundColor: AppColors.successGreen.withValues(alpha: 0.1),
          colorText: AppColors.textPrimary,
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.successGreen,
          ),
          snackPosition: SnackPosition.BOTTOM,
          margin: AppSpacing.all16,
        );

        // Reset state
        controller.selectedAddSalaryStaff.value = null;
        controller.salaryAmountController.clear();
        controller.salaryNotesController.clear();
      },
      label: 'Save Salary Record',
      icon: Icons.check_circle_outline_rounded,
    );
  }
}
