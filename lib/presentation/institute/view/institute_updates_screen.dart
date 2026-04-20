import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/view/create_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fee_easy/presentation/institute/controllers/updates_controller.dart';
import 'package:intl/intl.dart';

class InstituteUpdatesScreen extends GetView<UpdatesController> {
  const InstituteUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Updates Hub', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimelineHeader(),
                    AppSpacing.v24,
                    _buildTimelineList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateUpdateScreen()),
        backgroundColor: const Color(0xFF0051B3),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Timeline',
          style: AppTextStyles.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.updatesList.length,
        itemBuilder: (context, index) {
          final update = controller.updatesList[index];
          final isLast = index == controller.updatesList.length - 1;

          Color iconBg;
          Color iconColor;
          IconData icon;

          switch (update.category) {
            case 'Fee Reminder':
              iconBg = const Color(0xFFDBEAFE);
              iconColor = const Color(0xFF1E40AF);
              icon = Icons.request_quote_rounded;
              break;
            case 'Holiday':
              iconBg = const Color(0xFFFFEDD5);
              iconColor = const Color(0xFFC2410C);
              icon = Icons.beach_access_rounded;
              break;
            case 'Event':
              iconBg = const Color(0xFFF3E8FF);
              iconColor = const Color(0xFF7E22CE);
              icon = Icons.event_available_rounded;
              break;
            case 'Notice':
            default:
              iconBg = const Color(0xFFF1F5F9);
              iconColor = const Color(0xFF475569);
              icon = Icons.info_outline_rounded;
              break;
          }

          return _buildTimelineItem(
            icon: icon,
            iconBg: iconBg,
            iconColor: iconColor,
            badgeText: update.category.toUpperCase(),
            badgeBg: iconBg,
            badgeTextColor: iconColor,
            timeText: update.timeAgo,
            title: update.subject,
            subtitleIcon: Icons.people_outline_rounded,
            subtitleText: update.audience,
            dateText: DateFormat('MMM dd, yyyy').format(update.date),
            isLast: isLast,
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String timeText,
    required String title,
    required IconData subtitleIcon,
    required String subtitleText,
    required String dateText,
    String? secondaryBadge,
    Color? secondaryBadgeBg,
    bool isLast = false,
    bool hasCardBorder = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
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
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
          AppSpacing.h16,
          // Content Card
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: AppSpacing.all20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: hasCardBorder
                        ? Border.all(color: const Color(0xFFDBEAFE), width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText,
                              style: AppTextStyles.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: badgeTextColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (secondaryBadge != null) ...[
                            AppSpacing.h8,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: secondaryBadgeBg,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                secondaryBadge,
                                style: AppTextStyles.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            timeText,
                            style: AppTextStyles.lexend(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.v16,
                      Text(
                        title,
                        style: AppTextStyles.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.v16,
                      Row(
                        children: [
                          Icon(
                            subtitleIcon,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          AppSpacing.h8,
                          Text(
                            subtitleText,
                            style: AppTextStyles.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          AppSpacing.h16,
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          AppSpacing.h8,
                          Text(
                            dateText,
                            style: AppTextStyles.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
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
