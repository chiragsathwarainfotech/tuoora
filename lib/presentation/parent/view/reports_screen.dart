import 'package:fee_easy/core/widgets/parent_bottom_nav.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/widgets/portal_app_bar.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  final bool showBottomNav;
  const ReportsScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      padding: AppSpacing.x24.add(AppSpacing.y32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          AppSpacing.v32,
          _buildFinancialOverviewCard(),
          AppSpacing.v24,
          _buildEngagementCard(),
          AppSpacing.v24,
          _buildAcademicSuccessCard(),
          AppSpacing.v24,
          _buildInsightBanner(),
          AppSpacing.v40,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PortalAppBar(
        title: AppStrings.appName,
        profileRoute: AppRoutes.parentStudentProfile,
        notificationsRoute: AppRoutes.parentUpdates,
      ),
      body: content,
      bottomNavigationBar: showBottomNav
          ? const ParentBottomNav(currentIndex: 1)
          : null,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.academicSynthesis,
          style: AppTextStyles.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v8,
        Text(
          AppStrings.reportTermSubtitle,
          style: AppTextStyles.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          ),
        ),
        AppSpacing.v20,
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined, size: AppSpacing.s18),
          label: Text(
            AppStrings.exportPdf.toUpperCase(),
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0056D2),
            foregroundColor: AppColors.white,
            padding: AppSpacing.x20.add(AppSpacing.y12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialOverviewCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s32),
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
                AppStrings.financialOverviewLabel,
                style: AppTextStyles.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s12,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(AppSpacing.s12),
                ),
                child: Text(
                  AppStrings.partialPayment.toUpperCase(),
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            AppStrings.feeStatus,
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF334155),
            ),
          ),
          AppSpacing.v24,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹4,250',
                style: AppTextStyles.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.h8,
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                child: Text(
                  '/ ₹6,000 total',
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '71% Paid',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.s8),
            child: LinearProgressIndicator(
              value: 0.71,
              minHeight: AppSpacing.s10,
              backgroundColor: AppColors.reportBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBrand,
              ),
            ),
          ),
          AppSpacing.v24,
          Row(
            children: [
              _buildInfoBox('Next Due Date', 'Oct 15, 2024', false),
              AppSpacing.h16,
              _buildInfoBox('Balance Outstanding', '₹1,750.00', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, bool isAlert) {
    return Expanded(
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppSpacing.s20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.lexend(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.v4,
            Text(
              value,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isAlert ? const Color(0xFFDC2626) : AppColors.darkSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.engagementLabel,
            style: AppTextStyles.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBrand,
              letterSpacing: 1.0,
            ),
          ),
          AppSpacing.v12,
          Text(
            AppStrings.attendanceInsights,
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF334155),
            ),
          ),
          AppSpacing.v32,
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: AppSpacing.s140,
                  height: AppSpacing.s140,
                  child: const CommonLoading(
                    value: 0.95,
                    strokeWidth: AppSpacing.s14,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '95%',
                      style: AppTextStyles.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkSlate,
                      ),
                    ),
                    Text(
                      'PRESENT',
                      style: AppTextStyles.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.v32,
          Center(
            child: Text(
              'Exceeding the school average of 91.4%\nthis semester.',
              style: AppTextStyles.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF475569),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.v20,
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.show_chart,
                  color: AppColors.primaryBrand,
                  size: AppSpacing.s16,
                ),
                AppSpacing.h8,
                Text(
                  '+3.2% vs Last Month',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicSuccessCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.academicSuccessLabel,
            style: AppTextStyles.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBrand,
              letterSpacing: 1.0,
            ),
          ),
          AppSpacing.v12,
          Text(
            AppStrings.homeworkCompletionRate,
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF334155),
            ),
          ),
          AppSpacing.v16,
          Text(
            'Consistent submission patterns across all 8 subjects. Outstanding performance in Mathematics and Physics.',
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
              height: 1.5,
            ),
          ),
          AppSpacing.v32,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '98.5%',
                    style: AppTextStyles.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: AppSpacing.s8,
                        height: AppSpacing.s8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBrand,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacing.h6,
                      Text(
                        'SUCCESS RATE',
                        style: AppTextStyles.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              _buildMiniStat(Icons.check_circle_rounded, '42 Assigned'),
              AppSpacing.h16,
              _buildMiniStat(Icons.check_circle_rounded, '41 Completed'),
            ],
          ),
          AppSpacing.v32,
          _buildSubjectBreakdown(),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBrand, size: AppSpacing.s18),
        AppSpacing.v6,
        Text(
          label.split(' ')[0],
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label.split(' ')[1],
          style: AppTextStyles.lexend(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectBreakdown() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBrand, Color(0xFF001F4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.s24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.subjectBreakdown,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          AppSpacing.v20,
          _buildSubjectRow('Mathematics', 1.0),
          AppSpacing.v20,
          _buildSubjectRow('English Literature', 0.96),
          AppSpacing.v20,
          _buildSubjectRow('Physics', 1.0),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(String title, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppColors.white,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: AppTextStyles.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        AppSpacing.v8,
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.s4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: AppSpacing.s4,
            backgroundColor: AppColors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightBanner() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.reportBorder,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        border: const Border(
          left: BorderSide(color: AppColors.primaryBrand, width: AppSpacing.s6),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.primaryBrand,
            size: AppSpacing.s28,
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.highCorrelationInsight,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkSlate,
                  ),
                ),
                AppSpacing.v8,
                Text(
                  'There is a strong positive correlation between your 98.5% homework completion rate and the improved quiz scores in Science.',
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF475569),
                    height: 1.5,
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
