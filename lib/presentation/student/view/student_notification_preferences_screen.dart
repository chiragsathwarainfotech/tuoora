import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/presentation/student/controllers/student_notification_preferences_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/core/widgets/toggle_switch.dart';

class StudentNotificationPreferencesScreen
    extends GetView<StudentNotificationPreferencesController> {
  const StudentNotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StudentAppBar(
              title: 'Notifications',
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMuteCard(),
                    const SizedBox(height: 24),
                    Text(
                      'CATEGORIES',
                      style: AppTextStyles.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCategoriesCard(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Changes save automatically.',
                          style: AppTextStyles.lexend(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mute everything',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stops all push alerts. In-app notifications still appear.',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => ToggleSwitch(
              value: controller.muteEverything.value,
              onChanged: controller.toggleMuteEverything,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Obx(
            () => _buildToggleRow(
              icon: Icons.currency_rupee_rounded,
              title: 'Fee reminders',
              subtitle: 'Due dates and payment confirmations',
              value: controller.feeReminders.value,
              onChanged: controller.toggleFeeReminders,
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          Obx(
            () => _buildToggleRow(
              icon: Icons.tablet_mac_rounded,
              title: 'Assignment alerts',
              subtitle: 'New assignments and grading',
              value: controller.assignmentAlerts.value,
              onChanged: controller.toggleAssignmentAlerts,
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          Obx(
            () => _buildToggleRow(
              icon: Icons.calendar_today_outlined,
              title: 'Attendance',
              subtitle: 'Marked present / absent',
              value: controller.attendance.value,
              onChanged: controller.toggleAttendance,
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          Obx(
            () => _buildToggleRow(
              icon: Icons.auto_awesome_rounded,
              title: 'Daily updates',
              subtitle: 'Topics covered in class',
              value: controller.dailyUpdates.value,
              onChanged: controller.toggleDailyUpdates,
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          Obx(
            () => _buildToggleRow(
              icon: Icons.event_note_rounded,
              title: 'Events & holidays',
              subtitle: 'Institute-wide notices',
              value: controller.eventsHolidays.value,
              onChanged: controller.toggleEventsHolidays,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: value ? FontWeight.w800 : FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ToggleSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
