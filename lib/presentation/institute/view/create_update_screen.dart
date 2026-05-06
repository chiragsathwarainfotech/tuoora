import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/enums/update_enums.dart';
import 'package:fee_easy/data/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/presentation/institute/controllers/updates_controller.dart';
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
                const InstituteAppBar(title: 'Create Update', isRoot: false),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.all24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Category',
                          style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandAppBarColor,
                          ),
                        ),
                        AppSpacing.v16,
                        _buildCategorySelection(controller),
                        AppSpacing.v32,
                        _buildTargetAudienceCard(controller),
                        AppSpacing.v32,
                        _buildInputField(
                          'Topic',
                          'e.g., Q3 Fee Installment Reminder',
                          controller.subjectController,
                        ),
                        AppSpacing.v32,
                        _buildInputField(
                          'Message Content',
                          'Write your message here...',
                          controller.messageController,
                          maxLines: 6,
                        ),
                        AppSpacing.v32,
                        _buildAttachmentSection(controller),
                        AppSpacing.v32,
                        _buildBroadcastChannels(controller),
                        AppSpacing.v40,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: AppSpacing.all24,
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
              child: const Center(
                child: CommonLoading(),
              ),
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
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBrand
                      : AppColors.paleSilver,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cat.name,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              Text(
                'Recipient',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandAppBarColor,
                ),
              ),
              const Icon(
                Icons.people_outline_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
          AppSpacing.v16,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.paleSilver,
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
                        style: AppTextStyles.manrope(
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
                    'Target Audience',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brandAppBarColor,
                    ),
                  ),
                  AppSpacing.v12,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.paleSilver,
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
                              style: AppTextStyles.manrope(
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
                      'Select Batch',
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandAppBarColor,
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
                            'No batches found',
                            style: AppTextStyles.manrope(
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
                          color: AppColors.paleSilver,
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
                            items: controller.availableBatches.map((
                              Batch value,
                            ) {
                              return DropdownMenuItem<Batch>(
                                value: value,
                                child: Text(
                                  '${value.name} • ${value.subject}',
                                  style: AppTextStyles.manrope(
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
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController textController, {
    int maxLines = 1,
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
        AppSpacing.v12,
        TextField(
          controller: textController,
          maxLines: maxLines,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.blueSapphire,
            ),
            filled: true,
            fillColor: AppColors.paleSilver,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: AppSpacing.all16,
          ),
        ),
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
                  'Add Attachment (Image/PDF)',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
                          style: AppTextStyles.manrope(
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

  Widget _buildBroadcastChannels(UpdatesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Broadcast Channels',
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v16,
        Obx(
          () => _buildChannelItem(
            icon: Icons.notifications_rounded,
            title: 'App Notification',
            subtitle: 'Push to devices',
            value: controller.appNotificationEnabled.value,
            onChanged: (val) => controller.appNotificationEnabled.value = val,
          ),
        ),
        AppSpacing.v16,
        Obx(
          () => _buildChannelItem(
            icon: Icons.chat_bubble_rounded,
            title: 'WhatsApp Message',
            subtitle: 'Direct message',
            value: controller.whatsappEnabled.value,
            onChanged: (val) => controller.whatsappEnabled.value = val,
          ),
        ),
      ],
    );
  }

  Widget _buildChannelItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBrand, size: 20),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryBrand,
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastButton(UpdatesController controller) {
    return AppButton(
      label: 'Broadcast Update',
      icon: Icons.send_rounded,
      onPressed: () => controller.broadcastUpdate(),
    );
  }
}
