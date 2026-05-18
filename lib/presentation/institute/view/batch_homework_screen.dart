import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/homework_controller.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/presentation/institute/models/homework_model.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/shared/widgets/common_state_widget.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BatchHomeworkScreen extends StatelessWidget {
  const BatchHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BatchModel batch = Get.arguments;
    final controller = Get.put(HomeworkController(batch), tag: batch.id);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.instBatchHomeworkTitle,
              onBackTap: () => Get.back(),
            ),
            Padding(
              padding: AppSpacing.x24.add(AppSpacing.y16),
              child: _buildSearchBar(controller),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchHomeworks(),
                child: Obx(() {
                  return CommonStateWidget(
                    isLoading: controller.isLoading.value,
                    isEmpty: controller.filteredHomeworks.isEmpty,
                    emptyTitle: controller.searchQuery.value.isNotEmpty
                        ? 'No assignments found'
                        : 'No homework yet',
                    emptySubtitle: controller.searchQuery.value.isNotEmpty
                        ? 'Try searching with a different title'
                        : 'Start by creating a new homework assignment for this batch',
                    emptyIcon: controller.searchQuery.value.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.assignment_outlined,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: AppSpacing.x24.add(AppSpacing.bottom16),
                      child: Column(
                        children: controller.filteredHomeworks
                            .map((hw) => _buildHomeworkItem(hw, controller))
                            .toList(),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Get.toNamed(AppRoutes.instituteAddHomework, arguments: batch),
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchBar(HomeworkController controller) {
    return AppSearchField(
      hintText: AppStrings.instSearchAssignmentsHint,
      onChanged: (val) => controller.searchQuery.value = val,
    );
  }

  Widget _buildHomeworkItem(HomeworkModel hw, HomeworkController controller) {
    final isActive = hw.isActive;
    return GestureDetector(
      onTap: () async {
        final result = await Get.toNamed(
          AppRoutes.instituteHomeworkRating,
          arguments: hw,
        );
        if (result == true) {
          controller.fetchHomeworks();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryBrand
                    : AppColors.borderLightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hw.title,
                          style: AppTextStyles.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFE0F2FE)
                              : AppColors.divider,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isActive
                              ? AppStrings.instActiveLabel
                              : AppStrings.instClosedLabel,
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isActive
                                ? AppColors.primaryBrand
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v12,
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.h8,
                      Text(
                        '${isActive ? AppStrings.instDueLabel : AppStrings.instEndedLabel} ${DateFormat('MMM dd, yyyy').format(hw.dueDate)}',
                        style: AppTextStyles.lexend(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.h24,
                      Icon(
                        Icons.people_outline_rounded,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.h8,
                      Text(
                        '${hw.submittedCount} ${AppStrings.instSubmissionsLabel}',
                        style: AppTextStyles.lexend(
                          fontSize: 12,
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
      ),
    );
  }
}
