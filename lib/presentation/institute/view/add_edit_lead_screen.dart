import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
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
                    
                    Obx(() {
                      if (controller.editingLeadId.value == null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpacing.v32,
                            _buildSectionHeader(
                              Icons.note_alt_rounded,
                              'Initial Interaction Note',
                            ),
                            AppSpacing.v20,
                            _buildInteractionNoteSection(),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    
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
            errorText: controller.triedToSave.value
                ? controller.nameError.value
                : null,
          ),
        ),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instEmailAddressLabel,
            hint: AppStrings.instEmailAddressHint,
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
            label: AppStrings.instPhoneNumberLabelAlt,
            hint: AppStrings.instPhoneNumberHint,
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
      ],
    );
  }

  Widget _buildCourseSelectionSection() {
    return Obx(
      () => AppInputField(
        label: AppStrings.instCourseSelectionLabel,
        hint: AppStrings.instCourseSelectionHint,
        controller: controller.courseController,
        errorText: controller.triedToSave.value
            ? controller.courseError.value
            : null,
      ),
    );
  }

  Widget _buildInteractionNoteSection() {
    return Column(
      children: [
        Obx(
          () => AppInputField(
            label: 'NOTE TITLE',
            hint: 'e.g., Initial Inquiry',
            controller: controller.noteTitleController,
            errorText: controller.triedToSave.value
                ? controller.noteTitleError.value
                : null,
          ),
        ),
        AppSpacing.v20,
        Obx(
          () => AppInputField(
            label: 'NOTE DESCRIPTION',
            hint: 'Add more details about the interaction...',
            controller: controller.notesController,
            maxLines: 5,
            errorText: controller.triedToSave.value
                ? controller.noteError.value
                : null,
          ),
        ),
      ],
    );
  }
}

