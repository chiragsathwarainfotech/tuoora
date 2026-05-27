import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/institute_controller.dart';
import 'package:tuoora/presentation/institute/controllers/student_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/common_state_widget.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentsRegistryScreen extends GetView<InstituteController> {
  const StudentsRegistryScreen({super.key});

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
                  title: AppStrings.instNavStudents,
                  onBackTap: () => Get.back(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.fetchStudents(reset: true),
                    color: AppColors.primaryBrand,
                    child: Padding(
                      padding: AppSpacing.x16,
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
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.instituteAddEditStudent),
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white, size: 28),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      hintText: AppStrings.instStudentSearchHint,
      onChanged: controller.onSearchChanged,
    );
  }

  Widget _buildStudentsList() {
    return Obx(() {
      return CommonStateWidget(
        isLoading: controller.isLoadingStudents.value,
        isEmpty: controller.students.isEmpty,
        emptyTitle: controller.searchQuery.value.isNotEmpty
            ? 'No students found'
            : 'No students available',
        emptySubtitle: controller.searchQuery.value.isNotEmpty
            ? 'Try searching with a different name'
            : 'Start by adding a new student to the registry',
        emptyIcon: controller.searchQuery.value.isNotEmpty
            ? Icons.search_off_rounded
            : Icons.people_outline_rounded,
        child: NotificationListener<ScrollNotification>(
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
                    child: CommonLoading(size: 24, strokeWidth: 2),
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
        ),
      );
    });
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
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
            _buildStudentAvatar(imageUrl, name),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.outfit(
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
                            color: AppColors.primaryBrand,
                          ),
                          AppSpacing.h4,
                          Text(
                            grade,
                            style: AppTextStyles.outfit(
                              fontSize: AppSpacing.s16,
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

  Widget _buildStudentAvatar(String imageUrl, String name) {
    if (imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com')) {
      return Container(
        width: AppSpacing.s64,
        height: AppSpacing.s64,
        decoration: BoxDecoration(
          color: AppColors.primaryBrandLight,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0].toUpperCase();
      if (names.length > 1) {
        initials += names[names.length - 1][0].toUpperCase();
      }
    }

    return Container(
      width: AppSpacing.s64,
      height: AppSpacing.s64,
      decoration: const BoxDecoration(
        color: AppColors.primaryBrandLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
    );
  }
}
