import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/presentation/institute/controllers/leads_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/data/models/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeadDetailsScreen extends GetView<LeadsController> {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(() {
          final lead = controller.selectedLead.value;
          if (lead == null) {
            return const Center(child: Text('Lead not found'));
          }
          return Column(
            children: [
              const InstituteAppBar(title: AppStrings.instLeadDetailsTitle),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.x16.add(AppSpacing.y16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(lead),
                      AppSpacing.v24,
                      _buildDetailsSection(lead),
                      AppSpacing.v32,
                      _buildInteractionHistory(lead, context),
                    ],
                  ),
                ),
              ),
              _buildBottomAction(lead),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(Lead lead) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lead.fullName,
              style: AppTextStyles.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${AppStrings.instAppliedSuffix} ${dateFormat.format(lead.createdAt)}',
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection(Lead lead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFlatField('EMAIL', lead.email),
        _buildFlatField('PHONE', lead.phone),
        _buildFlatField(AppStrings.instAddressLabel, lead.address ?? ''),
        _buildFlatField(
          AppStrings.instReferenceLabel,
          lead.reference ?? '',
          isLast: true,
        ),
        _buildFlatField(
          AppStrings.instCourseSelectionLabel,
          lead.courseSelection ?? '',
        ),
      ],
    );
  }

  Widget _buildFlatField(String label, String value, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.v4,
              Text(
                value.isEmpty ? '—' : value,
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.6),
          ),
      ],
    );
  }

  Widget _buildInteractionHistory(Lead lead, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.history_rounded,
              color: AppColors.fieldLabel,
              size: 20,
            ),
            AppSpacing.h12,
            Text(
              AppStrings.instInteractionHistoryHeading,
              style: AppTextStyles.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _showAddNoteDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 14,
                      color: AppColors.primaryBrand,
                    ),
                    AppSpacing.h8,
                    Text(
                      'Add Note',
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        AppSpacing.v24,
        if (lead.notes.isNotEmpty)
          ...lead.notes.map((item) => _buildTimelineItem(item))
        else
          Container(
            padding: AppSpacing.all20,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('No interaction history available'),
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineItem(LeadNote item) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBrand,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primaryBrand.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Container(
              padding: AppSpacing.cardPadding,
              margin: AppSpacing.bottom10,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
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
                        item.title,
                        style: AppTextStyles.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(item.createdAt),
                        style: AppTextStyles.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v8,
                  Text(
                    item.note,
                    style: AppTextStyles.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(Lead lead) {
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
      child: AppButton(
        label: '${AppStrings.instCallBtn} ${lead.fullName.split(' ')[0]}',
        icon: Icons.phone,
        onPressed: () => controller.callLead(lead.phone),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    controller.noteTitleController.clear();
    controller.notesController.clear();
    controller.triedToSave.value = false;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s24,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: AppSpacing.all16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Interaction Note',
                    style: AppTextStyles.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textTertiary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              AppSpacing.v24,
              Obx(
                () => _buildDialogField(
                  label: 'Title',
                  hint: 'Enter lead title',
                  controller: controller.noteTitleController,
                  errorText: controller.noteTitleError.value,
                ),
              ),
              AppSpacing.v20,
              Obx(
                () => _buildDialogField(
                  label: 'Description',
                  hint: 'Enter description',
                  controller: controller.notesController,
                  maxLines: 4,
                  errorText: controller.noteError.value,
                ),
              ),
              AppSpacing.v32,
              Obx(
                () => AppButton(
                  label: 'Submit',
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.addLeadNote(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
            letterSpacing: 1.0,
          ),
        ),
        AppSpacing.v10,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.paleSilver,
            borderRadius: BorderRadius.circular(12),
            border: errorText != null
                ? Border.all(color: Colors.redAccent, width: 1.5)
                : null,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTextStyles.outfit(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.fieldLabel,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: AppTextStyles.outfit(
              fontSize: 11,
              color: Colors.redAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
