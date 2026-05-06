import 'dart:io';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditStaffScreen extends GetView<StaffController> {
  const AddEditStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isEdit = controller.selectedStaff.value != null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: isEdit ? 'Edit Staff Member' : 'Staff Management',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  children: [
                    _buildMainFormCard(context),
                    AppSpacing.v24,
                    _buildSaveButton(isEdit),
                    AppSpacing.v16,
                    _buildDiscardButton(),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFormCard(BuildContext context) {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImageSection(context),
          AppSpacing.v32,
          AppInputField(
            label: 'Full Name',
            controller: TextEditingController(
              text: controller.selectedStaff.value?.name,
            ),
            hint: 'Eleanor Shellstrop',
            icon: Icons.person,
          ),
          AppSpacing.v20,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Role',
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandAppBarColor,
                      ),
                    ),
                    AppSpacing.v8,
                    Obx(() => _buildDropdown(
                          controller.selectedRole.value,
                          controller.roles,
                          (val) => controller.selectedRole.value = val!,
                        )),
                  ],
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Department',
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandAppBarColor,
                      ),
                    ),
                    AppSpacing.v8,
                    Obx(() => _buildDropdown(
                          controller.selectedDepartment.value,
                          controller.departments,
                          (val) => controller.selectedDepartment.value = val!,
                        )),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'Email Address',
            controller: TextEditingController(
              text: controller.selectedStaff.value?.email,
            ),
            hint: 'eleanor.s@company.com',
            icon: Icons.email_rounded,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'Phone Number',
            controller: TextEditingController(
              text: controller.selectedStaff.value?.phone,
            ),
            hint: '+1 (555) 000-1234',
            icon: Icons.phone,
          ),
          AppSpacing.v32,
          Text(
            'Employment Type',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
            ),
          ),
          AppSpacing.v12,
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildToggleButton(
                      'Salary',
                      controller.isSalaryType.value,
                      () => controller.isSalaryType.value = true,
                    )),
              ),
              AppSpacing.h12,
              Expanded(
                child: Obx(() => _buildToggleButton(
                      'Hourly',
                      !controller.isSalaryType.value,
                      () => controller.isSalaryType.value = false,
                    )),
              ),
            ],
          ),
          AppSpacing.v24,
          Obx(() => AppInputField(
                label: controller.isSalaryType.value
                    ? 'Base Salary'
                    : 'Hourly Rate',
                controller: TextEditingController(
                  text: controller.isSalaryType.value ? '95,000' : '50.00',
                ),
                hint: '0.00',
                icon: Icons.payments_rounded,
              )),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.showImagePickerSourceSheet(context),
          child: Stack(
            children: [
              Obx(() => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  shape: BoxShape.circle,
                  image: controller.selectedImagePath.value != null
                      ? DecorationImage(
                          image: FileImage(File(controller.selectedImagePath.value!)),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: NetworkImage('https://i.pravatar.cc/300'),
                          fit: BoxFit.cover,
                        ),
                ),
              )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrand,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Staff Photo',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v4,
              Text(
                'Update professional information and profile picture',
                style: AppTextStyles.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.blueSapphire,
          ),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBrand : AppColors.paleSilver,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isEdit) {
    return AppButton(
      onPressed: () {
        Get.back();
        Get.snackbar('Success', 'Staff member details saved');
      },
      label: 'Save Staff Member',
    );
  }

  Widget _buildDiscardButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderGrey, width: 1.5),
        ),
        child: Center(
          child: Text(
            'Discard Changes',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBrand,
            ),
          ),
        ),
      ),
    );
  }
}
