import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
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
          AppSpacing.v32,
          _buildAnalyticsSection(),
          AppSpacing.v24,
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
                            color: const Color(0xFF1E3A8A),
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
