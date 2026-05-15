import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/presentation/institute/controllers/expense_controller.dart';
import 'package:fee_easy/presentation/institute/models/expense_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends GetView<ExpenseController> {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Add New Expense'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  children: [
                    _buildFormCard(context),
                    AppSpacing.v32,
                    Obx(
                      () => AppButton(
                        onPressed: () => controller.addExpense(),
                        label: 'Add Expense',
                        icon: Icons.check_circle_outline_rounded,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      padding: AppSpacing.all24,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryDropdown(),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: 'AMOUNT',
              hint: '0.00',
              icon: Icons.currency_rupee_rounded,
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              errorText: controller.amountError.value,
            ),
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: 'DESCRIPTION',
              hint: 'What was this for?',
              icon: Icons.description_rounded,
              controller: controller.descriptionController,
              errorText: controller.descriptionError.value,
            ),
          ),
          AppSpacing.v20,
          _buildDatePicker(context),
          AppSpacing.v20,
          _buildPaymentTypeToggle(),
          AppSpacing.v24,
          _buildAddReceiptButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v8,
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.categoryError.value != null
                        ? Colors.redAccent
                        : AppColors.primaryBrand.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ExpenseCategory>(
                    value: controller.selectedCategory.value,
                    isExpanded: true,
                    hint: Text(
                      'Select Category',
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    items: controller.categories.map((
                      ExpenseCategory category,
                    ) {
                      return DropdownMenuItem<ExpenseCategory>(
                        value: category,
                        child: Text(
                          category.name,
                          style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedCategory.value = value;
                      }
                    },
                  ),
                ),
              ),
              if (controller.categoryError.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    controller.categoryError.value!,
                    style: AppTextStyles.manrope(
                      fontSize: 12,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DATE',
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v8,
        GestureDetector(
          onTap: () => controller.selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBrand.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primaryBrand,
                  size: 20,
                ),
                AppSpacing.h12,
                Obx(
                  () => Text(
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format(controller.selectedDate.value),
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYMENT TYPE',
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v8,
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.primaryBrandLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    'Cash',
                    !controller.isOnlinePayment.value,
                    () => controller.togglePaymentMethod(false),
                  ),
                ),
                Expanded(
                  child: _buildToggleButton(
                    'Online',
                    controller.isOnlinePayment.value,
                    () => controller.togglePaymentMethod(true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBrand : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddReceiptButton() {
    return GestureDetector(
      onTap: () => controller.pickReceipt(),
      child: Obx(
        () => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.primaryBrandLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryBrand.withValues(alpha: 0.2),
              style: BorderStyle.solid,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                controller.selectedReceiptPath.value != null
                    ? Icons.check_circle_rounded
                    : Icons.file_upload_rounded,
                color: AppColors.primaryBrand,
                size: 28,
              ),
              AppSpacing.v8,
              Text(
                controller.selectedReceiptPath.value != null
                    ? controller.selectedReceiptPath.value!.split('/').last
                    : 'Add Receipt',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBrand,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
