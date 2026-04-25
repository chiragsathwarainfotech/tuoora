import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/resources_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BatchResourcesScreen extends StatelessWidget {
  const BatchResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BatchModel batch = Get.arguments;
    final controller = Get.put(ResourcesController(batch), tag: batch.id);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.instBatchResourcesTitle,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: AppSpacing.all24,
                  itemCount: controller.resources.length,
                  itemBuilder: (context, index) =>
                      _buildResourceItem(controller.resources[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadDialog(context, controller),
        backgroundColor: AppColors.instPrimaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildResourceItem(ResourceModel resource) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.instituteResourceDetail, arguments: resource),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.all12,
              decoration: BoxDecoration(
                color: _getResourceColor(resource.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getResourceIcon(resource.type),
                color: _getResourceColor(resource.type),
                size: 24,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.subject,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    resource.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  AppSpacing.v8,
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                      AppSpacing.h4,
                      Text(
                        DateFormat('MMM dd, yyyy').format(resource.uploadedAt),
                        style: AppTextStyles.lexend(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog(BuildContext context, ResourcesController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: AppSpacing.all24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.instUploadContentHeader,
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v24,
              _buildDialogField(
                AppStrings.instResourceSubjectLabel,
                controller.subjectController,
                'e.g., Physics Notes',
              ),
              AppSpacing.v16,
              _buildDialogField(
                AppStrings.instResourceDescriptionLabel,
                controller.descriptionController,
                'e.g., Chapter 1 derivation',
                maxLines: 3,
              ),
              AppSpacing.v24,
              _buildAttachmentButton(controller),
              AppSpacing.v32,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        AppStrings.instCancelBtn,
                        style: AppTextStyles.manrope(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.h16,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.uploadResource(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.instPrimaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.instUploadBtn,
                        style: AppTextStyles.manrope(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogField(
    String label,
    TextEditingController textController,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: textController,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.manrope(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: AppSpacing.all16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentButton(ResourcesController controller) {
    return Obx(() {
      final fileName = controller.selectedFileName.value;
      return GestureDetector(
        onTap: () {
          // Mocking file selection
          controller.selectedFileName.value = 'resource_file.pdf';
          controller.selectedType.value = ResourceType.document;
        },
        child: Container(
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD0D5DD),
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.attach_file_rounded,
                color: AppColors.instPrimaryBlue,
              ),
              AppSpacing.h12,
              Expanded(
                child: Text(
                  fileName.isEmpty
                      ? AppStrings.instAttachFileHint
                      : fileName,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: fileName.isEmpty
                        ? FontWeight.w500
                        : FontWeight.w700,
                    color: fileName.isEmpty
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _getResourceIcon(ResourceType type) {
    switch (type) {
      case ResourceType.image:
        return Icons.image_outlined;
      case ResourceType.video:
        return Icons.video_library_outlined;
      case ResourceType.document:
        return Icons.description_outlined;
    }
  }

  Color _getResourceColor(ResourceType type) {
    switch (type) {
      case ResourceType.image:
        return Colors.purple;
      case ResourceType.video:
        return Colors.orange;
      case ResourceType.document:
        return AppColors.instPrimaryBlue;
    }
  }
}
