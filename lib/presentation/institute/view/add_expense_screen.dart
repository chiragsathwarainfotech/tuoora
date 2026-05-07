import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/presentation/institute/controllers/expense_controller.dart';
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
            const InstituteAppBar(title: 'Add Expense'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryDropdown(),
                      AppSpacing.v20,
                      AppInputField(
                        label: 'AMOUNT',
                        controller: controller.amountController,
                        hint: '0.00',
                        icon: Icons.currency_rupee_sharp,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) =>
                            ValidationUtils.validateAmount(value, 'Amount'),
                      ),
                      AppSpacing.v20,
                      Obx(
                        () => AppInputField(
                          label: 'DATE',
                          hint: 'Today',
                          icon: Icons.calendar_today_rounded,
                          controller: TextEditingController(
                            text: DateFormat(
                              'MMMM dd, yyyy',
                            ).format(controller.selectedDate.value),
                          ),
                          readOnly: true,
                          onTap: () => controller.selectDate(context),
                        ),
                      ),
                      AppSpacing.v20,
                      Text(
                        'PAYMENT TYPE',
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brandAppBarColor,
                        ),
                      ),
                      AppSpacing.v12,
                      _buildPaymentMethodToggle(),
                      AppSpacing.v20,
                      AppInputField(
                        label: 'DESCRIPTION',
                        controller: controller.descriptionController,
                        hint: 'What was this for?',
                        maxLines: 3,
                        validator: (value) => ValidationUtils.validateRequired(
                          value,
                          'Description',
                        ),
                      ),
                      AppSpacing.v24,
                      _buildAddReceiptButton(),
                      AppSpacing.v32,
                      AppButton(
                        onPressed: () => controller.addExpense(),
                        label: 'Save Transaction',
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      AppSpacing.v24,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBrand.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedCategory.value,
                isExpanded: true,
                items: controller.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
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
        ),
      ],
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
                controller.isOnlinePayment.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBrand.withValues(alpha: 0.05)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryBrand : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryBrand : AppColors.textTertiary,
            size: 24,
          ),
          AppSpacing.v8,
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColors.primaryBrand
                  : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddReceiptButton() {
    return Container(
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
          const Icon(
            Icons.add_a_photo_rounded,
            color: AppColors.primaryBrand,
            size: 28,
          ),
          AppSpacing.v8,
          Text(
            'Add Receipt',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBrand,
            ),
          ),
        ],
      ),
    );
  }
}
