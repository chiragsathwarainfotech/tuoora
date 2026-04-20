import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeeReportsScreen extends StatelessWidget {
  const FeeReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Fee Reports', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthlyRevenueCard(),
                    AppSpacing.v32,
                    _buildDefaulterOverviewSection(),
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

  Widget _buildMonthlyRevenueCard() {
    return Container(
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.all10,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFF1E40AF),
                  size: AppSpacing.s20,
                ),
              ),
              AppSpacing.h16,
              Text(
                'Current Month Revenue',
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          Text(
            '₹1,24,500.00',
            style: AppTextStyles.manrope(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF003D99),
            ),
          ),
          AppSpacing.v8,
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF10B981),
                size: 16,
              ),
              AppSpacing.h4,
              Text(
                '12.5% vs last month',
                style: AppTextStyles.lexend(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          AppSpacing.v32,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004CB3),
              foregroundColor: Colors.white,
              padding: AppSpacing.all16,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_download_outlined, size: 20),
                AppSpacing.h12,
                Text(
                  'Download Detailed PDF',
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaulterOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Defaulter Overview',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.instituteDefaultersList),
              child: Text(
                'View All',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E40AF),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.v20,
        _buildDefaulterItem(
          name: 'Julian Casablancas',
          studentId: 'FE-1024',
          amount: '₹4,500',
          daysOverdue: 12,
        ),
        AppSpacing.v12,
        _buildDefaulterItem(
          name: 'Albert Hammond',
          studentId: 'FE-0982',
          amount: '₹2,300',
          daysOverdue: 5,
        ),
        AppSpacing.v12,
        _buildDefaulterItem(
          name: 'Julian Casablancas',
          studentId: 'FE-1024',
          amount: '₹4,500',
          daysOverdue: 12,
        ),
        AppSpacing.v12,
        _buildDefaulterItem(
          name: 'Albert Hammond',
          studentId: 'FE-0982',
          amount: '₹2,300',
          daysOverdue: 5,
        ),
      ],
    );
  }

  Widget _buildDefaulterItem({
    required String name,
    required String studentId,
    required String amount,
    required int daysOverdue,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.scaffoldBg,
            child: Text(
              name[0],
              style: AppTextStyles.manrope(
                fontWeight: FontWeight.w800,
                color: AppColors.instAccentBlue,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'ID: $studentId',
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFEF4444),
                ),
              ),
              Text(
                '$daysOverdue days overdue',
                style: AppTextStyles.lexend(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
