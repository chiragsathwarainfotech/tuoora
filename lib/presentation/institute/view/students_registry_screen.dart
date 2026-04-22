import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/institute_controller.dart';

class StudentsRegistryScreen extends GetView<InstituteController> {
  const StudentsRegistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchStudents(),
      color: AppColors.instDarkBtnBlue,
      child: Obx(
        () => controller.isLoadingStudents.value && controller.students.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.instDarkBtnBlue,
                ),
              )
            : Padding(
                padding: AppSpacing.x24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.v16,
                    _buildSearchBar(),
                    AppSpacing.v20,
                    _buildFilterRow(),
                    AppSpacing.v24,
                    _buildStudentsList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputSolidGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: AppTextStyles.lexend(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: AppStrings.instStudentSearchHint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textTertiary,
            size: AppSpacing.s24,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            _buildFilterChip(
              AppStrings.instFilterAll,
              controller.selectedFilter.value == AppStrings.instFilterAll,
            ),
            AppSpacing.h12,
            _buildFilterChip(
              AppStrings.instFilter10th,
              controller.selectedFilter.value == AppStrings.instFilter10th,
            ),
            AppSpacing.h12,
            _buildFilterChip(
              AppStrings.instFilter9th,
              controller.selectedFilter.value == AppStrings.instFilter9th,
            ),
            AppSpacing.h12,
            _buildFilterChip(
              AppStrings.instFilterBatches,
              controller.selectedFilter.value == AppStrings.instFilterBatches,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return GestureDetector(
      onTap: () => controller.setFilter(label),
      child: Container(
        padding: AppSpacing.x24.add(AppSpacing.y10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.instDarkBtnBlue
              : AppColors.instFilterInactiveBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            color: isActive ? Colors.white : AppColors.instFilterInactiveText,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentsList() {
    return Obx(
      () => Column(
        children: controller.filteredStudents
            .map(
              (student) => Padding(
                padding: AppSpacing.bottom16,
                child: _buildStudentCard(
                  name: student.name,
                  id: student.id,
                  grade: student.grade,
                  batch: student.batch,
                  status: student.status,
                  imageUrl: student.imageUrl,
                  showOnlineBadge: student.showOnlineBadge,
                  isPending: student.isPending,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildStudentCard({
    required String name,
    required String id,
    required String grade,
    required String batch,
    required String status,
    required String imageUrl,
    required bool showOnlineBadge,
    bool isPending = false,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.instituteStudentProfile,
        arguments: {
          'studentId': id,
          'student': {
            'id': id,
            'name': name,
            'grade': grade,
            'batch': batch,
            'status': status,
            'imageUrl': imageUrl,
          },
        },
      ),
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, AppSpacing.s4),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: AppSpacing.s64,
              height: AppSpacing.s64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
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
                      Text(
                        name,
                        style: AppTextStyles.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.h8,
                      Container(
                        padding: AppSpacing.x8.add(AppSpacing.y4),
                        decoration: BoxDecoration(
                          color: isPending
                              ? AppColors.instBadgePendingBg
                              : AppColors.instLightBlueBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: AppTextStyles.manrope(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: isPending
                                ? AppColors.instBadgePendingText
                                : AppColors.instPurpleBlue,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v4,
                  Text(
                    id,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  AppSpacing.v4,
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.school_rounded,
                            size: AppSpacing.s14,
                            color: AppColors.instDarkBtnBlue,
                          ),
                          AppSpacing.h4,
                          Text(
                            grade,
                            style: AppTextStyles.lexend(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.h16,
                      Flexible(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.people_alt_rounded,
                              size: AppSpacing.s14,
                              color: AppColors.instPurpleBlue,
                            ),
                            AppSpacing.h4,
                            Text(
                              batch,
                              style: AppTextStyles.lexend(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
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
