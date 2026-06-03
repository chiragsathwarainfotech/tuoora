import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/data/models/batch_model.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/presentation/institute/controllers/updates_controller.dart';
import 'package:get/get.dart';

class CreateUpdateScreen extends GetView<UpdatesController> {
  const CreateUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: SafeArea(
            child: Column(
              children: [
                const InstituteAppBar(title: AppStrings.createUpdate, isRoot: false),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.hintSelectCategory,
                          style: AppTextStyles.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fieldLabel,
                          ),
                        ),
                        AppSpacing.v16,
                        _buildCategorySelection(controller),
                        AppSpacing.v32,
                        _buildTargetAudienceCard(controller),
                        AppSpacing.v32,
                        Obx(
                          () => AppInputField(
                            label: AppStrings.topic,
                            hint: AppStrings.enterTopic,
                            controller: controller.subjectController,
                            labelSpacing: 12.0,
                            errorText: controller.triedToSave.value
                                ? controller.subjectError.value
                                : null,
                            textStyle: AppTextStyles.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        AppSpacing.v32,
                        Obx(
                          () => AppInputField(
                            label: AppStrings.messageContent,
                            hint: AppStrings.writeYourMessageHere,
                            controller: controller.messageController,
                            maxLines: 6,
                            labelSpacing: 12.0,
                            errorText: controller.triedToSave.value
                                ? controller.messageError.value
                                : null,
                            textStyle: AppTextStyles.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        AppSpacing.v32,
                        _buildAttachmentSection(controller),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: AppSpacing.x16,
                  child: _buildBroadcastButton(controller),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.isCreating.value) {
            return Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(child: CommonLoading()),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildCategorySelection(UpdatesController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: UpdateCategory.values.map((cat) {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.selectedCategory.value = cat,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBrand
                      : AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Text(
                  cat.name,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTargetAudienceCard(UpdatesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.recipient,
          style: AppTextStyles.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
          ),
        ),
        AppSpacing.v16,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<UpdateRecipient>(
                value: controller.selectedRecipient.value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textPrimary,
                ),
                items: UpdateRecipient.values.map((UpdateRecipient value) {
                  return DropdownMenuItem<UpdateRecipient>(
                    value: value,
                    child: Text(
                      value.name.capitalizeFirst!,
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => val != null
                    ? controller.selectedRecipient.value = val
                    : null,
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.selectedRecipient.value != UpdateRecipient.parents) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.v24,
                Text(
                  AppStrings.targetAudience,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.fieldLabel,
                  ),
                ),
                AppSpacing.v12,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.fieldBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<UpdateTargetType>(
                      value: controller.selectedAudience.value,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textPrimary,
                      ),
                      items: UpdateTargetType.values.map((
                        UpdateTargetType value,
                      ) {
                        String label = value == UpdateTargetType.all
                            ? 'All Students'
                            : 'Specific Batch';
                        return DropdownMenuItem<UpdateTargetType>(
                          value: value,
                          child: Text(
                            label,
                            style: AppTextStyles.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => val != null
                          ? controller.selectedAudience.value = val
                          : null,
                    ),
                  ),
                ),
                if (controller.selectedAudience.value ==
                    UpdateTargetType.batch) ...[
                  AppSpacing.v24,
                  Text(
                    AppStrings.selectBatch,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.fieldLabel,
                    ),
                  ),
                  AppSpacing.v12,
                  Obx(() {
                    if (controller.isLoadingBatches.value) {
                      return const CommonLoading(size: 24, strokeWidth: 2);
                    }
                    if (controller.availableBatches.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          AppStrings.noBatchesFound,
                          style: AppTextStyles.outfit(
                            fontSize: 14,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Batch>(
                          value: controller.selectedBatch.value,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textPrimary,
                          ),
                          items: controller.availableBatches.map((Batch value) {
                            return DropdownMenuItem<Batch>(
                              value: value,
                              child: Text(
                                '${value.name} • ${value.subject}',
                                style: AppTextStyles.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) => val != null
                              ? controller.selectedBatch.value = val
                              : null,
                        ),
                      ),
                    );
                  }),
                ],
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildAttachmentSection(UpdatesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.pickAttachments(),
          child: Container(
            width: double.infinity,
            padding: AppSpacing.y20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textMuted, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  color: AppColors.primaryBrand,
                  size: 20,
                ),
                AppSpacing.h12,
                Text(
                  AppStrings.addAttachmentImagePdf,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBrand,
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.attachments.isEmpty) return const SizedBox.shrink();
          return Column(
            children: [
              AppSpacing.v16,
              ...controller.attachments.asMap().entries.map((entry) {
                final index = entry.key;
                final fileName = entry.value.split('/').last;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        fileName.toLowerCase().endsWith('.pdf')
                            ? Icons.picture_as_pdf
                            : Icons.image,
                        size: 20,
                        color: AppColors.primaryBrand,
                      ),
                      AppSpacing.h12,
                      Expanded(
                        child: Text(
                          fileName,
                          style: AppTextStyles.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.removeAttachment(index),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildBroadcastButton(UpdatesController controller) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: AppButton(
        label: AppStrings.createUpdate,
        icon: Icons.send_rounded,
        onPressed: () => controller.broadcastUpdate(),
      ),
    );
  }
}
