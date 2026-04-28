import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentsRegistryScreen extends GetView<InstituteController> {
  const StudentsRegistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchStudents(reset: true),
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
                    Expanded(child: _buildStudentsList()),
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
        onChanged: controller.onSearchChanged,
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

  Widget _buildStudentsList() {
    return Obx(() {
      if (controller.students.isEmpty && !controller.isLoadingStudents.value) {
        return _buildEmptyState();
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              !controller.isLoadingStudents.value &&
              !controller.isLoadMore.value) {
            controller.loadMoreStudents();
          }
          return true;
        },
        child: ListView.builder(
          itemCount:
              controller.students.length +
              (controller.isLoadMore.value ? 1 : 0),
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == controller.students.length) {
              return const Center(
                child: Padding(
                  padding: AppSpacing.all16,
                  child: CircularProgressIndicator(
                    color: AppColors.instDarkBtnBlue,
                  ),
                ),
              );
            }
            final student = controller.students[index];
            return Padding(
              padding: AppSpacing.bottom16,
              child: _buildStudentCard(
                name: student.name,
                id: student.id,
                grade: student.grade,
                imageUrl: student.imageUrl,
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    final isSearching = controller.searchQuery.value.isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppSpacing.all24,
            decoration: BoxDecoration(
              color: AppColors.borderGrey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSearching
                  ? Icons.search_off_rounded
                  : Icons.people_outline_rounded,
              size: 64,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.v24,
          Text(
            isSearching ? 'No students found' : 'No students available',
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v8,
          Text(
            isSearching
                ? 'Try searching with a different name'
                : 'Start by adding a new student to the registry',
            textAlign: TextAlign.center,
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard({
    required String name,
    required int id,
    required String grade,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Get.delete<InstituteStudentController>();
        Get.toNamed(
          AppRoutes.instituteStudentProfile,
          arguments: {
            'studentId': id,
            'student': controller.students.firstWhere((s) => s.id == id),
          },
        );
      },
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
                  Text(
                    name,
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.school_rounded,
                            size: AppSpacing.s18,
                            color: AppColors.instDarkBtnBlue,
                          ),
                          AppSpacing.h4,
                          Text(
                            grade,
                            style: AppTextStyles.lexend(
                              fontSize: 16,
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
          ],
        ),
      ),
    );
  }
}
