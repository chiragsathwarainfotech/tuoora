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
          _buildHeader(),
          AppSpacing.v32,
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instActiveBatchesSubtitle,
          style: AppTextStyles.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildBatchCard(BatchModel batch) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.instituteBatchDetails),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
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
                                  AppSpacing.v8,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.s10,
                                      vertical: AppSpacing.s6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: batch.statusBg,
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.s8,
                                      ),
                                    ),
                                    child: Text(
                                      batch.statusLabel,
                                      style: AppTextStyles.manrope(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: batch.statusTextColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.h8,
                            IconButton(
                              onPressed: () => _showDeleteConfirmation(batch),
                              icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.redAccent, size: 22),
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                            ),
                          ],
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
                        AppSpacing.v16,
                        const Divider(color: AppColors.divider),
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
                        AppSpacing.v20,
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004CB2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.s10,
                                    ),
                                  ),
                                  padding: AppSpacing.y12,
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppStrings.instAssignBtn,
                                  style: AppTextStyles.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            AppSpacing.h12,
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFD1D5DB),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.s10,
                                    ),
                                  ),
                                  padding: AppSpacing.y12,
                                ),
                                child: Text(
                                  AppStrings.instEditBtn,
                                  style: AppTextStyles.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.instAccentBlue,
                                  ),
                                ),
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

  void _showDeleteConfirmation(BatchModel batch) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: AppSpacing.all24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: AppSpacing.all16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_forever_rounded,
                    color: Colors.redAccent, size: 32),
              ),
              AppSpacing.v24,
              Text(
                'Delete Batch?',
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v12,
              Text(
                'Are you sure you want to delete "${batch.title}"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.v32,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: AppSpacing.y16,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.deleteBatch(batch.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: AppSpacing.y16,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Delete',
                        style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
