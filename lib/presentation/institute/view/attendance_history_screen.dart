import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceHistoryScreen extends GetView<StaffController> {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Attendance History'),
            Expanded(
              child: ListView(
                padding: AppSpacing.all24,
                children: [
                  _buildSectionHeader('TODAY, OCT 24'),
                  AppSpacing.v16,
                  _buildAttendanceCard(
                    'Sarah Jenkins',
                    'On time for the morning briefing.',
                    'Present',
                    AppColors.successGreen,
                    'https://i.pravatar.cc/150?u=sarah',
                  ),
                  AppSpacing.v12,
                  _buildAttendanceCard(
                    'David Chen',
                    'Scheduled medical appointment.',
                    'Absent',
                    AppColors.errorRed,
                    'https://i.pravatar.cc/150?u=david',
                  ),
                  AppSpacing.v12,
                  _buildAttendanceCard(
                    'Elena Rodriguez',
                    '',
                    'Present',
                    AppColors.successGreen,
                    'https://i.pravatar.cc/150?u=elena',
                  ),
                  AppSpacing.v24,
                  _buildSectionHeader('YESTERDAY, OCT 23'),
                  AppSpacing.v16,
                  _buildAttendanceCard(
                    'Marcus Thorne',
                    '',
                    'Present',
                    AppColors.successGreen,
                    'https://i.pravatar.cc/150?u=marcus',
                  ),
                  AppSpacing.v12,
                  _buildAttendanceCard(
                    'Sophia Laurent',
                    'Late due to public transport delay.',
                    'Present',
                    AppColors.successGreen,
                    'https://i.pravatar.cc/150?u=sophia',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildLogAttendanceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAttendanceCard(
    String name,
    String remark,
    String status,
    Color statusColor,
    String imageUrl,
  ) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    _buildStatusBadge(status, statusColor),
                  ],
                ),
                if (remark.isNotEmpty) ...[
                  AppSpacing.v4,
                  Text(
                    '"$remark"',
                    style: AppTextStyles.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          AppSpacing.h6,
          Text(
            status,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogAttendanceButton() {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed(AppRoutes.instituteLogStaffAttendance);
      },
      backgroundColor: AppColors.primaryBrand,
      child: const Icon(Icons.add, color: AppColors.white, size: 32),
    );
  }
}
