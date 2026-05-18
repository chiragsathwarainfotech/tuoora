import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/presentation/institute/controllers/notes_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditNoteScreen extends GetView<NotesController> {
  const AddEditNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => InstituteAppBar(
                title: controller.editingNoteId.value != null
                    ? AppStrings.instEditNoteTitle
                    : AppStrings.instAddNoteTitle,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(children: [_buildFormCard()]),
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => AppInputField(
            label: AppStrings.instNoteTitleLabel,
            hint: AppStrings.instNoteTitleHint,
            controller: controller.titleController,
            errorText: controller.titleError.value,
            textStyle: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        AppSpacing.v24,
        _buildCategorySelection(),
        AppSpacing.v24,
        Obx(
          () => AppInputField(
            label: AppStrings.instNoteContentLabel,
            hint: AppStrings.instNoteContentHint,
            controller: controller.contentController,
            maxLines: 12,
            errorText: controller.contentError.value,
            textStyle: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
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
        AppSpacing.v12,
        Obx(() {
          if (controller.isCategoriesLoading.value &&
              controller.noteCategories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...controller.noteCategories.map((cat) {
                      final isSelected =
                          controller.selectedCategoryName.value == cat.name;
                      final Color catColor = Color(
                        int.parse(cat.color.replaceAll('#', '0xFF')),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedCategoryName.value = cat.name;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? catColor
                                  : AppColors.paleSilver.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? catColor
                                    : AppColors.borderGrey.withValues(
                                        alpha: 0.3,
                                      ),
                              ),
                            ),
                            child: Text(
                              cat.name,
                              style: AppTextStyles.lexend(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
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
          );
        }),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: AppSpacing.all24,
      child: Obx(
        () => AppButton(
          label: AppStrings.instSaveNoteBtn,
          onPressed: () => controller.saveNote(),
          isLoading: controller.isLoading.value,
          borderRadius: 16,
          fontSize: 16,
        ),
      ),
    );
  }
}
