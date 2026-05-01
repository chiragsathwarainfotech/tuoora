import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/student_bottom_nav.dart';
import 'package:fee_easy/core/widgets/portal_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomeworkScreen extends StatefulWidget {
  final bool showBottomNav;
  const StudentHomeworkScreen({super.key, this.showBottomNav = true});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
  String selectedFilter = 'To Do';

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildWeeklyGoalCard(),
          AppSpacing.v32,
          _buildFilterTabs(),
          AppSpacing.v32,
          _buildFeaturedHomeworkCard(),
          AppSpacing.v24,
          _buildHomeworkCard(
            subject: 'HISTORY',
            title: 'The Industrial Revolution: Socio-Economic Impacts',
            professor: 'Mrs. G. White',
            dueDate: 'Oct 14',
            status: 'Pending Review',
            icon: Icons.history_edu_rounded,
            buttonLabel: 'View Details',
            isUrgent: false,
          ),
          AppSpacing.v16,
          _buildHomeworkCard(
            subject: 'PHYSICS',
            title: 'Quantum Mechanics: Particle in a Box Experiment',
            professor: 'Dr. R. Feynman',
            dueDate: 'Oct 16',
            status: 'In Progress',
            icon: Icons.science_outlined,
            buttonLabel: 'Continue Work',
            isUrgent: false,
            isActive: true,
          ),
          AppSpacing.v16,
          _buildHomeworkCard(
            subject: 'LITERATURE',
            title: 'Comparative Analysis: Romanticism vs. Realism',
            professor: 'Prof. Austen',
            dueDate: 'Oct 18',
            status: '5 Days Remaining',
            icon: Icons.menu_book_rounded,
            buttonLabel: 'Open Assignment',
            isUrgent: false,
            isDeadlineStyle: true,
          ),
          AppSpacing.v32,
          _buildPrepGuideCard(),
          AppSpacing.v100,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PortalAppBar(
        title: AppStrings.appName,
        profileRoute: AppRoutes.studentSettings,
        notificationsRoute: AppRoutes.studentNotifications,
      ),
      body: content,
      bottomNavigationBar: widget.showBottomNav ? const StudentBottomNav(currentIndex: 2) : null,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s28,
        AppSpacing.s40,
        AppSpacing.s28,
        AppSpacing.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Homework Center',
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            'Manage assignments uploaded by your tutors.',
            style: AppTextStyles.lexend(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Container(
      margin: AppSpacing.x28,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WEEKLY GOAL',
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '68%',
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.68,
              minHeight: AppSpacing.s12,
              backgroundColor: AppColors.reportBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBrand,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: AppSpacing.x28,
      padding: AppSpacing.all6,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabPill('To-Do', selectedFilter == 'To Do')),
          Expanded(
            child: _buildTabPill('Completed', selectedFilter == 'Completed'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(
        () => selectedFilter = label == 'To-Do' ? 'To Do' : 'Completed',
      ),
      child: Container(
        padding: AppSpacing.y12,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.s16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: AppSpacing.s4,
                    offset: const Offset(0, AppSpacing.s2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedHomeworkCard() {
    return Container(
      margin: AppSpacing.x28,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: const Color(0xFF0052C2),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0052C2).withValues(alpha: 0.25),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
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
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
                child: Text(
                  'MATHEMATICS',
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: AppColors.redDot,
                      size: AppSpacing.s12,
                    ),
                    AppSpacing.h4,
                    Text(
                      'DUE TODAY',
                      style: AppTextStyles.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.redDot,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          Text(
            'By Prof. Henderson',
            style: AppTextStyles.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
          AppSpacing.v16,
          Text(
            'Advanced Calculus:\nVolume Integrals',
            style: AppTextStyles.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          AppSpacing.v12,
          Text(
            'Complete the problem set on page 412. Focus on spherical coordinates and...',
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          AppSpacing.v32,
          Row(
            children: [
              SizedBox(
                width: 60,
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: AppSpacing.s14,
                      backgroundColor: Colors.white24,
                    ),
                    Positioned(
                      left: AppSpacing.s18,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0052C2),
                            width: AppSpacing.s2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: AppSpacing.s14,
                          backgroundColor: Colors.white30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.h8,
              Expanded(
                child: Text(
                  '24 students submitted',
                  style: AppTextStyles.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.studentHomeworkDetail),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s24,
                    vertical: AppSpacing.s12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.s24),
                  ),
                  child: Text(
                    'Open Task',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String subject,
    required String title,
    required String professor,
    required String dueDate,
    required String status,
    required IconData icon,
    required String buttonLabel,
    bool isUrgent = false,
    bool isActive = false,
    bool isDeadlineStyle = false,
  }) {
    return Container(
      margin: AppSpacing.x28,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.redDot,
                  letterSpacing: 1.0,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DUE DATE',
                    style: AppTextStyles.manrope(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    dueDate,
                    style: AppTextStyles.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.v8,
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.darkSlate,
              height: 1.2,
            ),
          ),
          AppSpacing.v4,
          Text(
            'Uploaded by $professor',
            style: AppTextStyles.lexend(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.v20,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: AppColors.reportBorder,
              borderRadius: BorderRadius.circular(AppSpacing.s16),
            ),
            child: Row(
              children: [
                Container(
                  padding: AppSpacing.all8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.skyBlueLight
                        : (isDeadlineStyle
                              ? AppColors.amberLight
                              : Colors.white),
                    borderRadius: BorderRadius.circular(AppSpacing.s10),
                  ),
                  child: Icon(
                    isDeadlineStyle
                        ? Icons.access_time_filled_rounded
                        : (isActive
                              ? Icons.sticky_note_2_rounded
                              : Icons.chat_bubble_rounded),
                    color: isDeadlineStyle
                        ? AppColors.redDot
                        : (isActive
                              ? AppColors.primaryBrand
                              : const Color(0xFF475569)),
                    size: AppSpacing.s16,
                  ),
                ),
                AppSpacing.h12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDeadlineStyle ? 'DEADLINE' : 'STATUS',
                        style: AppTextStyles.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        status,
                        style: AppTextStyles.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isDeadlineStyle
                              ? AppColors.textPrimary
                              : AppColors.primaryBrand,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v20,
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.studentHomeworkDetail),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF0052C2)
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(AppSpacing.s16),
              ),
              child: Center(
                child: Text(
                  buttonLabel,
                  style: AppTextStyles.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isActive ? Colors.white : AppColors.primaryBrand,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrepGuideCard() {
    return Container(
      margin: AppSpacing.x28,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppSpacing.s32),
      ),
      child: Column(
        children: [
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.file_copy_rounded,
              color: AppColors.primaryBrand,
              size: AppSpacing.s32,
            ),
          ),
          AppSpacing.v24,
          Text(
            'Preparation Guide',
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            'Modern Literature finals study guide is now available for download.',
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.v24,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Download PDF',
                style: AppTextStyles.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
