import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_details_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_info_row.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_metric_card.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/common_dialog.dart';
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
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.instAccentBlue,
                  ),
                ),
                IconButton(
                  onPressed: () => _showDeleteBatchConfirmation(context),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFD92D20),
                  ),
                ),
                AppSpacing.h8,
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
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
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
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
                  color: AppColors.instBatchTagBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.instActiveBatchTag,
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.instBatchTagText,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.h12,
              Text(
                'ID: #${batch.id.length > 4 ? batch.id.substring(0, 4) : batch.id}',
                style: AppTextStyles.manrope(
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
            style: AppTextStyles.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.instPrimaryBlue,
            ),
          ),
          AppSpacing.v8,
          Text(
            batch.description,
            style: AppTextStyles.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          AppSpacing.v24,
          Row(
            children: [
              const Expanded(child: InstituteMetricCard(label: AppStrings.instStudentsCountLabel, value: '24')),
              AppSpacing.h12,
              const Expanded(child: InstituteMetricCard(label: AppStrings.instFeesPaidLabel, value: '85%')),
              AppSpacing.h12,
              const Expanded(child: InstituteMetricCard(label: AppStrings.instTotalCollectionLabel, value: '₹60k')),
            ],
          ),
          AppSpacing.v24,
          const InstituteInfoRow(
            icon: Icons.access_time_filled_rounded,
            text: '04:00 PM - 05:30 PM',
          ),
          AppSpacing.v12,
          const InstituteInfoRow(
            icon: Icons.calendar_month_rounded,
            text: 'Mon, Wed, Fri',
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
          style: AppTextStyles.manrope(
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
            Icon(icon, color: AppColors.instPrimaryBlue, size: 28),
            AppSpacing.v12,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.manrope(
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

  void _showDeleteBatchConfirmation(BuildContext context) {
    CommonDialog.show(
      title: AppStrings.instDeleteBatchTitle,
      description: AppStrings.instDeleteBatchConfirm,
      icon: Icons.delete_forever_rounded,
      confirmText: AppStrings.instDeleteConfirmBtn,
      onConfirm: () {
        batchController.deleteBatch(controller.batch.id);
        Get.back(); // go back from details screen
      },
    );
  }
}
