import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/controllers/student_notifications_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentNotificationScreen
    extends GetView<StudentNotificationsController> {
  const StudentNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(
              title: 'Notifications',
              showDefaultActions: false,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.studentBrand,
                    ),
                  );
                }
                final displays = controller.displays;
                if (displays.isEmpty) {
                  return _EmptyState(onRefresh: controller.load);
                }
                return RefreshIndicator(
                  color: AppColors.studentBrand,
                  onRefresh: controller.load,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s16,
                      vertical: AppSpacing.s12,
                    ),
                    itemCount: displays.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.s12),
                    itemBuilder: (context, index) {
                      final d = displays[index];
                      return _NotificationCard(
                        display: d,
                        onTap: () => controller.openNotification(d.raw),
                      );
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
}

class _NotificationCard extends StatelessWidget {
  final StudentNotificationDisplay display;
  final VoidCallback onTap;

  const _NotificationCard({required this.display, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.s12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: display.iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(display.icon, color: display.iconColor, size: 20),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            display.title,
                            style: AppTextStyles.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (display.showChevron) ...[
                          AppSpacing.h4,
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      display.message,
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (display.timeAgo.isNotEmpty)
                      Text(
                        display.timeAgo,
                        style: AppTextStyles.lexend(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBrand,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.studentBrand,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.s24),
        children: [
          const SizedBox(height: 80),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.studentBrandSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.studentBrand,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Center(
            child: Text(
              "You're all caught up.",
              style: AppTextStyles.lexend(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
