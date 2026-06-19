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
                padding: AppSpacing.screenPaddingTop,
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
            textStyle: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
            textStyle: AppTextStyles.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  // Static icon mapping for the hard-coded category names. If a new
  // category is ever added to [NotesController.noteCategoryNames] without
  // an entry here, it falls back to the bookmark icon.
  static const Map<String, IconData> _categoryIcons = {
    'Personal': Icons.person_outline_rounded,
    'Work': Icons.work_outline_rounded,
  };

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.labelCategory,
          style: AppTextStyles.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
          ),
        ),
        AppSpacing.v12,
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final name in NotesController.noteCategoryNames)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _categoryChip(name),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _addImageChip(),
                ],
              ),
              if (controller.categoryError.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    controller.categoryError.value!,
                    style: AppTextStyles.outfit(
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

  Widget _categoryChip(String name) {
    final isSelected = controller.selectedCategoryName.value == name;
    final icon = _categoryIcons[name] ?? Icons.bookmark_outline_rounded;
    return GestureDetector(
      onTap: () => controller.selectedCategoryName.value = name,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBrand
              : AppColors.fieldBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBrand
                : AppColors.borderGrey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addImageChip() {
    return GestureDetector(
      onTap: () => controller.showImagePickerOptions(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBrand,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.image_outlined,
              size: 16,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              controller.selectedImagePath.value != null
                  ? 'Image Added'
                  : 'Add Image',
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: controller.selectedImagePath.value != null
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: AppSpacing.all24,
        child: Obx(
          () => AppButton(
            label: controller.editingNoteId.value != null
                ? AppStrings.instEditNoteTitle
                : AppStrings.instSaveNoteBtn,
            onPressed: () => controller.saveNote(),
            isLoading: controller.isLoading.value,
            borderRadius: 16,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
