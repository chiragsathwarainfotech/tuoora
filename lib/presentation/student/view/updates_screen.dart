import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s12,
                ),
                child: Column(
                  children: [
                    _buildNotificationCard(
                      icon: Icons.currency_rupee,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFF92400E),
                      title: 'Fee reminder • ₹4,500 due 25 May',
                      time: '2h ago',
                      description:
                          'Your May 2026 tuition fee is due in 6 days. Tap to pay or view invoice.',
                      showChevron: true,
                      onTap: () => Get.toNamed(
                        AppRoutes.studentFeeReminder,
                        arguments: {'isPaid': false},
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildNotificationCard(
                      icon: Icons.chrome_reader_mode_outlined,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFF92400E),
                      title: 'New assignment added',
                      time: '4h ago',
                      description:
                          'Trigonometry — Ch. 8 exercises assigned by Mr. Verma. Due today, 11:59 PM.',
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildNotificationCard(
                      icon: Icons.auto_awesome,
                      iconBg: const Color(0xFFCCFBF1),
                      iconColor: const Color(0xFF0F766E),
                      title: 'Science Day exhibition',
                      time: 'Today',
                      description:
                          'Saturday 24 May, 10 AM. Set up your project by 9:30. Parents welcome.',
                      showChevron: true,
                      onTap: () => Get.toNamed(AppRoutes.studentEventDetail),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildNotificationCard(
                      icon: Icons.notifications_none_outlined,
                      iconBg: const Color(0xFFFEF2F2),
                      iconColor: const Color(0xFF991B1B),
                      title: 'Daily update from Mr. Verma',
                      time: '4h ago',
                      description:
                          'Today we covered identities sin²+cos²=1 and complementary angle formulas.',
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildNotificationCard(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFF92400E),
                      title: 'Holiday • Buddha Purnima',
                      time: 'Tomorrow',
                      description:
                          'Institute is closed on Wednesday 21 May. Classes resume Thursday at 8 AM.',
                      showChevron: true,
                      onTap: () => Get.toNamed(AppRoutes.studentHolidayDetail),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildNotificationCard(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFDCFCE7),
                      iconColor: const Color(0xFF15803D),
                      title: 'Marked present',
                      time: 'Mon',
                      description:
                          'You were marked present on 17 May at 8:00 AM (Math + Science).',
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildNotificationCard(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFDCFCE7),
                      iconColor: const Color(0xFF15803D),
                      title: 'Marked absent',
                      time: '13 May',
                      description:
                          'You were marked absent on 13 May. Reason recorded by parent: sick leave.',
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

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String time,
    required String description,
    bool showChevron = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: AppTextStyles.lexend(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (showChevron) ...[
                        AppSpacing.h4,
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
