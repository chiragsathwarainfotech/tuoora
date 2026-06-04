import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/presentation/institute/controllers/leads_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddEditLeadScreen extends GetView<LeadsController> {
  const AddEditLeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => InstituteAppBar(
                title: controller.editingLeadId.value != null
                    ? AppStrings.instEditLeadTitle
                    : AppStrings.instAddLeadTitle,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x16.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeadInformationSection(),
                    AppSpacing.v40,
                    SafeArea(
                      top: false,
                      minimum: const EdgeInsets.only(bottom: 16),
                      child: Obx(
                        () => AppButton(
                          label: controller.editingLeadId.value != null
                              ? AppStrings.instEditLeadTitle
                              : AppStrings.instSaveLeadBtn,
                          isLoading: controller.isLoading.value,
                          onPressed: () => controller.saveLead(),
                        ),
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

  Widget _buildLeadInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => AppInputField(
            label: AppStrings.instStudentNameLabel,
            hint: AppStrings.instStudentNameHint,
            controller: controller.nameController,
            errorText: controller.triedToSave.value
                ? controller.nameError.value
                : null,
          ),
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instStudentEmailLabel,
            hint: AppStrings.instStudentEmailHint,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            errorText: controller.triedToSave.value
                ? controller.emailError.value
                : null,
          ),
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instPhoneLabel,
            hint: AppStrings.instPhoneHint,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText: controller.triedToSave.value
                ? controller.phoneError.value
                : null,
          ),
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instAddressLabel,
            hint: AppStrings.instAddressHint,
            controller: controller.addressController,
            maxLines: 3,
            errorText: controller.triedToSave.value
                ? controller.addressError.value
                : null,
          ),
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instReferenceLabel,
            hint: AppStrings.instReferenceHint,
            controller: controller.referenceController,
            errorText: controller.triedToSave.value
                ? controller.referenceError.value
                : null,
          ),
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instCourseSelectionLabel,
            hint: AppStrings.instCourseSelectionHint,
            controller: controller.courseController,
            errorText: controller.triedToSave.value
                ? controller.courseError.value
                : null,
          ),
        ),
      ],
    );
  }
}
