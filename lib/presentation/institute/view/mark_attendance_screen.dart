import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/attendance_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkAttendanceScreen extends GetView<AttendanceController> {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Mark Attendance'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(const EdgeInsets.only(top: 8, bottom: 16)),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBatchHeader(),
                      AppSpacing.v24,
                      _buildBulkActionButtons(),
                      AppSpacing.v24,
                      _buildSearchBar(),
                      AppSpacing.v24,
                      ...controller.filteredStudents.map(
                        (student) => Padding(
                          padding: AppSpacing.bottom16,
                          child: _buildStudentCard(student),
                        ),
                      ),
                      if (controller.filteredStudents.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              'No students found',
                              style: AppTextStyles.manrope(
                                fontSize: 16,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instBatchPhysics,
          style: AppTextStyles.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v4,
        Text(
          controller.formattedDate,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBulkActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildBulkButton(
            label: 'All Present',
            icon: Icons.done_all_rounded,
            color: const Color(0xFF1E3A8A),
            onTap: () => controller.markAllPresent(),
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: _buildBulkButton(
            label: 'All Absent',
            icon: Icons.person_off_rounded,
            color: const Color(0xFF7C2D12),
            onTap: () => controller.markAllAbsent(),
          ),
        ),
      ],
    );
  }

  Widget _buildBulkButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          AppSpacing.h8,
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: AppSpacing.x16,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppColors.textMuted),
          hintText: AppStrings.instSearchStudentHintAlt,
          hintStyle: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(student['avatar']),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'ID: ${student['id']}',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusToggle(student),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(Map<String, dynamic> student) {
    bool isPresent = student['isPresent'];
    return Container(
      height: AppSpacing.s36,
      decoration: BoxDecoration(
        color: AppColors.instStatusPickerBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.toggleStatus(student, true),
            child: Container(
              padding: AppSpacing.x12,
              decoration: BoxDecoration(
                color: isPresent ? const Color(0xFF1E3A8A) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                AppStrings.instStatusPresentRaw,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isPresent ? Colors.white : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.toggleStatus(student, false),
            child: Container(
              padding: AppSpacing.x12,
              decoration: BoxDecoration(
                color: !isPresent
                    ? const Color(0xFF7C2D12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                AppStrings.instStatusAbsentRaw,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: !isPresent ? Colors.white : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -AppSpacing.s4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.snackbar('Success', 'Attendance submitted successfully');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF005AC1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, AppSpacing.s56),
          elevation: 0,
        ),
        child: Text(
          AppStrings.instSubmitAttendance,
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
