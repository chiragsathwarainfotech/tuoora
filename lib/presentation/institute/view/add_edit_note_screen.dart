import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/notes_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
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
                    ? controller.titleController.text.isEmpty
                          ? AppStrings.instEditNoteTitle
                          : controller.titleController.text
                    : AppStrings.instAddNoteTitle,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: AppStrings.instNoteTitleLabel,
                      hint: AppStrings.instNoteTitleHint,
                      controller: controller.titleController,
                      style: AppTextStyles.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v24,
                    _buildTagSelection(),
                    AppSpacing.v24,
                    _buildInputField(
                      label: AppStrings.instNoteContentLabel,
                      hint: AppStrings.instNoteContentHint,
                      controller: controller.contentController,
                      maxLines: 12,
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildTagSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Tag',
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v12,
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...controller.availableTags.map((tag) {
                  final isSelected = controller.selectedTag.value == tag;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.selectedTag.value = null;
                        } else {
                          controller.selectedTag.value = tag;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryBrand
                              : AppColors.paleSilver.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
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
                GestureDetector(
                  onTap: () => _showAddTagDialog(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.borderGrey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTagDialog() {
    final tagController = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add New Tag',
          style: AppTextStyles.manrope(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: tagController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter tag name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newTag = tagController.text.trim().toUpperCase();
              if (newTag.isNotEmpty &&
                  !controller.availableTags.contains(newTag)) {
                controller.availableTags.add(newTag);
                controller.selectedTag.value = newTag;
              }
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextStyle? style,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        AppSpacing.v8,
        Container(
          padding: AppSpacing.x16,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.borderGrey.withValues(alpha: 0.5),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: style,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.lexend(
                fontSize: 14,
                color: AppColors.textTertiary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
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
