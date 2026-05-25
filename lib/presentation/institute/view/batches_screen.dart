import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/batch_controller.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/common_state_widget.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';

class BatchesScreen extends StatefulWidget {
  const BatchesScreen({super.key});

  @override
  State<BatchesScreen> createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  final controller = Get.find<BatchController>();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.batchesList.isEmpty) {
        controller.loadBatches(isRefresh: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadBatches(isRefresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                InstituteAppBar(
                  title: AppStrings.instNavBatches,
                  onBackTap: () => Get.back(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.loadBatches(isRefresh: true),
                    color: AppColors.primaryBrand,
                    child: Obx(() {
                      return CommonStateWidget(
                        isLoading: controller.isLoading.value,
                        isEmpty: controller.batchesList.isEmpty,
                        emptyTitle: 'No Batches Found',
                        emptySubtitle:
                            'Tap the + button to create your first batch and start managing students.',
                        emptyIcon: Icons.school_outlined,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: AppSpacing.all24,
                          itemCount:
                              controller.batchesList.length +
                              (controller.isMoreLoading.value ? 1 : 0),
                          separatorBuilder: (context, index) => AppSpacing.v16,
                          itemBuilder: (context, index) {
                            if (index < controller.batchesList.length) {
                              final batch = controller.batchesList[index];
                              return _buildBatchCard(batch);
                            } else {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CommonLoading(
                                    size: 20,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.initAddMode();
          Get.toNamed(AppRoutes.instituteAddBatch);
        },
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }

  Widget _buildBatchCard(BatchModel batch) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.instituteBatchDetails, arguments: batch),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
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
                          children: [
                            Expanded(
                              child: Text(
                                batch.title,
                                style: AppTextStyles.manrope(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryBrand,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: batch.statusBg.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                batch.statusLabel,
                                style: AppTextStyles.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: batch.statusBg,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.v4,
                        Text(
                          batch.subject,
                          style: AppTextStyles.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBrand,
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
                              color: AppColors.primaryBrand,
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
                              color: AppColors.background,
                            ),
                            AppSpacing.h16,
                            Text(
                              'â‚¹${batch.baseFee.toStringAsFixed(0)}',
                              style: AppTextStyles.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBrand,
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
