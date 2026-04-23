import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
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
      width: double.infinity,
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
            AppStrings.instCurrentMonthCollected,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.v12,
          Text(
            AppStrings.instTotalCollectedAmount,
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
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
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Get.snackbar('Download', 'Financial report download started...');
          },
          child: Container(
            padding: AppSpacing.all8,
            decoration: BoxDecoration(
              color: AppColors.instFeesCollectedBg,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: AppColors.borderLightGray, blurRadius: 12),
              ],
            ),
            child: const Icon(Icons.download, color: Colors.white, size: 26),
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
              record.studentId,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeeItem(String name, String amount, String studentId) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      studentId,
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
