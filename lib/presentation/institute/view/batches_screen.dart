import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

class BatchesScreen extends GetView<BatchController> {
  const BatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.all24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.batchesList.length,
              separatorBuilder: (context, index) => AppSpacing.v16,
              itemBuilder: (context, index) {
                final batch = controller.batchesList[index];
                return _buildBatchCard(batch);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard(BatchModel batch) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.instituteBatchDetails, arguments: batch),
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
                Container(width: AppSpacing.s4, color: batch.leftBorderColor),
                Expanded(
                  child: Padding(
                    padding: AppSpacing.all20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          batch.title,
                          style: AppTextStyles.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepBlue,
                          ),
                        ),
                        AppSpacing.v4,
                        Text(
                          batch.subject,
                          style: AppTextStyles.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.instAccentBlue,
                          ),
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
                              batch.time,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
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
                              batch.studentCount,
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
                              batch.location,
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
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
}
