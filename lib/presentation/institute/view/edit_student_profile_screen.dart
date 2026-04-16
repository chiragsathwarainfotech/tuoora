import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditStudentProfileScreen extends StatelessWidget {
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
                  color: const Color(0xFF5B98A6),
                  borderRadius: BorderRadius.circular(AppSpacing.s12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://i.pravatar.cc/150?u=student_arjun',
                    ),
                    fit: BoxFit.cover,
                  ),
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
          ),
          AppSpacing.v20,
          _buildDropdownField(
            label: AppStrings.instGradeLabel,
            hint: 'Grade 10-A',
            icon: Icons.school,
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
          Row(
            children: [
              Expanded(
                child: _buildBatchCard(
                  title: 'Science Stream',
                  time: '08:00 AM - 10:00 AM',
                  isSelected: true,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: _buildBatchCard(
                  title: 'Evening Batch',
                  time: '04:00 PM - 06:00 PM',
                  isSelected: false,
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
            controller: TextEditingController(text: hint),
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
            style: AppTextStyles.lexend(
              fontSize: 13,
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
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                      '₹2,500.00',
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.instDarkBtnBlue,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Change',
                  style: AppTextStyles.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.instDarkBtnBlue,
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
        GestureDetector(
          onTap: () {
            Get.offAllNamed(AppRoutes.instituteStudents);
            Get.snackbar(
              'Profile Updated',
              'Student information has been successfully saved.',
              backgroundColor: const Color(0xFF027A48),
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: AppSpacing.all16,
            );
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
