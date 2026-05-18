import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/view/create_update_screen.dart';
import 'package:tuoora/presentation/shared/widgets/common_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/institute/controllers/updates_controller.dart';
import 'package:intl/intl.dart';

class InstituteUpdatesScreen extends StatelessWidget {
  const InstituteUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdatesController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Updates', isRoot: false),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchUpdates(),
                color: AppColors.primaryBrand,
                child: Obx(() {
                  return CommonStateWidget(
                    isLoading: controller.isLoading.value,
                    isEmpty: controller.updatesList.isEmpty,
                    emptyTitle: 'No Updates Found',
                    emptySubtitle:
                        'Broadcast your first update to students and parents to keep them informed.',
                    emptyIcon: Icons.campaign_outlined,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      itemCount: controller.updatesList.length,
                      itemBuilder: (context, index) {
                        final update = controller.updatesList[index];

                        Color iconBg;
                        Color iconColor;
                        IconData icon;

                        final category = update.category;
                        switch (category) {
                          case UpdateCategory.Academic:
                            iconBg = const Color(0xFFEFF6FF);
                            iconColor = const Color(0xFF1E40AF);
                            icon = Icons.school_rounded;
                            break;
                          case UpdateCategory.Administrative:
                            iconBg = const Color(0xFFF1F5F9);
                            iconColor = const Color(0xFF475569);
                            icon = Icons.admin_panel_settings_rounded;
                            break;
                          case UpdateCategory.Emergency:
                            iconBg = const Color(0xFFFEF2F2);
                            iconColor = Colors.redAccent;
                            icon = Icons.error_rounded;
                            break;
                          case UpdateCategory.Event:
                            iconBg = const Color(0xFFFDF2F8);
                            iconColor = const Color(0xFF9D174D);
                            icon = Icons.celebration_rounded;
                            break;
                          case UpdateCategory.Other:
                            iconBg = const Color(0xFFFFF7ED);
                            iconColor = const Color(0xFF9A3412);
                            icon = Icons.campaign_rounded;
                            break;
                        }

                        return _buildTimelineItem(
                          title: update.topic ?? "No Topic",
                          subtitle: update.description,
                          icon: icon,
                          iconBg: iconBg,
                          iconColor: iconColor,
                          badgeText: update.category.name.toUpperCase(),
                          badgeBg: iconBg,
                          badgeTextColor: iconColor,
                          timeText: update.timeAgo,
                          audienceText: update.audience,
                          dateText: update.createdAt != null
                              ? DateFormat(
                                  'yyyy-dd-MMM',
                                ).format(update.createdAt!)
                              : 'Recent',
                          isLast: index == controller.updatesList.length - 1,
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateUpdateScreen()),
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String timeText,
    required String audienceText,
    required String dateText,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: AppColors.borderGrey,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.h16,
          // Right side: Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.reportBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                          color: badgeBg.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                      Text(
                        timeText,
                        style: AppTextStyles.lexend(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty && subtitle != title) ...[
                    AppSpacing.v8,
                    Text(
                      subtitle,
                      style: AppTextStyles.lexend(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  AppSpacing.v16,
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              size: 16,
                              color: AppColors.textMuted.withValues(alpha: 0.8),
                            ),
                            AppSpacing.h8,
                            Expanded(
                              child: Text(
                                audienceText,
                                style: AppTextStyles.lexend(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.textMuted.withValues(alpha: 0.8),
                          ),
                          AppSpacing.h8,
                          Text(
                            dateText,
                            style: AppTextStyles.lexend(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
