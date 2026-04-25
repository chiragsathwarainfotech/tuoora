import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reports_controller.dart';

class DefaultersListScreen extends GetView<ReportsController> {
  const DefaultersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Defaulters List', isRoot: false),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: AppSpacing.all24,
                  itemCount: controller.defaulters.length,
                  separatorBuilder: (context, index) => AppSpacing.v12,
                  itemBuilder: (context, index) {
                    final student = controller.defaulters[index];
                    return _buildDefaulterItem(
                      name: student['name'],
                      studentId: student['id'],
                      amount: student['amount'],
                      daysOverdue: student['daysOverdue'],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
        border: Border.all(color: AppColors.divider),
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
                  color: AppColors.errorRed,
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
