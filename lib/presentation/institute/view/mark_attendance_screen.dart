import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/attendance_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_button.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:fee_easy/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkAttendanceScreen extends GetView<AttendanceController> {
  const MarkAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Column(
                children: [
                  InstituteAppBar(
                    title: 'Mark Attendance',
                    onBackTap: () => Get.back(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppSpacing.x24.add(
                        const EdgeInsets.only(top: 8, bottom: 16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildBatchHeader(controller, context),
                          AppSpacing.v24,
                          if (controller.isEditable) ...[
                            _buildBulkActionButtons(controller),
                            AppSpacing.v24,
                          ],
                          _buildSearchBar(controller),
                          AppSpacing.v24,
                          ...controller.filteredStudents.map(
                            (student) => Padding(
                              padding: AppSpacing.bottom16,
                              child: _buildStudentCard(controller, student),
                            ),
                          ),
                          if (controller.filteredStudents.isEmpty &&
                              !controller.isLoading.value)
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
                ],
              ),
              if (controller.isLoading.value && controller.allStudents.isEmpty)
                const CommonLoading(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => (controller.isEditable && controller.allStudents.isNotEmpty)
            ? InstituteBottomButton(
                label: 'Submit Attendance',
                icon: Icons.check_circle_rounded,
                onTap: () => controller.submitAttendance(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildBatchHeader(
    AttendanceController controller,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.batch.title,
          style: AppTextStyles.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v12,
        GestureDetector(
          onTap: () => controller.selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.paleSilver,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
                AppSpacing.h12,
                Text(
                  controller.formattedDate,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.h12,
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulkActionButtons(AttendanceController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildBulkButton(
            label: 'All Present',
            icon: Icons.done_all_rounded,
            color: AppColors.primaryBrand,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppColors.white,
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
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AttendanceController controller) {
    return AppSearchField(
      hintText: 'Search student by name or ID...',
      onChanged: (value) => controller.searchQuery.value = value,
    );
  }

  Widget _buildStudentCard(
    AttendanceController controller,
    AttendanceStudent student,
  ) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          _buildStudentAvatar(student.profileImageUrl, student.name),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'ID: ${student.id}',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusToggle(controller, student),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(
    AttendanceController controller,
    AttendanceStudent student,
  ) {
    bool isPresent = student.isPresent;
    final isEditable = controller.isEditable;

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleOption(
            label: 'PRESENT',
            isSelected: isPresent,
            color: AppColors.primaryBrand,
            onTap: isEditable
                ? () => controller.toggleStatus(student, true)
                : null,
          ),
          _buildToggleOption(
            label: 'ABSENT',
            isSelected: !isPresent,
            color: const Color(0xFF7C2D12),
            onTap: isEditable
                ? () => controller.toggleStatus(student, false)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentAvatar(String? imageUrl, String name) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com')) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primaryBrandLight,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0].toUpperCase();
      if (names.length > 1) {
        initials += names[names.length - 1][0].toUpperCase();
      }
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryBrandLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
    );
  }
}
