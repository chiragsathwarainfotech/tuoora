import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/input_styles.dart';
import 'package:tuoora/presentation/institute/controllers/batch_controller.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/institute_label.dart';
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
                    Obx(
                      () => AppInputField(
                        label: AppStrings.instBatchNameLabelAlt,
                        controller: controller.batchNameController,
                        hint: AppStrings.instBatchNameHint,
                        errorText: controller.batchNameError.value,
                      ),
                    ),
                    AppSpacing.v24,
                    Obx(
                      () => AppInputField(
                        label: AppStrings.instBatchSubjectLabel,
                        controller: controller.subjectController,
                        hint: AppStrings.instBatchSubjectHint,
                        errorText: controller.subjectError.value,
                      ),
                    ),
                    AppSpacing.v24,
                    AppInputField(
                      label: AppStrings.instBatchDescLabel,
                      controller: controller.descriptionController,
                      hint: AppStrings.instBatchDescHint,
                      maxLines: 3,
                    ),
                    AppSpacing.v24,
                    Obx(
                      () => AppInputField(
                        label: AppStrings.instBatchFeeLabelAlt,
                        controller: controller.batchFeeController,
                        hint: AppStrings.instBatchFeeHint,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        errorText: controller.feeError.value,
                      ),
                    ),
                    AppSpacing.v24,
                    const InstituteLabel(AppStrings.instTimeSlot),
                    _buildTimeSlotField(context),
                    AppSpacing.v24,
                    const InstituteLabel(AppStrings.instActiveDaysLabel),
                    Obx(() {
                      if (controller.daysError.value != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            controller.daysError.value!,
                            style: AppTextStyles.outfit(
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    AppSpacing.v12,
                    _buildDaysSelection(),
                    AppSpacing.v24,
                    AppInputField(
                      label: AppStrings.instBatchClassroomLabel,
                      controller: controller.classroomController,
                      hint: AppStrings.instBatchClassroomHint,
                    ),
                    AppSpacing.v32,
                    _buildSaveButton(context),
                    AppSpacing.v24,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotField(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTimeRangePicker(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        // minHeight matches the rendered height of a single-line AppInputField
        // (Material's default ~48 dp touch target), so the time slot sits at
        // the exact same height as Batch Description / Batch Fee above it.
        constraints: const BoxConstraints(minHeight: 48),
        padding: InputStyles.contentPadding,
        decoration: BoxDecoration(
          color: AppColors.paleSilver,
          borderRadius: BorderRadius.circular(InputStyles.borderRadius),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_filled,
              color: AppColors.blueSapphire,
              size: AppSpacing.s20,
            ),
            AppSpacing.h12,
            Expanded(
              child: Obx(
                () => Text(
                  '${controller.startTime.value.format(context)} — ${controller.endTime.value.format(context)}',
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Text(
              AppStrings.instChangeBtn,
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBrand,
              ),
            ),
          ],
        ),
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
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBrand
                    : AppColors.paleSilver,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Text(
                day,
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Obx(
      () => AppButton(
        label: AppStrings.instSaveBatchBtn,
        icon: Icons.save_rounded,
        isLoading: controller.isLoading.value,
        onPressed: () {
          FocusScope.of(context).unfocus();
          controller.saveBatch(context);
        },
      ),
    );
  }
}
