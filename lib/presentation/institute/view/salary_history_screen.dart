import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';

class SalaryHistoryScreen extends StatelessWidget {
  const SalaryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Salary History'),
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.all24,
                itemCount: _mockSalaries.length,
                separatorBuilder: (_, _) => AppSpacing.v16,
                itemBuilder: (context, index) {
                  final salary = _mockSalaries[index];
                  return _buildSalaryCard(salary);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryCard(Map<String, dynamic> salary) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: const BoxDecoration(
              color: AppColors.primaryBrandLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payments_rounded,
              color: AppColors.primaryBrand,
              size: 24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salary['month'],
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  salary['date'],
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            salary['amount'],
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _mockSalaries = [
  {
    'month': 'October 2023',
    'date': 'Paid on Oct 28, 2023',
    'amount': '₹3,500.00',
    'isEven': true,
  },
  {
    'month': 'September 2023',
    'date': 'Paid on Sep 28, 2023',
    'amount': '₹3,500.00',
    'isEven': true,
  },
  {
    'month': 'August 2023',
    'date': 'Paid on Aug 27, 2023',
    'amount': '₹3,500.00',
    'isEven': false,
  },
  {
    'month': 'July 2023',
    'date': 'Paid on Jul 28, 2023',
    'amount': '₹3,500.00',
    'isEven': true,
  },
  {
    'month': 'June 2023',
    'date': 'Paid on Jun 28, 2023',
    'amount': '₹3,200.00',
    'isEven': false,
  },
];
