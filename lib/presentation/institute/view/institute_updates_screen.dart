import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/view/create_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteUpdatesScreen extends StatelessWidget {
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
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildTimelineItem(
          icon: Icons.request_quote_rounded,
          iconBg: const Color(0xFFDBEAFE),
          iconColor: const Color(0xFF1E40AF),
          badgeText: 'FEE REMINDER',
          badgeBg: const Color(0xFFDBEAFE),
          badgeTextColor: const Color(0xFF1E40AF),
          timeText: '2h ago',
          title: 'March Tuition Fee Reminder',
          subtitleIcon: Icons.people_outline_rounded,
          subtitleText: '452 Students',
          dateText: 'Mar 15, 2024',
          isFirst: true,
        ),
        _buildTimelineItem(
          icon: Icons.menu_book_rounded,
          iconBg: const Color(0xFFFFEDD5),
          iconColor: const Color(0xFFC2410C),
          badgeText: 'HOMEWORK',
          badgeBg: const Color(0xFFFFEDD5),
          badgeTextColor: const Color(0xFFC2410C),
          timeText: '1d ago',
          title: 'Final Semester Project Guidelines',
          subtitleIcon: Icons.people_outline_rounded,
          subtitleText: 'Grade 10 - Batch A',
          dateText: 'Mar 14, 2024',
        ),
        _buildTimelineItem(
          icon: Icons.campaign_rounded,
          iconBg: const Color(0xFF003D99),
          iconColor: Colors.white,
          badgeText: 'ANNOUNCEMENT',
          badgeBg: const Color(0xFFDBEAFE),
          badgeTextColor: const Color(0xFF1E40AF),
          secondaryBadge: 'URGENT',
          secondaryBadgeBg: const Color(0xFFB91C1C),
          timeText: '3d ago',
          title: 'Annual Sports Day Schedule',
          subtitleIcon: Icons.people_outline_rounded,
          subtitleText: 'All Batches',
          dateText: 'Mar 12, 2024',
          isLast: true,
          hasCardBorder: true,
        ),
      ],
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
    bool isFirst = false,
    bool isLast = false,
    bool hasCardBorder = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline Sidebar
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
