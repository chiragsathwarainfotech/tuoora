import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/data/models/staff_model.dart';
import 'package:tuoora/presentation/institute/controllers/staff_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:tuoora/core/widgets/app_pickers.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:tuoora/presentation/institute/widgets/institute_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                padding: AppSpacing.all16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InstituteLabel('Select Member'),
                    Obx(() {
                      if (controller.selectedAddSalaryStaff.value != null) {
                        return _buildSelectedStaffCard(
                          controller.selectedAddSalaryStaff.value!,
                        );
                      } else {
                        return _buildStaffSearchField();
                      }
                    }),
                    AppSpacing.v20,
                    AppInputField(
                      label: 'Payment Date',
                      hint: 'MM/dd/yyyy',
                      icon: Icons.calendar_today_rounded,
                      controller: controller.salaryDateController,
                      readOnly: true,
                      onTap: () async {
                        final picked = await AppPickers.date(
                          context,
                          initialDate: controller.selectedSalaryDate.value,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.selectSalaryDate(picked);
                        }
                      },
                    ),
                    AppSpacing.v20,
                    AppInputField(
                      label: 'Salary Amount',
                      controller: controller.salaryAmountController,
                      hint: '0.00',
                      icon: Icons.currency_rupee_sharp,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => controller.update(),
                    ),
                    AppSpacing.v24,
                    const InstituteLabel('Payment Method'),
                    _buildPaymentMethodToggle(),
                    AppSpacing.v24,
                    AppInputField(
                      label: 'Notes (OPTIONAL)',
                      controller: controller.salaryNotesController,
                      hint: 'Enter optional note',
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

  Widget _buildStaffSearchField() {
    return Column(
      children: [
        AppSearchField(
          hintText: 'Search member by name',
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
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.background),
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
                  leading: _buildStaffAvatar(staff.fullName, staff.profileUrl),
                  title: Text(
                    staff.fullName,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    staff.role?.name ?? "",
                    style: AppTextStyles.outfit(
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
          _buildStaffAvatar(staff.fullName, staff.profileUrl),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.fullName,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  staff.role?.name ?? "",
                  style: AppTextStyles.outfit(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.removeSalaryStaff(),
            icon: const AppActionIcon(asset: AppImages.icDelete, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffAvatar(String name, String? profileUrl) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryBrand.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: profileUrl != null && profileUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
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

  Widget _buildPaymentMethodToggle() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.isOnlinePayment.value = false,
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
              onTap: () => controller.isOnlinePayment.value = true,
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
          color: isSelected ? color : AppColors.background,
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
            style: AppTextStyles.outfit(
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
                    style: AppTextStyles.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '₹$amount',
                    style: AppTextStyles.outfit(
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
                      style: AppTextStyles.outfit(
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
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Obx(
        () => AppButton(
          onPressed: controller.isSaving.value
              ? null
              : () => controller.saveSalaryRecord(),
          label: controller.isSaving.value ? 'Saving...' : 'Save Salary Record',
          icon: controller.isSaving.value
              ? null
              : Icons.check_circle_outline_rounded,
          isLoading: controller.isSaving.value,
        ),
      ),
    );
  }
}
