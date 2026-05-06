import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/notes_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/shared/widgets/common_state_widget.dart';
import 'package:fee_easy/data/models/note_model.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesListScreen extends GetView<NotesController> {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => InstituteAppBar(
                title: controller.isBookmarkView.value
                    ? AppStrings.instBookmarkedNotes
                    : AppStrings.instNotesManagementTitle,
                actions: [
                  IconButton(
                    onPressed: () => controller.toggleBookmarkView(),
                    icon: Icon(
                      controller.isBookmarkView.value
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.x24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.v16,
                    _buildSearchField(),
                    AppSpacing.v20,
                    Expanded(
                      child: Obx(() {
                        return CommonStateWidget(
                          isLoading: controller.isLoading.value,
                          isEmpty: controller.filteredNotes.isEmpty,
                          emptyTitle: 'No Notes Found',
                          emptySubtitle: 'Start creating notes to keep track of important information.',
                          emptyIcon: Icons.note_alt_outlined,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: controller.filteredNotes.length,
                            separatorBuilder: (_, __) => AppSpacing.v16,
                            itemBuilder: (context, index) {
                              final note = controller.filteredNotes[index];
                              return _buildNoteCard(note);
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.prepareForAdd();
          Get.toNamed(AppRoutes.instituteAddEditNote);
        },
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        style: AppTextStyles.lexend(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: AppStrings.instSearchNotesHint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.blueSapphire,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.blueSapphire,
            size: AppSpacing.s24,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return GestureDetector(
      onTap: () {
        controller.prepareForEdit(note);
        Get.toNamed(AppRoutes.instituteAddEditNote);
      },
      child: Container(
        padding: AppSpacing.all20,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: AppTextStyles.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (note.tag != null && note.tag!.isNotEmpty) ...[
                        AppSpacing.v8,
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrandLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            note.tag!,
                            style: AppTextStyles.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBrand,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.toggleBookmark(note),
                  child: Icon(
                    note.isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: AppColors.primaryBrand,
                    size: 20,
                  ),
                ),
              ],
            ),
            AppSpacing.v8,
            Text(
              note.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.lexend(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            AppSpacing.v16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.createdAt,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
                GestureDetector(
                  onTap: () => _showDeleteConfirmation(note),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Note note) {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.instDeleteNoteTitle),
        content: const Text(AppStrings.instDeleteNoteConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.instCancelBtn),
          ),
          TextButton(
            onPressed: () {
              controller.deleteNote(note.id);
              Get.back();
            },
            child: const Text(
              AppStrings.instDeleteConfirmBtn,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
