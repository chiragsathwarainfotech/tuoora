import 'dart:io';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentScreen extends GetView<InstituteStudentController> {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Add New Student'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainFormCard(context),
                    AppSpacing.v16,
                    Obx(() => controller.selectedBatchId.value.isEmpty 
                      ? const SizedBox.shrink() 
                      : _buildFeeStructureCard()),
                    AppSpacing.v24,
                    _buildActionButtons(),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFormCard(BuildContext context) {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.showImagePickerSourceSheet(context),
                child: Stack(
                  children: [
                    Obx(
                      () => Container(
                        width: AppSpacing.s80,
                        height: AppSpacing.s80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F5F6),
                          borderRadius: BorderRadius.circular(AppSpacing.s16),
                          image: controller.selectedImagePath.value != null
                              ? DecorationImage(
                                  image: FileImage(
                                    File(controller.selectedImagePath.value!),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: NetworkImage(
                                    'https://i.pravatar.cc/150?img=11',
                                  ),
                                  opacity: 0.5,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.instDarkBtnBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.instStudentPhotoLabel,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      AppStrings.instStudentPhotoHint,
                      style: AppTextStyles.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v32,
          _buildInputField(
            label: AppStrings.instStudentNameLabel,
            hint: AppStrings.instNameHint,
            icon: Icons.person,
            controller: controller.nameController,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instStudentEmailLabel,
            hint: 'student@example.com',
            icon: Icons.email_rounded,
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instStudentDobLabel,
            hint: 'DD/MM/YYYY',
            icon: Icons.calendar_today_rounded,
            controller: controller.dobController,
            readOnly: true,
            onTap: () => controller.selectDOB(context),
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instGuardianNameLabel,
            hint: AppStrings.instGuardianHint,
            icon: Icons.group,
            controller: controller.parentNameController,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instPhoneLabel,
            hint: AppStrings.instPhoneHint,
            icon: Icons.phone,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
          ),
          AppSpacing.v20,
          Obx(
            () => _buildDropdownField(
              label: AppStrings.instGradeLabel,
              hint: controller.selectedGrade.value,
              icon: Icons.school,
              onTap: () => controller.showGradeSelection(context, [
                '9th Std',
                '10th Std',
                '11th Std',
                '12th Std',
              ]),
            ),
          ),
          AppSpacing.v32,
          Obx(() {
            final batchController = Get.find<BatchController>();
            final selectedBatch = batchController.batchesList.firstWhereOrNull(
              (b) => b.id == controller.selectedBatchId.value,
            );
            return _buildDropdownField(
              label: AppStrings.instSelectBatchLabel,
              hint: selectedBatch?.title ?? 'Select a Batch',
              icon: Icons.access_time_filled_rounded,
              onTap: () {
                Get.bottomSheet(
                  Container(
                    padding: AppSpacing.all24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Select Batch',
                          style: AppTextStyles.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.v16,
                        ...batchController.batchesList.map(
                          (batch) => ListTile(
                            title: Text(
                              batch.title,
                              style: AppTextStyles.lexend(fontSize: 16),
                            ),
                            subtitle: Text(
                              batch.time,
                              style: AppTextStyles.lexend(
                                fontSize: 12,
                                color: AppColors.textDarkGrey,
                              ),
                            ),
                            trailing: Text(
                              '₹${batch.baseFee.toStringAsFixed(0)}',
                              style: AppTextStyles.manrope(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              controller.setBatchById(batch.id, batch.baseFee);
                              Get.back();
                            },
                          ),
                        ),
                        AppSpacing.v24,
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDarkGrey,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputSolidGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.lexend(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.textTertiary,
                size: AppSpacing.s20,
              ),
              border: InputBorder.none,
              contentPadding: AppSpacing.all16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDarkGrey,
            ),
          ),
          AppSpacing.v8,
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputSolidGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: AppSpacing.all16,
            child: Row(
              children: [
                Icon(icon, color: AppColors.textTertiary, size: AppSpacing.s20),
                AppSpacing.h12,
                Expanded(
                  child: Text(
                    hint,
                    style: AppTextStyles.lexend(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textTertiary,
                  size: AppSpacing.s20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeStructureCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.instFeeStructureLabel,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v16,
          Obx(
            () => Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(AppSpacing.s12),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleFeeStructure(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.instMonthlyFeeLabel,
                                style: AppTextStyles.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              AppSpacing.v4,
                              Text(
                                controller.totalMonthlyFee.value,
                                style: AppTextStyles.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.instDarkBtnBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          controller.isFeeStructureExpanded.value
                              ? 'Close'
                              : AppStrings.instEditStructureBtn,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.instDarkBtnBlue,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.isFeeStructureExpanded.value) ...[
                    AppSpacing.v16,
                    const Divider(),
                    AppSpacing.v12,
                    ...controller.feeBreakdown.entries.map(
                      (entry) => Padding(
                        padding: AppSpacing.bottom12,
                        child: _buildEditableFeeRow(entry.key, entry.value),
                      ),
                    ),
                    AppSpacing.v8,
                    GestureDetector(
                      onTap: () => controller.applyFeeChanges(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.instDarkBtnBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Save Fee Changes',
                            style: AppTextStyles.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFeeRow(String label, RxString amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: TextField(
              controller: TextEditingController(text: amount.value),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              onChanged: (val) => amount.value = val,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.instDarkBtnBlue,
              ),
              decoration: const InputDecoration(
                prefixText: '₹',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Obx(
          () => GestureDetector(
            onTap: controller.isFormValid.value 
              ? () => controller.saveStudent() 
              : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
              decoration: BoxDecoration(
                color: controller.isFormValid.value 
                  ? AppColors.instDarkBtnBlue 
                  : AppColors.textMuted,
                borderRadius: BorderRadius.circular(AppSpacing.s12),
                boxShadow: controller.isFormValid.value ? [
                  BoxShadow(
                    color: AppColors.instDarkBtnBlue.withValues(alpha: 0.2),
                    blurRadius: AppSpacing.s16,
                    offset: const Offset(0, AppSpacing.s8),
                  ),
                ] : [],
              ),
              child: Center(
                child: Text(
                  AppStrings.instConfirmBtn,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        AppSpacing.v16,
        GestureDetector(
          onTap: () => controller.discardChanges(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
              border: Border.all(color: AppColors.borderGrey, width: 1.5),
            ),
            child: Center(
              child: Text(
                AppStrings.instDiscardBtn,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.instDarkBtnBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
