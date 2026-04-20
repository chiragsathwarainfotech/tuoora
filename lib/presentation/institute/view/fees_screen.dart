import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class InstituteFeesScreen extends StatelessWidget {
  const InstituteFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.x24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.v16,
          _buildTotalCollectedCard(),
          AppSpacing.v16,
          _buildTotalPendingCard(),
          AppSpacing.v16,
          _buildFinancialReportCard(),
          AppSpacing.v32,
          _buildRegistryHeader(),
          AppSpacing.v16,
          _buildRegistryList(),
          AppSpacing.v32,
        ],
      ),
    );
  }

  Widget _buildTotalCollectedCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.instFeesCollectedBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.instFeesCollectedBg.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, AppSpacing.s8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.instTotalCollected,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.instTotalCollectedAmount,
                style: AppTextStyles.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: AppSpacing.x10.add(AppSpacing.y6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: AppSpacing.s16,
                    ),
                    AppSpacing.h4,
                    Text(
                      '12%',
                      style: AppTextStyles.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPendingCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.instTotalPending,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.instTotalPendingAmount,
                style: AppTextStyles.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '42 Invoices',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.redDot,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialReportCard() {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.instFeesReportBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: AppColors.instFeesCollectedBg,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.instFinancialReport,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.instPrimaryBlue,
                  ),
                ),
                Text(
                  AppStrings.instMonthlyBreakdown,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.instPrimaryBlue.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.instFeesDownloadBtn,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: AppSpacing.x16.add(AppSpacing.y12),
            ),
            child: const Icon(
              Icons.download_rounded,
              color: Colors.white,
              size: AppSpacing.s20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.instFeeRegistry,
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.instituteRecordFee),
          child: Container(
            padding: AppSpacing.all8,
            decoration: BoxDecoration(
              color: AppColors.instAccentBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: AppSpacing.s20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistryList() {
    final controller = Get.find<InstituteController>();
    return Obx(
      () => Column(
        children: controller.feeRecords.map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s12),
            child: _buildFeeItem(
              record.studentName,
              record.amount,
              record.status,
              record.statusBg,
              record.statusText,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeeItem(
    String name,
    String amount,
    String status,
    Color statusBg,
    Color statusText,
  ) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.instFeesAvatarBg,
            child: Text(
              name[0],
              style: const TextStyle(color: AppColors.textSecondary),
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
                Text(
                  amount,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: AppSpacing.x12.add(AppSpacing.y6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: AppTextStyles.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: statusText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
