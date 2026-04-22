import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentProfileScreen extends GetView<InstituteStudentController> {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentData = Get.arguments?['student'] as Map? ?? {};
    final name = studentData['name'] ?? 'Student';
    final id = studentData['id'] ?? 'STU-000';
    final imageUrl =
        studentData['imageUrl'] ?? 'https://i.pravatar.cc/150?img=11';
    final grade = studentData['grade'] ?? '-';
    final status = studentData['status'] ?? 'Active';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const InstituteAppBar(title: 'Student Profile'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.all24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileHeader(name, id, imageUrl, grade, status),
                        AppSpacing.v24,
                        _buildInformationSection(studentData),
                        AppSpacing.v24,
                        _buildFeeBalanceCard(),
                        AppSpacing.v32,
                        _buildActionButtons(context, name),
                        AppSpacing.v40,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => controller.isLoading.value
                  ? Container(
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.instPrimaryBlue,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    String name,
    String id,
    String imageUrl,
    String grade,
    String status,
  ) {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.v20,
          Text(
            name,
            style: AppTextStyles.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.instPrimaryBlue,
            ),
          ),
          AppSpacing.v4,
          Text(
            'ID: $id',
            style: AppTextStyles.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.instAccentBlue,
            ),
          ),
          AppSpacing.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge(
                grade,
                AppColors.instProfileTagBlueBg,
                AppColors.instAccentBlue,
              ),
              AppSpacing.h12,
              _buildBadge(
                status,
                status.toUpperCase() == 'PAID' ||
                        status.toUpperCase() == 'ACTIVE'
                    ? AppColors.instProfileTagGreenBg
                    : AppColors.instBadgePendingBg,
                status.toUpperCase() == 'PAID' ||
                        status.toUpperCase() == 'ACTIVE'
                    ? const Color(0xFF039855)
                    : AppColors.instBadgePendingText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: AppSpacing.x16.add(AppSpacing.y8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInformationSection(Map studentData) {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_ind_rounded,
                color: AppColors.instPrimaryBlue,
                size: 22,
              ),
              AppSpacing.h12,
              Text(
                AppStrings.instAcademicContactInfo,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.instPrimaryBlue,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          _buildInfoField(
            AppStrings.instBatchNameLabel,
            studentData['batch'] ?? 'Not Assigned',
          ),
          _buildInfoField(AppStrings.instAdmissionDateLabel, 'August 12, 2023'),
          _buildInfoField(
            AppStrings.instGuardianNameLabel,
            studentData['guardianName'] ?? 'Not Specified',
          ),
          _buildInfoField(
            AppStrings.instProfilePhoneLabel,
            studentData['phone'] ?? 'Not Available',
          ),
          _buildInfoField(
            AppStrings.instResAddressLabel,
            '42, Emerald Heights, Sector 18, Gurgaon, Haryana - 122001',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v4,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeBalanceCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.instFeeBalanceBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.instFeeBalanceHeading,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppStrings.instCurrentAcadYear,
                    style: AppTextStyles.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.v24,
          Row(
            children: [
              Text(
                '₹0.00',
                style: AppTextStyles.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              AppSpacing.h12,
              Container(
                padding: AppSpacing.x10.add(AppSpacing.y4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppStrings.instAllDuesCleared,
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, AppSpacing.s48),
              elevation: 0,
            ),
            child: Text(
              AppStrings.instViewReceipts,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.instFeeBalanceBg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String studentName) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () => Get.toNamed(
            AppRoutes.instituteAddStudent,
            arguments: {
              'studentId': controller.editingStudentId,
              'student': Get.arguments?['student'],
            },
          ),
          icon: const Icon(
            Icons.edit_outlined,
            size: 20,
            color: AppColors.instPrimaryBlue,
          ),
          label: Text(
            AppStrings.instEditProfile,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.instPrimaryBlue,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.borderGrey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, AppSpacing.s56),
            backgroundColor: const Color(0xFFF9FAFB),
          ),
        ),
        AppSpacing.v16,
        OutlinedButton.icon(
          onPressed: () => _showDeleteConfirmation(context, studentName),
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 20,
            color: Color(0xFFB42318),
          ),
          label: Text(
            AppStrings.instDeleteStudent,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFB42318),
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFDA29B)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            minimumSize: const Size(double.infinity, AppSpacing.s56),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String studentName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: AppSpacing.all32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: AppSpacing.all16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Color(0xFFD92D20),
                  size: 32,
                ),
              ),
              AppSpacing.v24,
              Text(
                'Delete Student',
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v12,
              Text(
                'Are you sure you want to delete\n$studentName?',
                textAlign: TextAlign.center,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textTertiary,
                ),
              ),
              AppSpacing.v32,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: AppSpacing.y16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // close dialog
                        controller.deleteStudent();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD92D20),
                        padding: AppSpacing.y16,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Yes, Delete',
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
