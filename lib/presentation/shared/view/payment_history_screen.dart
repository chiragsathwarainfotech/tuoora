import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/widgets/payment_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:get/get.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final String title;
  const PaymentHistoryScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1F2937),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          title,
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _buildMonthHeader('October 2023'),
          const PaymentItemTile(
            title: 'Tuition - Term 1',
            date: 'Oct 02, 2023',
            ref: '#AE-9921',
            amount: '\$1,800.00',
          ),
          AppSpacing.v16,
          const PaymentItemTile(
            title: 'Library Overdue Fine',
            date: 'Oct 01, 2023',
            ref: '#AE-9850',
            amount: '\$15.00',
          ),
          AppSpacing.v32,
          _buildMonthHeader('September 2023'),
          const PaymentItemTile(
            title: 'Annual Sports Fee',
            date: 'Sept 15, 2023',
            ref: '#AE-8840',
            amount: '\$150.00',
          ),
          AppSpacing.v16,
          const PaymentItemTile(
            title: 'Lab Maintenance',
            date: 'Sept 10, 2023',
            ref: '#AE-8720',
            amount: '\$25.00',
          ),
          AppSpacing.v32,
          _buildMonthHeader('August 2023'),
          const PaymentItemTile(
            title: 'Registration Charges',
            date: 'Aug 01, 2023',
            ref: '#AE-8120',
            amount: '\$300.00',
          ),
          AppSpacing.v16,
          const PaymentItemTile(
            title: 'ID Card Replacement',
            date: 'Aug 01, 2023',
            ref: '#AE-8110',
            amount: '\$10.00',
          ),
          AppSpacing.v24,
        ],
      ),
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Text(
        month.toUpperCase(),
        style: AppTextStyles.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
