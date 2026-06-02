import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';

class BillingHistoryScreen extends StatelessWidget {
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Billing History', isRoot: false),
            Expanded(
              child: ListView(
                padding: AppSpacing.all24,
                children: [
                  _buildBillingItem('INV-98231', 'SEP 24, 2023', '499.00'),
                  AppSpacing.v12,
                  _buildBillingItem('INV-97420', 'AUG 24, 2023', '499.00'),
                  AppSpacing.v12,
                  _buildBillingItem('INV-96511', 'JUL 24, 2023', '499.00'),
                  AppSpacing.v12,
                  _buildBillingItem('INV-95804', 'JUN 24, 2023', '499.00'),
                  AppSpacing.v12,
                  _buildBillingItem('INV-94239', 'MAY 24, 2023', '499.00'),
                  AppSpacing.v12,
                  _buildBillingItem('INV-93108', 'APR 24, 2023', '249.00'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingItem(String id, String date, String amount) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.background),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primaryBrand,
              size: AppSpacing.s24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: AppTextStyles.outfit(
                    fontSize: AppSpacing.s16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandAppBarColor,
                  ),
                ),
                Text(
                  date,
                  style: AppTextStyles.outfit(
                    fontSize: AppSpacing.s14,
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
                '₹$amount',
                style: AppTextStyles.outfit(
                  fontSize: AppSpacing.s16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandAppBarColor,
                ),
              ),
              AppSpacing.v4,
              Container(
                padding: AppSpacing.x8.add(AppSpacing.y4),
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s6),
                ),
                child: Text(
                  'PAID',
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.greenText,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
