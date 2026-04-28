import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_label.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddEditBatchScreen extends GetView<BatchController> {
  const AddEditBatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => InstituteAppBar(
                title: controller.isEditMode.value
                    ? AppStrings.instEditBatchTitle
                    : AppStrings.instAddBatchTitle,
                isRoot: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InstituteTextField(
                      label: AppStrings.instBatchNameLabelAlt,
                      controller: controller.batchNameController,
                      hint: AppStrings.instBatchNameHint,
                    ),
                    AppSpacing.v24,
                    InstituteTextField(
                      label: AppStrings.instBatchSubjectLabel,
                      controller: controller.subjectController,
                      hint: AppStrings.instBatchSubjectHint,
                    ),
                    AppSpacing.v24,
                    InstituteTextField(
                      label: AppStrings.instBatchDescLabel,
                      controller: controller.descriptionController,
                      hint: AppStrings.instBatchDescHint,
                      maxLines: 3,
                    ),
                    AppSpacing.v24,
                    InstituteTextField(
                      label: AppStrings.instBatchFeeLabelAlt,
                      controller: controller.batchFeeController,
                      hint: AppStrings.instBatchFeeHint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    AppSpacing.v32,
                    _buildSectionHeader(
                      Icons.access_time_filled_rounded,
                      AppStrings.instScheduleSettings,
                    ),
                    AppSpacing.v20,
                    _buildScheduleCard(context),
                    AppSpacing.v24,
                    const InstituteLabel(AppStrings.instActiveDaysLabel),
                    AppSpacing.v16,
                    _buildDaysSelection(),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(child: _buildSaveButton(context)),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.deepBlue, size: 20),
        AppSpacing.h12,
        Text(
          title,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.deepBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context) {
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
          Text(
            AppStrings.instTimeSlot,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v16,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_filled,
                  color: AppColors.deepBlue,
                  size: 24,
                ),
                AppSpacing.h16,
                Expanded(
                  child: Obx(
                    () => Text(
                      '${controller.startTime.value.format(context)} — ${controller.endTime.value.format(context)}',
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showTimeRangePicker(context),
                  child: Text(
                    AppStrings.instChangeBtn,
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTimeRangePicker(BuildContext context) async {
    await controller.selectStartTime(context);
    if (context.mounted) {
      await controller.selectEndTime(context);
    }
  }

  Widget _buildDaysSelection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.allDays.map((day) {
        return Obx(() {
          final isSelected = controller.selectedDays.contains(day);
          return GestureDetector(
            onTap: () => controller.toggleDay(day),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF003D82) : AppColors.borderGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                day,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: AppSpacing.all24,
      width: double.infinity,
      child: AppButton(
        label: AppStrings.instSaveBatchBtn,
        icon: Icons.save_rounded,
        onPressed: () {
          FocusScope.of(context).unfocus();
          controller.saveBatch(context);
        },
      ),
    );
  }
}
