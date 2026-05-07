import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffProfileScreen extends GetView<StaffController> {
  const StaffProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Staff Profile',
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.instituteAddEditStaff),
                  icon: const Icon(Icons.edit, color: AppColors.primaryBrand),
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(),
                  icon: const Icon(Icons.delete, color: AppColors.bohoRed),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                final staff = controller.selectedStaff.value;
                if (staff == null) {
                  return const Center(child: Text('No staff selected'));
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(staff),
                      const Divider(height: 1, color: AppColors.divider),
                      _buildInfoSection(staff),
                      AppSpacing.v40,
                      _buildActionButtons(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Staff staff) {
    return Container(
      padding: AppSpacing.all24,
      color: AppColors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/300'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppSpacing.h20,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name,
                  style: AppTextStyles.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  staff.role,
                  style: AppTextStyles.lexend(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.v16,
                _buildContactItem(
                  Icons.email,
                  staff.email,
                  AppColors.primaryBrand,
                ),
                AppSpacing.v8,
                _buildContactItem(
                  Icons.phone,
                  staff.phone,
                  AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String value, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        AppSpacing.h12,
        Text(
          value,
          style: AppTextStyles.lexend(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: iconColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(Staff staff) {
    return Container(
      padding: AppSpacing.all24,
      color: AppColors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildSimpleInfo(
              Icons.business,
              'DEPARTMENT',
              'Global Logistics',
            ),
          ),
          Expanded(
            child: _buildSimpleInfo(Icons.work, 'EMPLOYMENT TYPE', 'Salary'),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfo(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
        AppSpacing.v12,
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primaryBrand),
            AppSpacing.h12,
            Text(
              value,
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: AppSpacing.x24,
      child: Row(
        children: [
          Expanded(
            child: _buildLargeButton(
              Icons.calendar_today,
              'Attendance',
              true,
              onTap: () => Get.toNamed(AppRoutes.instituteStaffAttendance),
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: _buildLargeButton(
              Icons.payments,
              'Salary',
              false,
              onTap: () => Get.toNamed(AppRoutes.instituteSalaryHistory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeButton(
    IconData icon,
    String label,
    bool isFilled, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.primaryBrand : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryBrand, width: 1.5),
          boxShadow: isFilled
              ? [
                  BoxShadow(
                    color: AppColors.primaryBrand.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isFilled ? AppColors.white : AppColors.primaryBrand,
              size: 20,
            ),
            AppSpacing.h12,
            Text(
              label,
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isFilled ? AppColors.white : AppColors.primaryBrand,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Staff'),
        content: const Text(
          'Are you sure you want to delete this staff member?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              Get.snackbar('Deleted', 'Staff member has been removed');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
