import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/data/models/notification_model.dart';
import 'package:tuoora/presentation/institute/controllers/notification_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InstituteNotificationsScreen extends GetView<NotificationController> {
  const InstituteNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InstituteAppBar(title: 'Notification', isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.notifications.isEmpty) {
                  return const CommonLoading();
                }

                if (controller.errorMessage.isNotEmpty &&
                    controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${controller.errorMessage.value}',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.manrope(
                            color: AppColors.errorRed,
                          ),
                        ),
                        AppSpacing.v16,
                        ElevatedButton(
                          onPressed: () => controller.fetchNotifications(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        AppSpacing.v16,
                        Text(
                          'No notifications yet',
                          style: AppTextStyles.manrope(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshNotifications(),
                  color: AppColors.primaryBrand,
                  child: ListView.separated(
                    padding: AppSpacing.x24.add(AppSpacing.y16),
                    itemCount: controller.notifications.length,
                    separatorBuilder: (context, index) => AppSpacing.v16,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    IconData icon;
    Color iconBg;
    Color iconColor;
    String badge;
    Color badgeColor;

    switch (notification.type.toLowerCase()) {
      case 'announcement':
        icon = Icons.campaign_rounded;
        iconBg = AppColors.amberLight;
        iconColor = AppColors.orangeDue;
        badge = 'ANNOUNCEMENT';
        badgeColor = AppColors.orangeDue;
        break;
      case 'urgent':
        icon = Icons.warning_amber_rounded;
        iconBg = AppColors.errorBg;
        iconColor = AppColors.errorRed;
        badge = 'URGENT';
        badgeColor = AppColors.errorRed;
        break;
      case 'update':
        icon = Icons.update_rounded;
        iconBg = AppColors.studentUpdateIconBg;
        iconColor = AppColors.studentUpdateIconColor;
        badge = 'UPDATE';
        badgeColor = AppColors.studentUpdateIconColor;
        break;
      default:
        icon = Icons.notifications_rounded;
        iconBg = AppColors.background;
        iconColor = AppColors.textSecondary;
        badge = 'INFO';
        badgeColor = AppColors.textTertiary;
    }

    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
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
        border: notification.isRead
            ? null
            : Border.all(color: badgeColor.withValues(alpha: 0.2), width: 1),
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
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    Text(
                      _getRelativeTime(notification.createdAt),
                      style: AppTextStyles.manrope(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.v12,
                Text(
                  notification.title,
                  style: AppTextStyles.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkSlate,
                    height: 1.2,
                  ),
                ),
                AppSpacing.v8,
                Text(
                  notification.message,
                  style: AppTextStyles.lexend(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                if (notification.image != null) ...[
                  AppSpacing.v16,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      notification.image!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
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

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}
