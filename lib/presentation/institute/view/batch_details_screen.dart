import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchDetailsScreen extends StatelessWidget {
  const BatchDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Batch Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBatchHeader(),
                    AppSpacing.v16,
                    _buildEnrollmentSection(),
                    AppSpacing.v16,
                    _buildAttendanceCard(),
                    AppSpacing.v16,
                    _buildStudentListSection(),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchHeader() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s10,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.instBatchTagBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.instActiveBatchTag,
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.instBatchTagText,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.h12,
              Text(
                'ID: #BCH-2024-08',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            'Advanced Mathematics',
            style: AppTextStyles.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.instPrimaryBlue,
            ),
          ),
          AppSpacing.v8,
          Text(
            'Advanced calculus and linear algebra for senior students. Sessions held thrice a week in the main auditorium.',
            style: AppTextStyles.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          AppSpacing.v24,
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniCard(
                  AppStrings.instStudentsCountLabel,
                  '24',
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: _buildMetricMiniCard(
                  AppStrings.instFeesPaidLabel,
                  '85%',
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          _buildInfoChip(Icons.access_time_filled, '04:00 PM - 05:30 PM'),
          AppSpacing.v8,
          _buildInfoChip(Icons.calendar_month, 'Mon, Wed, Fri'),
          AppSpacing.v8,
          _buildInfoChip(Icons.person, 'Prof. Julian Archer'),
        ],
      ),
    );
  }

  Widget _buildMetricMiniCard(String label, String value) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.v4,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.instAccentBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.s16, color: AppColors.instPrimaryBlue),
          AppSpacing.h12,
          Text(
            text,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.instStudentEnrollmentLabel,
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v16,
          _buildAvatarStack(),
          AppSpacing.v16,
          Text(
            '24 students currently enrolled. The batch capacity is 30 students. 6 seats remaining.',
            style: AppTextStyles.lexend(
              fontSize: 13,
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          AppSpacing.v24,
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.instituteAddStudent),
            icon: const Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: AppSpacing.s20,
            ),
            label: Text(
              AppStrings.instAddStudentToBatch,
              style: AppTextStyles.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.instAccentBlue,
              padding: AppSpacing.y16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Row(
      children: [
        for (int i = 0; i < 4; i++)
          Transform.translate(
            offset: Offset(i * -12, 0),
            child: Container(
              width: AppSpacing.s40,
              height: AppSpacing.s40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: AppSpacing.s2),
                image: DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?u=student_$i'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        Transform.translate(
          offset: const Offset(4 * -12, 0),
          child: Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.instAccentBlue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: AppSpacing.s2),
            ),
            child: Center(
              child: Text(
                '+20',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: AppColors.instAccentBlue,
            size: AppSpacing.s32,
          ),
          AppSpacing.v16,
          Text(
            '92% Attendance',
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            AppStrings.instAverageAttendance,
            textAlign: TextAlign.center,
            style: AppTextStyles.lexend(
              fontSize: 13,
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          AppSpacing.v24,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.92,
              minHeight: AppSpacing.s8,
              backgroundColor: AppColors.divider,
              color: AppColors.instPrimaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.instStudentListLabel,
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          _buildStudentItem(
            'Aarav Sharma',
            'Roll No: #M-001 • Joined 12 Jan',
            'https://i.pravatar.cc/150?u=aarav',
          ),
          _buildStudentItem(
            'Ishani Verma',
            'Roll No: #M-002 • Joined 14 Jan',
            'https://i.pravatar.cc/150?u=ishani',
          ),
          _buildStudentItem(
            'Rohan Das',
            'Roll No: #M-003 • Joined 15 Jan',
            'https://i.pravatar.cc/150?u=rohan',
          ),
          _buildStudentItem(
            'Priya Nair',
            'Roll No: #M-004 • Joined 18 Jan',
            'https://i.pravatar.cc/150?u=priya',
          ),
          AppSpacing.v16,
          Center(
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.instituteStudents),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All 24 Students',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.instAccentBlue,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.instAccentBlue,
                    size: AppSpacing.s20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(String name, String subText, String avatarUrl) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.instituteStudentProfile),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: AppSpacing.y12,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.s48,
              height: AppSpacing.s48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v2,
                  Text(
                    subText,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textTertiary,
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
