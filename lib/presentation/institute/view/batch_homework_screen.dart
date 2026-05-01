import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/homework_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchHomeworks(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppSpacing.x24.add(AppSpacing.y16),
                  child: Column(
                    children: [
                      _buildSearchBar(controller),
                      AppSpacing.v24,
                      Obx(() {
                        if (controller.isLoading.value && controller.homeworks.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (controller.filteredHomeworks.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Text(
                                'No homework assignments found',
                                style: AppTextStyles.manrope(
                                  fontSize: 16,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: controller.filteredHomeworks
                              .map((hw) => _buildHomeworkItem(hw))
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Get.toNamed(AppRoutes.instituteAddHomework, arguments: batch),
        backgroundColor: AppColors.instPrimaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar(HomeworkController controller) {
    return Container(
      padding: AppSpacing.x16,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (val) => controller.searchQuery.value = val,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            Icons.search,
            color: const Color(0xFF917B6B),
          ),
          hintText: AppStrings.instSearchAssignmentsHint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: const Color(0xFF917B6B),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeworkItem(HomeworkModel hw) {
    final isActive = hw.isActive;
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.instituteHomeworkRating, arguments: hw),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: Colors.white,
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
                    ? AppColors.instPrimaryBlue
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
                          isActive ? AppStrings.instActiveLabel : AppStrings.instClosedLabel,
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isActive
                                ? AppColors.instPrimaryBlue
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
