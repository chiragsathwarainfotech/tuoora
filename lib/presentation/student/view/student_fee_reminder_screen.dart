import 'package:tuoora/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/student/controllers/fees_controller.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentFeeReminderScreen extends StatelessWidget {
  final bool isPaid;
  const StudentFeeReminderScreen({super.key, this.isPaid = false});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final bool paid = args?['isPaid'] ?? isPaid;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            StudentAppBar(
              title: paid
                  ? 'Payment received • ₹4,500'
                  : 'Fee reminder • ₹4,500 due 25 May',
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
          children: [
            _buildMainCard(paid),
            const SizedBox(height: AppSpacing.s16),
            _buildDetailsCard(paid),
            const SizedBox(height: AppSpacing.s16),
            if (!paid) _buildWarningCard(),
            const SizedBox(height: AppSpacing.s24),
            _buildActionButton(paid),
              ],
            ),
          ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMainCard(bool paid) {
    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: paid ? AppColors.studentPresentText : AppColors.studentTomorrowPillText,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.15,
              child: Text(
                '₹',
                style: AppTextStyles.manrope(
                  fontSize: 120,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  height: 1,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MAY 2026',
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '₹4,500',
                style: AppTextStyles.manrope(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              Text(
                paid ? 'Paid on 20 May 2026' : '25 May 2026 - 6 days left',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(bool paid) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          _buildDetailRow('Invoice no.', 'INV-2026-05', isValueBold: true),
          const Divider(height: 1, color: AppColors.borderGrey),
          _buildDetailRow(
            'Status',
            paid ? 'Paid' : 'Pending',
            valueColor: paid
                ? AppColors.studentPresentText
                : AppColors.studentTomorrowPillText,
            isValueBold: true,
          ),
          const Divider(height: 1, color: AppColors.borderGrey),
          _buildDetailRow('Due date', '25 May 2026', isValueBold: true),
          const Divider(height: 1, color: AppColors.borderGrey),
          _buildDetailRow('Posted', '2h ago', isValueBold: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isValueBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: isValueBold ? FontWeight.w500 : FontWeight.w400,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppSpacing.s8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textTertiary, width: 1.5),
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Text(
              'A late fee of ₹100 applies after the due date. Pay in cash at the institute or transfer via UPI.',
              style: AppTextStyles.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool paid) {
    return AppButton(
      label: 'Open invoice',
      icon: Icons.currency_rupee,
      backgroundColor: paid
          ? AppColors.studentPresentText
          : AppColors.studentTomorrowPillText,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: () {
        final FeesController controller = Get.find<FeesController>();
        if (controller.statements.isNotEmpty) {
          controller.openReceipt(
            controller.statements.firstWhere(
              (s) =>
                  paid ? s.status.name == 'paid' : s.status.name == 'pending',
              orElse: () => controller.statements.first,
            ),
          );
        } else {
          Get.toNamed(AppRoutes.studentFeeReceipt);
        }
      },
    );
  }
}
