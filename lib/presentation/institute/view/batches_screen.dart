import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_drawer.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fee_easy/presentation/institute/widgets/institute_root_scaffold.dart';

class BatchesScreen extends StatelessWidget {
  final bool showShell;
  const BatchesScreen({super.key, this.showShell = true});

  @override
  Widget build(BuildContext context) {
    return InstituteRootScaffold(
      title: 'Active Batches',
      currentIndex: 2,
      showShell: showShell,
      body: SingleChildScrollView(
        padding: AppSpacing.all24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            AppSpacing.v32,
            _buildBatchCard(
              'Mathematics - 10th Std',
              '08:00 AM - 09:30 AM',
              '42 Students',
              'Lab A',
              AppStrings.instStatusHighCapacity,
              AppColors.instStatusHighCapacityBg,
              AppColors.instBorderHighCapacity,
            ),
            AppSpacing.v16,
            _buildBatchCard(
              'Physics - Advanced',
              '10:30 AM - 12:00 PM',
              '50 Students',
              'Hall 3',
              AppStrings.instStatusFull,
              AppColors.instStatusFullBg,
              AppColors.instBorderFull,
            ),
            AppSpacing.v16,
            _buildBatchCard(
              'Literature 101',
              '02:00 PM - 03:30 PM',
              '18 Students',
              'Room 12',
              AppStrings.instStatusOpen,
              AppColors.instStatusOpenBg,
              AppColors.instBorderOpen,
              statusTextColor: AppColors.instStatusOpenText,
            ),
            AppSpacing.v32,
            _buildAnalyticsSection(),
            AppSpacing.v24,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instActiveBatchesSubtitle,
          style: AppTextStyles.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildBatchCard(
    String title,
    String time,
    String students,
    String location,
    String statusLabel,
    Color statusBg,
    Color leftBorderColor, {
    Color statusTextColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.instituteBatchDetails),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.s16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: AppSpacing.s10,
              offset: const Offset(0, AppSpacing.s4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.s16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: AppSpacing.s4, color: leftBorderColor),
                Expanded(
                  child: Padding(
                    padding: AppSpacing.all20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: AppTextStyles.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                            AppSpacing.h8,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s10,
                                vertical: AppSpacing.s6,
                              ),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.s8,
                                ),
                              ),
                              child: Text(
                                statusLabel,
                                style: AppTextStyles.manrope(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: statusTextColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.v12,
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: AppSpacing.s16,
                              color: AppColors.textSecondary,
                            ),
                            AppSpacing.h8,
                            Text(
                              time,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.v16,
                        const Divider(color: AppColors.divider),
                        AppSpacing.v12,
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: AppSpacing.s18,
                              color: AppColors.instAccentBlue,
                            ),
                            AppSpacing.h8,
                            Text(
                              students,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            AppSpacing.h16,
                            Container(
                              width: AppSpacing.s2,
                              height: AppSpacing.s16,
                              color: AppColors.divider,
                            ),
                            AppSpacing.h16,
                            Icon(
                              Icons.location_on_outlined,
                              size: AppSpacing.s18,
                              color: AppColors.instAccentBlue,
                            ),
                            AppSpacing.h8,
                            Text(
                              location,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.v20,
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004CB2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.s10,
                                    ),
                                  ),
                                  padding: AppSpacing.y12,
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppStrings.instAssignBtn,
                                  style: AppTextStyles.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            AppSpacing.h12,
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFD1D5DB),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.s10,
                                    ),
                                  ),
                                  padding: AppSpacing.y12,
                                ),
                                child: Text(
                                  AppStrings.instEditBtn,
                                  style: AppTextStyles.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.instAccentBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(AppSpacing.s24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.instBatchAnalytics,
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            AppStrings.instRealTimeResource,
            style: AppTextStyles.lexend(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.v32,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.instOverallCapacity,
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDarkGrey,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '84%',
                style: AppTextStyles.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.s10),
            child: const LinearProgressIndicator(
              value: 0.84,
              minHeight: AppSpacing.s12,
              backgroundColor: Color(0xFFE5E7EB),
              color: Color(0xFF005AC1),
            ),
          ),
          AppSpacing.v12,
          Text(
            AppStrings.instSeatOccupancy,
            style: AppTextStyles.lexend(
              fontSize: 12,
              color: AppColors.textSecondary,
            ).copyWith(fontStyle: FontStyle.italic),
          ),
          AppSpacing.v32,
          Row(
            children: [
              Expanded(
                child: _buildSmallAnalyticsCard(
                  AppStrings.instAvgAttendanceLabelAlt,
                  '92.4%',
                  const Color(0xFF1E40AF),
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: _buildSmallAnalyticsCard(
                  AppStrings.instResourcesLabel,
                  AppStrings.instResourceOptimal,
                  const Color(0xFF7C2D12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAnalyticsCard(
    String label,
    String value,
    Color valueColor,
  ) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s8,
            offset: const Offset(0, AppSpacing.s2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v6,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
