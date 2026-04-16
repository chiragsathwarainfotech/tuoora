import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_root_scaffold.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class InstituteDashboard extends StatelessWidget {
  final bool showShell;
  const InstituteDashboard({super.key, this.showShell = true});

  @override
  Widget build(BuildContext context) {
    return InstituteRootScaffold(
      title: 'Fee Easy',
      currentIndex: 0,
      showShell: showShell,
      body: SingleChildScrollView(
        padding: AppSpacing.all24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderTitles(),
            AppSpacing.v16,
            _buildTotalStudentsCard(),
            AppSpacing.v16,
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    AppStrings.instPendingFees,
                    '\$4,200',
                    Icons.assignment_late_outlined,
                    AppColors.orangeTag,
                  ),
                ),
                AppSpacing.h16,
                Expanded(
                  child: _buildMetricCard(
                    AppStrings.instAttendance,
                    '85%',
                    Icons.calendar_today_outlined,
                    AppColors.instAccentBlue,
                  ),
                ),
              ],
            ),
            AppSpacing.v32,
            _buildSectionHeader(AppStrings.instActiveBatches, true),
            AppSpacing.v16,
            _buildBatchItem(
              'Advanced Physics',
              'Batch A-1 • 42 Students',
              Icons.science,
              AppColors.instLightBlueBg,
              AppColors.instAccentBlue,
            ),
            AppSpacing.v12,
            _buildBatchItem(
              'Calculus II',
              'Batch B-4 • 38 Students',
              Icons.functions,
              AppColors.instPurpleBg.withValues(alpha: 0.4),
              AppColors.instPurpleBlue,
            ),
            AppSpacing.v32,
            _buildUpcomingCollectionCard(),
            AppSpacing.v32,
            _buildStudentListHeader(),
            AppSpacing.v16,
            _buildDashboardStudentItem(
              'Aarav Sharma',
              'Roll No: #M-001 • Joined 12 Jan',
              'https://i.pravatar.cc/150?u=aarav',
            ),
            _buildDashboardStudentItem(
              'Ishani Verma',
              'Roll No: #M-002 • Joined 14 Jan',
              'https://i.pravatar.cc/150?u=ishani',
            ),
            _buildDashboardStudentItem(
              'Rohan Das',
              'Roll No: #M-003 • Joined 15 Jan',
              'https://i.pravatar.cc/150?u=rohan',
            ),
            AppSpacing.v32,
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instOverview,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.instAccentBlue,
          ),
        ),
        AppSpacing.v4,
        Text(
          AppStrings.instSummary,
          style: AppTextStyles.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalStudentsCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.instCardBlue, // Deep blue gradient base
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.people_alt,
            color: Colors.white70,
            size: AppSpacing.s24,
          ),
          AppSpacing.v12,
          Text(
            AppStrings.instTotalStudents,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          AppSpacing.v4,
          Text(
            '1,240',
            style: AppTextStyles.manrope(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.s24),
          AppSpacing.v24,
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v6,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool showViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: () => Get.offAllNamed(AppRoutes.instituteBatches),
            child: Text(
              'View All',
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2B5BCC),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBatchItem(
    String title,
    String subtitle,
    IconData icon,
    Color bg,
    Color iconColor,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.instituteBatchDetails),
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.s48,
              height: AppSpacing.s48,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: AppSpacing.s24),
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    subtitle,
                    style: AppTextStyles.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCollectionCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, AppSpacing.s8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.instUpcomingCollection,
                      style: AppTextStyles.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      AppStrings.instScheduledFor,
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s10,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.instHighPriority,
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.orangeTag,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          Row(children: [_buildAvatarStack(), const Spacer()]),
          AppSpacing.v24,
          Container(
            width: double.infinity,
            padding: AppSpacing.y16,
            decoration: BoxDecoration(
              color: AppColors.instSendBtnBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: AppSpacing.s18,
                ),
                AppSpacing.h8,
                Text(
                  AppStrings.instSendReminders,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      height: AppSpacing.s32,
      child: Row(
        children: [
          _buildAvatarItem(const Color(0xFF475569), 'student1'),
          Transform.translate(
            offset: const Offset(-AppSpacing.s8, 0),
            child: _buildAvatarItem(const Color(0xFF1E293B), 'student2'),
          ),
          Transform.translate(
            offset: const Offset(-AppSpacing.s16, 0),
            child: _buildAvatarItem(const Color(0xFFF97316), 'student3'),
          ),
          Transform.translate(
            offset: const Offset(-AppSpacing.s24, 0),
            child: Container(
              width: AppSpacing.s32,
              height: AppSpacing.s32,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: AppSpacing.s2),
              ),
              child: Center(
                child: Text(
                  '+12',
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(Color color, String seed) {
    return Container(
      width: AppSpacing.s32,
      height: AppSpacing.s32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: AppSpacing.s2),
        image: DecorationImage(
          image: NetworkImage('https://i.pravatar.cc/150?u=$seed'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStudentListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.instStudentListLabel,
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.instituteStudents),
          child: Text(
            'View All',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B5BCC),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardStudentItem(
    String name,
    String subText,
    String avatarUrl,
  ) {
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
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
