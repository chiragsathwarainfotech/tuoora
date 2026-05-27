import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/presentation/institute/controllers/batch_details_controller.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/presentation/institute/controllers/batch_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/institute_info_row.dart';
import 'package:tuoora/presentation/institute/widgets/institute_metric_card.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchDetailsScreen extends StatefulWidget {
  const BatchDetailsScreen({super.key});

  @override
  State<BatchDetailsScreen> createState() => _BatchDetailsScreenState();
}

class _BatchDetailsScreenState extends State<BatchDetailsScreen> {
  late BatchDetailsController controller;
  final BatchController batchController = Get.find<BatchController>();

  @override
  void initState() {
    super.initState();
    final BatchModel batch = Get.arguments;
    controller = Get.put(BatchDetailsController(batch), tag: batch.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.instBatchDetailsTitle,
              actions: [
                IconButton(
                  onPressed: () {
                    batchController.initEditMode(controller.batch);
                    Get.toNamed(AppRoutes.instituteEditBatch);
                  },
                  icon: const AppActionIcon(asset: AppImages.icEdit),
                ),
                IconButton(
                  onPressed: () => batchController.deleteBatchWithConfirmation(
                    controller.batch.id,
                  ),
                  icon: const AppActionIcon(asset: AppImages.icDelete),
                ),
                AppSpacing.h8,
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x16.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBatchHeader(),
                    AppSpacing.v32,
                    _buildCourseManagementSection(),
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

  Widget _buildBatchHeader() {
    final batch = controller.batch;
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s10,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.instActiveBatchTag,
                  style: AppTextStyles.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.h12,
              Text(
                'ID: #${batch.id.length > 4 ? batch.id.substring(0, 4) : batch.id}',
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            batch.title,
            style: AppTextStyles.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBrand,
            ),
          ),
          AppSpacing.v8,
          Text(
            batch.description,
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          AppSpacing.v24,
          Obx(
            () => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InstituteMetricCard(
                        label: AppStrings.instStudentsCountLabel,
                        value: '${controller.studentCount.value}',
                      ),
                    ),
                    AppSpacing.h12,
                    Expanded(
                      child: InstituteMetricCard(
                        label: AppStrings.instFeesPaidLabel,
                        value:
                            batch.totalExpected != null &&
                                double.tryParse(
                                      batch.totalExpected.toString(),
                                    ) !=
                                    0
                            ? '${((double.tryParse(batch.totalPaid?.toString() ?? '0') ?? 0) / (double.tryParse(batch.totalExpected.toString()) ?? 1) * 100).toStringAsFixed(0)}%'
                            : '0%',
                      ),
                    ),
                  ],
                ),
                AppSpacing.v12,
                SizedBox(
                  width: double.infinity,
                  child: InstituteMetricCard(
                    label: AppStrings.instTotalCollectionLabel,
                    value: '₹${batch.totalExpected?.toString() ?? '0'}',
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v24,
          InstituteInfoRow(
            icon: Icons.access_time_filled_rounded,
            text: batch.time,
          ),
          AppSpacing.v12,
          InstituteInfoRow(
            icon: Icons.calendar_month_rounded,
            text: batch.days.join(', '),
          ),
          AppSpacing.v12,
          const InstituteInfoRow(
            icon: Icons.person_rounded,
            text: 'Prof. Julian Archer',
          ),
        ],
      ),
    );
  }

  Widget _buildCourseManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instCourseManagementHeader,
          style: AppTextStyles.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v20,
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: [
            _buildManagementTile(
              icon: Icons.people_alt_rounded,
              title: AppStrings.instNavStudents,
              onTap: () => Get.toNamed(
                AppRoutes.instituteBatchStudents,
                arguments: controller.batch,
              ),
            ),
            _buildManagementTile(
              icon: Icons.assignment_rounded,
              title: 'Homework',
              onTap: () => Get.toNamed(
                AppRoutes.instituteBatchHomework,
                arguments: controller.batch,
              ),
            ),
            _buildManagementTile(
              icon: Icons.menu_book_rounded,
              title: 'Resources',
              onTap: () => Get.toNamed(
                AppRoutes.instituteBatchResources,
                arguments: controller.batch,
              ),
            ),
          ],
        ),
        AppSpacing.v16,
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: [
            _buildManagementTile(
              icon: Icons.checklist_rtl_rounded,
              title: AppStrings.instAttendanceTitle,
              onTap: () => Get.toNamed(
                AppRoutes.instituteMarkAttendance,
                arguments: controller.batch,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManagementTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.all12,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryBrand, size: 28),
            AppSpacing.v12,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
