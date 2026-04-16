import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Add Student'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainFormCard(),
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

  Widget _buildMainFormCard() {
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
              Container(
                width: AppSpacing.s64,
                height: AppSpacing.s64,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B98A6), // Teal placeholder bg
                  borderRadius: BorderRadius.circular(AppSpacing.s12),
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.instStudentIdentity,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      AppStrings.instUploadPhotoDesc,
                      style: AppTextStyles.lexend(
                        fontSize: 14,
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
            hint: AppStrings.instStudentNameHint,
            icon: Icons.person,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instParentNameLabel,
            hint: AppStrings.instParentNameHint,
            icon: Icons.group,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instPhoneLabel,
            hint: AppStrings.instPhoneHint,
            icon: Icons.phone,
          ),
          AppSpacing.v20,
          _buildDropdownField(
            label: AppStrings.instGradeLabel,
            hint: AppStrings.instGradeHint,
            icon: Icons.school,
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
          Row(
            children: [
              Expanded(
                child: _buildBatchCard(
                  title: AppStrings.instMorningBatch,
                  time: AppStrings.instMorningTime,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: _buildBatchCard(
                  title: AppStrings.instEveningBatch,
                  time: AppStrings.instEveningTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
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
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
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
    );
  }

  Widget _buildBatchCard({required String title, required String time}) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.s8),
        border: Border.all(color: AppColors.borderGrey, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          Text(
            time,
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
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
            AppStrings.instFeeStructureLabel,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v16,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color:
                  AppColors.scaffoldBg, // extremely light grey matches mockup
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                      AppStrings.instMonthlyFeeAmount,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.instDarkBtnBlue,
                      ),
                    ),
                  ],
                ),
                Text(
                  AppStrings.instEditStructureBtn,
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
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Confirm Button
        GestureDetector(
          onTap: () {
            // Save logic then back
            Get.back();
          },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                  size: AppSpacing.s20,
                ),
                AppSpacing.h8,
                Text(
                  AppStrings.instConfirmBtn,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.v16,
        // Discard Button
        GestureDetector(
          onTap: () => Get.back(),
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
