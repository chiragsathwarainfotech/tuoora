import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';

class InstituteNotificationsScreen extends StatefulWidget {
  const InstituteNotificationsScreen({super.key});

  @override
  State<InstituteNotificationsScreen> createState() => _InstituteNotificationsScreenState();
}

class _InstituteNotificationsScreenState extends State<InstituteNotificationsScreen> {
  bool pushEnabled = true;
  bool whatsappEnabled = true;
  bool soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Notifications', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Preferences'),
                    AppSpacing.v16,
                    _buildSettingsCard(),
                    AppSpacing.v32,
                    _buildSectionHeader('Recent Activity'),
                    AppSpacing.v16,
                    _buildNotificationsList(),
                    AppSpacing.v40,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF003D99),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.notifications_active_rounded,
            title: 'Push Notifications',
            subtitle: 'Alerts on student device',
            value: pushEnabled,
            onChanged: (val) => setState(() => pushEnabled = val),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4FB)),
          _buildSettingItem(
            icon: Icons.chat_bubble_rounded,
            title: 'WhatsApp Alerts',
            subtitle: 'Direct messages via API',
            value: whatsappEnabled,
            onChanged: (val) => setState(() => whatsappEnabled = val),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4FB)),
          _buildSettingItem(
            icon: Icons.volume_up_rounded,
            title: 'Alert Sounds',
            subtitle: 'Chimes for critical updates',
            value: soundEnabled,
            onChanged: (val) => setState(() => soundEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1E40AF), size: 18),
          ),
          AppSpacing.h16,
          Expanded(
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
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF003082),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Column(
      children: [
        _buildNotificationItem(
          icon: Icons.account_balance_wallet_rounded,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF166534),
          title: 'Fee Collected',
          message: 'Q2 Fee for Student #1042 was successfully recorded.',
          time: '10m ago',
        ),
        AppSpacing.v16,
        _buildNotificationItem(
          icon: Icons.person_add_rounded,
          iconBg: const Color(0xFFDBEAFE),
          iconColor: const Color(0xFF1E40AF),
          title: 'New Admission',
          message: 'Rahul Sharma (Grade 10) was added to Batch B.',
          time: '2h ago',
        ),
        AppSpacing.v16,
        _buildNotificationItem(
          icon: Icons.warning_amber_rounded,
          iconBg: const Color(0xFFFEE2E2),
          iconColor: const Color(0xFF991B1B),
          title: 'Attendance Alert',
          message: '3 students in Batch A have been absent for 3 days.',
          time: 'Yesterday',
        ),
        AppSpacing.v16,
        _buildNotificationItem(
          icon: Icons.verified_rounded,
          iconBg: const Color(0xFFFEF9C3),
          iconColor: const Color(0xFF854D0E),
          title: 'Subscription Renewed',
          message: 'Your Premium plan for St. Augustine\'s Institute was renewed.',
          time: '2 days ago',
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.lexend(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                AppSpacing.v4,
                Text(
                  message,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
}
