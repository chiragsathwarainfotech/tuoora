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
import 'package:tuoora/core/widgets/status_badge.dart';
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
                padding: AppSpacing.x16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBatchHeader(),
                    AppSpacing.v24,
                    _buildCourseManagementSection(),
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
      padding: AppSpacing.cardPadding,
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
              StatusBadge.fromLabel(AppStrings.instActiveBatchTag),
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
              color: AppColors.textPrimary,
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
          if (batch.classroom != null &&
              batch.classroom!.trim().isNotEmpty) ...[
            AppSpacing.v12,
            InstituteInfoRow(
              icon: Icons.location_on_rounded,
              text: batch.classroom!,
            ),
          ],
          AppSpacing.v12,
          const InstituteInfoRow(
            icon: Icons.person_rounded,
            text: 'Prof. Julian Archer',
          ),
        ],
      ),
    );
  }

  static const List<Color> _accentPalette = <Color>[
    AppColors.instBrandOrange,
    AppColors.successGreen,
    AppColors.orangeTag,
    AppColors.subjectPhysics,
    AppColors.greenLight,
  ];

  Widget _buildCourseManagementSection() {
    final tiles = <_ManagementTileData>[
      _ManagementTileData(
        icon: Icons.people_alt_rounded,
        title: AppStrings.instNavStudents,
        onTap: () => Get.toNamed(
          AppRoutes.instituteBatchStudents,
          arguments: controller.batch,
        ),
      ),
      _ManagementTileData(
        icon: Icons.assignment_rounded,
        title: 'Homework',
        onTap: () => Get.toNamed(
          AppRoutes.instituteBatchHomework,
          arguments: controller.batch,
        ),
      ),
      _ManagementTileData(
        icon: Icons.checklist_rtl_rounded,
        title: AppStrings.instAttendanceTitle,
        onTap: () => Get.toNamed(
          AppRoutes.instituteMarkAttendance,
          arguments: controller.batch,
        ),
      ),
      _ManagementTileData(
        icon: Icons.menu_book_rounded,
        title: 'Resources',
        onTap: () => Get.toNamed(
          AppRoutes.instituteBatchResources,
          arguments: controller.batch,
        ),
      ),
    ];

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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tiles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final tile = tiles[index];
            final accent = _accentPalette[index % _accentPalette.length];
            return _buildManagementTile(
              icon: tile.icon,
              title: tile.title,
              onTap: tile.onTap,
              accent: accent,
            );
          },
        ),
      ],
    );
  }

  Widget _buildManagementTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color accent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
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
            Icon(icon, color: accent, size: 48),
            AppSpacing.v12,
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementTileData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ManagementTileData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
