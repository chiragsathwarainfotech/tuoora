import 'dart:io';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/presentation/institute/controllers/staff_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
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
                child: Form(
                  key: controller.addStaffFormKey,
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
          Obx(
            () => AppInputField(
              label: 'Full Name',
              controller: controller.staffNameController,
              hint: 'Eleanor Shellstrop',
              icon: Icons.person,
              errorText: controller.staffNameError.value,
              validator: (value) =>
                  ValidationUtils.validateRequired(value, 'Full name'),
            ),
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
                    Obx(() => _buildRoleDropdown(controller.roleError.value)),
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
                    Obx(
                      () =>
                          _buildDepartmentDropdown(controller.deptError.value),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: 'Email Address',
              controller: controller.staffEmailController,
              hint: 'eleanor.s@company.com',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              errorText: controller.staffEmailError.value,
              validator: ValidationUtils.validateEmail,
            ),
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: 'Phone Number',
              controller: controller.staffPhoneController,
              hint: '0123456789',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              errorText: controller.staffPhoneError.value,
              validator: ValidationUtils.validatePhone,
            ),
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
                child: Obx(
                  () => _buildToggleButton(
                    'Salary',
                    controller.employmentType.value == 'Salary',
                    () => controller.employmentType.value = 'Salary',
                  ),
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: Obx(
                  () => _buildToggleButton(
                    'Hourly',
                    controller.employmentType.value == 'Hourly',
                    () => controller.employmentType.value = 'Hourly',
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          Obx(
            () => AppInputField(
              label: controller.employmentType.value == 'Salary'
                  ? 'Base Salary'
                  : 'Hourly Rate',
              controller: controller.staffSalaryController,
              hint: '0.00',
              icon: Icons.payments_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              errorText: controller.staffSalaryError.value,
              validator: (value) => ValidationUtils.validateAmount(
                value,
                controller.employmentType.value == 'Salary'
                    ? 'Base Salary'
                    : 'Hourly Rate',
              ),
            ),
          ),
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
              Obx(
                () => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrandLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBrand.withValues(alpha: 0.1),
                    ),
                    image: controller.selectedImagePath.value != null
                        ? DecorationImage(
                            image: FileImage(
                              File(controller.selectedImagePath.value!),
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image:
                                controller.selectedStaff.value?.profileUrl !=
                                    null
                                ? NetworkImage(
                                    controller.selectedStaff.value!.profileUrl!,
                                  )
                                : const NetworkImage(
                                    'https://ui-avatars.com/api/?name=Staff&background=00A3A3&color=fff',
                                  ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
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

  Widget _buildRoleDropdown(String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.paleSilver,
            borderRadius: BorderRadius.circular(12),
            border: errorText != null
                ? Border.all(color: Colors.redAccent, width: 1.5)
                : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: controller.selectedRoleId.value,
              isExpanded: true,
              hint: Text(
                'Select Role',
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.blueSapphire,
              ),
              items: controller.roles.map((role) {
                return DropdownMenuItem<int>(
                  value: role.id,
                  child: Text(
                    role.name,
                    style: AppTextStyles.lexend(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) => controller.selectedRoleId.value = val,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: AppTextStyles.manrope(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDepartmentDropdown(String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.paleSilver,
            borderRadius: BorderRadius.circular(12),
            border: errorText != null
                ? Border.all(color: Colors.redAccent, width: 1.5)
                : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: controller.selectedDepartmentId.value,
              isExpanded: true,
              hint: Text(
                'Select Dept',
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.blueSapphire,
              ),
              items: controller.departments.map((dept) {
                return DropdownMenuItem<int>(
                  value: dept.id,
                  child: Text(
                    dept.name,
                    style: AppTextStyles.lexend(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) => controller.selectedDepartmentId.value = val,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: AppTextStyles.manrope(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
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
    return Obx(
      () => AppButton(
        onPressed: controller.isSaving.value
            ? null
            : () => controller.saveStaff(),
        isLoading: controller.isSaving.value,
        label: isEdit ? 'Update Staff Member' : 'Save Staff Member',
      ),
    );
  }

  Widget _buildDiscardButton() {
    return GestureDetector(
      onTap: () {
        controller.clearStaffForm();
        Get.back();
      },
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
