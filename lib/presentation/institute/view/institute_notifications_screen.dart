import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';

class InstituteNotificationsScreen extends StatefulWidget {
  const InstituteNotificationsScreen({super.key});

  @override
  State<InstituteNotificationsScreen> createState() =>
      _InstituteNotificationsScreenState();
}

class _InstituteNotificationsScreenState
    extends State<InstituteNotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InstituteAppBar(title: 'Notification', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationCard(
                      badge: 'URGENT',
                      badgeColor: const Color(0xFF7C2D12),
                      badgeTextColor: Colors.white,
                      time: '3h ago',
                      title: 'Subscription Expiring Soon',
                      description:
                          'Your Premium plan expires in 3 days. Renew now to avoid service interruption.',
                      icon: Icons.warning_amber_rounded,
                      iconBg: const Color(0xFFFFEDD5),
                      iconColor: const Color(0xFFD97706),
                      actionText: 'Renew Plan',
                    ),
                    AppSpacing.v16,
                    _buildNotificationCard(
                      badge: 'UPDATE',
                      badgeColor: const Color(0xFF1D4ED8),
                      badgeTextColor: Colors.white,
                      time: 'Yesterday',
                      title: 'New Feature: Attendance Reports',
                      description:
                          'You can now export detailed monthly attendance reports in PDF format.',
                      icon: Icons.update_rounded,
                      iconBg: const Color(0xFFDBEAFE),
                      iconColor: const Color(0xFF2563EB),
                      imageUrl:
                          'https://img.freepik.com/free-vector/data-report-concept-illustration_114360-883.jpg',
                    ),
                    AppSpacing.v16,
                    _buildNotificationCard(
                      badge: 'INFO',
                      badgeColor: const Color(0xFF64748B),
                      badgeTextColor: Colors.white,
                      time: 'Mar 15',
                      title: 'System Maintenance',
                      description:
                          'Scheduled maintenance on Sunday, March 20, from 2 AM to 4 AM IST. The platform will be temporarily inaccessible.',
                      icon: Icons.info_outline_rounded,
                      iconBg: const Color(0xFFF1F5F9),
                      iconColor: const Color(0xFF475569),
                    ),
                    AppSpacing.v16,
                    _buildNotificationCard(
                      badge: 'SUCCESS',
                      badgeColor: const Color(0xFFE2E8F0),
                      badgeTextColor: const Color(0xFF475569),
                      time: '1w ago',
                      title: 'Fee Collection Milestone',
                      description:
                          'Congratulations! You\'ve reached 90% fee collection for the current quarter.',
                      icon: Icons.check_circle_outline_rounded,
                      iconBg: const Color(0xFFF1F5F9),
                      iconColor: const Color(0xFF475569),
                    ),
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

  Widget _buildNotificationCard({
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required String time,
    required String title,
    required String description,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    String? actionText,
    String? imageUrl,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          AppSpacing.h20,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: AppTextStyles.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.manrope(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.v12,
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
                AppSpacing.v8,
                Text(
                  description,
                  style: AppTextStyles.lexend(
                    fontSize: 13,
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
                if (imageUrl != null) ...[
                  AppSpacing.v16,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                if (actionText != null) ...[
                  AppSpacing.v16,
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          actionText,
                          style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1D4ED8),
                          ),
                        ),
                        AppSpacing.h8,
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF1D4ED8),
                          size: 16,
                        ),
                      ],
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
}
