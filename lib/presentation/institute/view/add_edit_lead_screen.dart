import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/presentation/institute/controllers/leads_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
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
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLeadInformationSection(),
                    AppSpacing.v32,
                    _buildSectionHeader(
                      Icons.school_rounded,
                      AppStrings.instCourseSelectionHeading,
                    ),
                    AppSpacing.v20,
                    _buildCourseSelectionSection(),
                    AppSpacing.v32,
                    _buildSectionHeader(
                      Icons.note_alt_rounded,
                      AppStrings.instInteractionNotesHeading,
                    ),
                    AppSpacing.v20,
                    _buildInteractionNotesSection(),
                    AppSpacing.v40,
                    Obx(
                      () => AppButton(
                        label: AppStrings.instSaveLeadBtn,
                        isLoading: controller.isLoading.value,
                        onPressed: () => controller.saveLead(),
                      ),
                    ),
                    AppSpacing.v24,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBrand, size: 20),
        AppSpacing.h12,
        Text(
          title,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => AppInputField(
            label: AppStrings.instFullNameLabel,
            hint: AppStrings.instFullNameHint,
            controller: controller.nameController,
            errorText:
                controller.triedToSave.value &&
                    controller.nameController.text.isEmpty
                ? 'Name is required'
                : null,
          ),
        ),
        AppSpacing.v24,
        AppInputField(
          label: AppStrings.instEmailAddressLabel,
          hint: AppStrings.instEmailAddressHint,
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instPhoneNumberLabelAlt,
            hint: AppStrings.instPhoneNumberHint,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText:
                controller.triedToSave.value &&
                    controller.phoneController.text.isEmpty
                ? 'Phone is required'
                : null,
          ),
        ),
        AppSpacing.v24,
        AppInputField(
          label: AppStrings.instAddressLabel,
          hint: AppStrings.instAddressHint,
          controller: controller.addressController,
          maxLines: 3,
        ),
        AppSpacing.v24,
        AppInputField(
          label: AppStrings.instReferenceLabel,
          hint: AppStrings.instReferenceHint,
          controller: controller.referenceController,
        ),
      ],
    );
  }

  Widget _buildCourseSelectionSection() {
    return Obx(
      () => AppInputField(
        label: AppStrings.instCourseSelectionLabel,
        hint: AppStrings.instCourseSelectionHint,
        controller: controller.courseController,
        errorText:
            controller.triedToSave.value &&
                controller.courseController.text.isEmpty
            ? 'Course selection is required'
            : null,
      ),
    );
  }

  Widget _buildInteractionNotesSection() {
    return AppInputField(
      label: AppStrings.instInteractionNotesLabel,
      hint: AppStrings.instInteractionNotesHint,
      controller: controller.notesController,
      maxLines: 5,
    );
  }
}
