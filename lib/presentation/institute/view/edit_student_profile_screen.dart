import 'dart:io';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditStudentProfileScreen extends GetView<InstituteStudentController> {
  const EditStudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Edit Profile'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainFormCard(context),
                    AppSpacing.v16,
                    _buildFeeStructureCard(),
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
          // Identity Section
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
                          color: const Color(0xFF5B98A6),
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
                                    'https://i.pravatar.cc/150?u=student_arjun',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
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
                      'Update Photo',
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      'Tap to change the student profile picture',
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

          // Input Fields
          _buildInputField(
            label: AppStrings.instStudentNameLabel,
            hint: 'Arjun Malhotra',
            icon: Icons.person,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instGuardianNameLabel,
            hint: 'Mr. Rajesh Malhotra',
            icon: Icons.group,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instPhoneLabel,
            hint: '+91 98765-43210',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
          AppSpacing.v20,
          Obx(
            () => _buildDropdownField(
              label: AppStrings.instGradeLabel,
              hint: controller.selectedGrade.value,
              icon: Icons.school,
              onTap: () => controller.showGradeSelection(context, [
                'Grade 9-A',
                'Grade 10-A',
                'Grade 11-A',
                'Grade 12-A',
              ]),
            ),
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instResAddressLabel,
            hint: '42, Emerald Heights, Sector 18, Gurgaon...',
            icon: Icons.location_on_rounded,
          ),
          AppSpacing.v32,

          // Batch Assignment
          Text(
            AppStrings.instBatchAssignmentLabel,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDarkGrey,
            ),
          ),
          AppSpacing.v12,
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setBatch(0),
                    child: _buildBatchCard(
                      title: 'Science Stream',
                      time: '08:00 AM - 10:00 AM',
                      isSelected: controller.selectedBatchIndex.value == 0,
                    ),
                  ),
                ),
                AppSpacing.h12,
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.setBatch(1),
                    child: _buildBatchCard(
                      title: 'Evening Batch',
                      time: '04:00 PM - 06:00 PM',
                      isSelected: controller.selectedBatchIndex.value == 1,
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

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
            controller: TextEditingController(text: hint),
            keyboardType: keyboardType,
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
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

  Widget _buildBatchCard({
    required String title,
    required String time,
    required bool isSelected,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.instLightBlueBg : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.s8),
        border: Border.all(
          color: isSelected ? AppColors.instAccentBlue : AppColors.borderGrey,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColors.instAccentBlue
                  : AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.lexend(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: isSelected
                  ? AppColors.instAccentBlue.withValues(alpha: 0.7)
                  : AppColors.textTertiary,
              height: 1.4,
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
            'Current Fee Structure',
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
                                'Monthly Tuition Fee',
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
                              : 'Change',
                          style: AppTextStyles.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.instDarkBtnBlue,
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
        GestureDetector(
          onTap: () => controller.saveStudent(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
            decoration: BoxDecoration(
              color: AppColors.instDarkBtnBlue,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.instDarkBtnBlue.withValues(alpha: 0.2),
                  blurRadius: AppSpacing.s16,
                  offset: const Offset(0, AppSpacing.s8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Save Profile Changes',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
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
                'Discard Changes',
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
