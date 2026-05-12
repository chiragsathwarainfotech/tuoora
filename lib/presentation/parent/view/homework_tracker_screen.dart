import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/widgets/task_card.dart';
import 'package:fee_easy/core/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeworkTrackerScreen extends StatelessWidget {
  const HomeworkTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Homework Tracker',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SectionHeader(
            title: 'TODAY',
            padding: EdgeInsets.only(bottom: AppSpacing.s16),
          ),
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Photosynthesis Lab Report',
                'subject': 'Biology',
                'status': 'Completed Today',
                'statusColor': AppColors.successGreen,
              },
            ),
            icon: Icons.science_outlined,
            iconColor: AppColors.primaryBrand,
            iconBgColor: AppColors.amberLight,
            title: 'Photosynthesis Lab Report',
            subject: 'Biology',
            statusText: 'Completed Today',
            statusColor: AppColors.successGreen,
            completed: true,
          ),
          AppSpacing.v12,
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Modern Literature Analysis',
                'subject': 'English',
                'status': 'Due at 11:59 PM',
                'statusColor': AppColors.orangeDue,
              },
            ),
            icon: Icons.menu_book,
            iconColor: AppColors.primaryBrand,
            iconBgColor: AppColors.primaryBrandLight,
            title: 'Modern Literature Analysis',
            subject: 'English',
            statusText: 'Due at 11:59 PM',
            statusColor: AppColors.orangeDue,
            progressValue: 0.8,
          ),
          AppSpacing.v32,
          const SectionHeader(
            title: 'UPCOMING',
            padding: EdgeInsets.only(bottom: AppSpacing.s16),
          ),
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Advanced Calculus: PS4',
                'subject': 'Mathematics',
                'status': 'Due in 2 days',
                'statusColor': AppColors.textSecondary,
              },
            ),
            icon: Icons.functions,
            iconColor: AppColors.primaryBrand,
            iconBgColor: AppColors.primaryBrandLight,
            title: 'Advanced Calculus: PS4',
            subject: 'Mathematics',
            statusText: 'Due in 2 days',
            statusColor: AppColors.textSecondary,
            progressValue: 0.5,
          ),
          AppSpacing.v12,
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Civil War Timeline Project',
                'subject': 'History',
                'status': 'Due in 4 days',
                'statusColor': AppColors.textSecondary,
              },
            ),
            icon: Icons.history_edu,
            iconColor: AppColors.primaryBrand,
            iconBgColor: AppColors.primaryBrandLight,
            title: 'Civil War Timeline Project',
            subject: 'History',
            statusText: 'Due in 4 days',
            statusColor: AppColors.textSecondary,
            progressValue: 0.2,
          ),
          AppSpacing.v12,
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Spanish Verb Conjugations',
                'subject': 'Spanish',
                'status': 'Assigned Today',
                'statusColor': AppColors.textSecondary,
              },
            ),
            icon: Icons.language,
            iconColor: const Color(0xFF0D9488),
            iconBgColor: const Color(0xFFF0FDFA),
            title: 'Spanish Verb Conjugations',
            subject: 'Spanish',
            statusText: 'Assigned Today',
            statusColor: AppColors.textSecondary,
            progressValue: 0.0,
          ),
          AppSpacing.v32,
          const SectionHeader(
            title: 'COMPLETED LAST WEEK',
            padding: EdgeInsets.only(bottom: AppSpacing.s16),
          ),
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Chemical Reactions Quiz',
                'subject': 'Chemistry',
                'status': 'Graded: 95/100',
                'statusColor': AppColors.successGreen,
              },
            ),
            icon: Icons.biotech,
            iconColor: AppColors.primaryBrand,
            iconBgColor: AppColors.amberLight,
            title: 'Chemical Reactions Quiz',
            subject: 'Chemistry',
            statusText: 'Graded: 95/100',
            statusColor: AppColors.successGreen,
            completed: true,
          ),
          AppSpacing.v12,
          TaskCard(
            onTap: () => Get.toNamed(
              AppRoutes.parentHomeworkDetail,
              arguments: const {
                'title': 'Perspective Drawing #3',
                'subject': 'Fine Arts',
                'status': 'Graded: 90/100',
                'statusColor': AppColors.successGreen,
              },
            ),
            icon: Icons.draw,
            iconColor: const Color(0xFFDB2777),
            iconBgColor: const Color(0xFFFDF2F8),
            title: 'Perspective Drawing #3',
            subject: 'Fine Arts',
            statusText: 'Graded: 90/100',
            statusColor: AppColors.successGreen,
            completed: true,
          ),
          AppSpacing.v24,
        ],
      ),
    );
  }
}

