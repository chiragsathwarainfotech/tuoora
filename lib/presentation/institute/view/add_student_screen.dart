import 'dart:io';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditStudentScreen extends GetView<InstituteStudentController> {
  const AddEditStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Obx(
                  () => InstituteAppBar(
                    title: controller.editingStudentId.value != null
                        ? 'Edit Student'
                        : 'Add New Student',
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.x24.add(AppSpacing.y16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMainFormCard(context),
                        AppSpacing.v24,
                        _buildActionButtons(),
                        AppSpacing.v32,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(child: CommonLoading()),
                  )
                : const SizedBox.shrink(),
          ),
        ],
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
            offset: const Offset(0, AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.showImagePickerSourceSheet(context),
                child: Stack(
                  children: [
                    Obx(
                      () => Container(
                        width: AppSpacing.s80,
                        height: AppSpacing.s80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrandLight,
                          shape: BoxShape.circle,
                          image: controller.selectedImagePath.value != null
                              ? DecorationImage(
                                  image: FileImage(
                                    File(controller.selectedImagePath.value!),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : (controller
                                            .currentStudent
                                            .value
                                            ?.profileImageUrl !=
                                        null &&
                                    controller
                                        .currentStudent
                                        .value!
                                        .profileImageUrl
                                        .isNotEmpty &&
                                    !controller
                                        .currentStudent
                                        .value!
                                        .profileImageUrl
                                        .contains('ui-avatars.com'))
                              ? DecorationImage(
                                  image: NetworkImage(
                                    controller
                                        .currentStudent
                                        .value!
                                        .profileImageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child:
                            (controller.selectedImagePath.value == null &&
                                (controller
                                            .currentStudent
                                            .value
                                            ?.profileImageUrl ==
                                        null ||
                                    controller
                                        .currentStudent
                                        .value!
                                        .profileImageUrl
                                        .isEmpty ||
                                    controller
                                        .currentStudent
                                        .value!
                                        .profileImageUrl
                                        .contains('ui-avatars.com')))
                            ? Center(
                                child: Text(
                                  _getInitials(
                                    controller.currentStudent.value?.name ?? "",
                                  ),
                                  style: AppTextStyles.manrope(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryBrand,
                                  ),
                                ),
                              )
                            : null,
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
                      AppStrings.instStudentPhotoLabel,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      AppStrings.instStudentPhotoHint,
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
          ),
          AppSpacing.v32,
          _buildInputField(
            label: AppStrings.instStudentNameLabel,
            hint: AppStrings.instNameHint,
            icon: Icons.person,
            controller: controller.nameController,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instStudentEmailLabel,
            hint: 'student@example.com',
            icon: Icons.email_rounded,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: controller.editingStudentId.value == null,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instStudentDobLabel,
            hint: 'YYYY-MM-DD',
            icon: Icons.calendar_today_rounded,
            controller: controller.dobController,
            readOnly: true,
            onTap: () => controller.selectDOB(context),
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instGuardianNameLabel,
            hint: AppStrings.instGuardianHint,
            icon: Icons.group,
            controller: controller.parentNameController,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instPhoneLabel,
            hint: AppStrings.instPhoneHint,
            icon: Icons.phone,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instGradeLabel,
            hint: AppStrings.instGradeHint,
            icon: Icons.school,
            controller: controller.standardController,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.paleSilver
                : AppColors.paleSilver.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            enabled: enabled,
            onTap: onTap,
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.lexend(
                fontSize: 14,
                color: AppColors.blueSapphire,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.blueSapphire,
                size: AppSpacing.s20,
              ),
              border: InputBorder.none,
              contentPadding: AppSpacing.all16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Obx(
          () => AppButton(
            label: controller.editingStudentId.value != null
                ? 'Update Student'
                : AppStrings.instConfirmBtn,
            isDisabled: !controller.isFormValid.value,
            onPressed: () => controller.saveStudent(
              isEdit: controller.editingStudentId.value != null,
            ),
          ),
        ),
        AppSpacing.v16,
        GestureDetector(
          onTap: () => controller.discardChanges(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
              border: Border.all(color: AppColors.borderGrey, width: 1.5),
            ),
            child: Center(
              child: Text(
                AppStrings.instDiscardBtn,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty && names[0].isNotEmpty) {
      initials += names[0][0].toUpperCase();
      if (names.length > 1 && names[names.length - 1].isNotEmpty) {
        initials += names[names.length - 1][0].toUpperCase();
      }
    }
    return initials.isEmpty ? '?' : initials;
  }
}
