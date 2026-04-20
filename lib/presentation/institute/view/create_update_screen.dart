import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:fee_easy/presentation/institute/controllers/updates_controller.dart';
import 'package:get/get.dart';

class CreateUpdateScreen extends GetView<UpdatesController> {
  const CreateUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.v16,
                    _buildCategorySelection(),
                    AppSpacing.v32,
                    _buildTargetAudienceCard(),
                    AppSpacing.v32,
                    _buildInputField(
                      'Subject',
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
                    _buildAttachmentSection(),
                    AppSpacing.v32,
                    _buildBroadcastChannels(),
                    AppSpacing.v40,
                  ],
                ),
              ),
            ),
            _buildBroadcastButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    final categories = ['Fee Reminder', 'Event', 'Holiday', 'Notice'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: categories.map((cat) {
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
                      ? const Color(0xFF003D82)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cat,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTargetAudienceCard() {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
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
                'Target Audience',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF003D82),
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
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedAudience.value,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textPrimary,
                  ),
                  items: ['All Students', 'Specific Batch', 'Specific Grade']
                      .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: AppTextStyles.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        );
                      })
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedAudience.value = val;
                  },
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.selectedAudience.value == 'Specific Grade') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.v16,
                  const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                  AppSpacing.v16,
                  Text(
                    'Select Grade',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.v12,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedGrade.value,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textPrimary,
                        ),
                        items: controller.availableGrades.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectedGrade.value = val;
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (controller.selectedAudience.value == 'Specific Batch') {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.v16,
                  const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                  AppSpacing.v16,
                  Text(
                    'Select Batch',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.v12,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedBatch.value,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textPrimary,
                        ),
                        items: controller.availableBatches.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectedBatch.value = val;
                        },
                      ),
                    ),
                  ),
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
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
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
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: const Color(0xFFE5E7EB),
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

  Widget _buildAttachmentSection() {
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
              border: Border.all(color: const Color(0xFF94A3B8), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  color: Color(0xFF003082),
                  size: 20,
                ),
                AppSpacing.h12,
                Text(
                  'Add Attachment (Image/PDF)',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF003082),
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
                final path = entry.value;
                final fileName = path.split('/').last;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        color: const Color(0xFF003082),
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

  Widget _buildBroadcastChannels() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Broadcast Channels',
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.v16,
        Obx(
          () => _buildChannelItem(
            icon: Icons.notifications_rounded,
            title: 'App Notification',
            subtitle: 'Push to student devices',
            value: controller.appNotificationEnabled.value,
            onChanged: (val) => controller.appNotificationEnabled.value = val,
          ),
        ),
        AppSpacing.v16,
        Obx(
          () => _buildChannelItem(
            icon: Icons.chat_bubble_rounded,
            title: 'WhatsApp Message',
            subtitle: 'Direct to registered number',
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
        color: Colors.white,
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
            child: Icon(icon, color: const Color(0xFF1E40AF), size: 20),
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
            activeThumbColor: const Color(0xFF003082),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastButton() {
    return Container(
      padding: AppSpacing.all24,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.broadcastUpdate(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0051B3),
          padding: AppSpacing.y20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            AppSpacing.h12,
            Text(
              'Broadcast Update',
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
