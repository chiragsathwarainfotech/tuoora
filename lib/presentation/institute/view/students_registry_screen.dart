import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_root_scaffold.dart';

class StudentsRegistryScreen extends GetView<InstituteController> {
  final bool showShell;
  const StudentsRegistryScreen({super.key, this.showShell = true});

  @override
  Widget build(BuildContext context) {
    return InstituteRootScaffold(
      title: 'Student Registry',
      currentIndex: 1,
      showShell: showShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.instituteAddStudent),
        backgroundColor: AppColors.instDarkBtnBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: AppSpacing.s28),
      ),
      body: SingleChildScrollView(
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
      onTap: () => Get.toNamed(AppRoutes.instituteStudentProfile),
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
            // Avatar Stack
            Stack(
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
                if (showOnlineBadge)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: AppSpacing.s16,
                      height: AppSpacing.s16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981), // Green dot
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: AppSpacing.s2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            AppSpacing.h16,

            // Content Mapping
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  AppSpacing.v8,
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
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.h16,
                      Row(
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
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: AppSpacing.s24,
            ),
          ],
        ),
      ),
    );
  }
}
