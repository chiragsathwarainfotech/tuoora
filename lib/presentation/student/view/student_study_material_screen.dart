import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/presentation/student/controllers/student_study_material_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentStudyMaterialScreen
    extends GetView<StudentStudyMaterialController> {
  const StudentStudyMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(
              title: 'Study material',
              showDefaultActions: false,
            ),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: controller.filteredMaterials.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.filteredMaterials[index];
                    return _buildMaterialCard(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.subjects.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final subject = controller.subjects[index];
          return Obx(() {
            final isSelected = controller.selectedSubject.value == subject;
            return GestureDetector(
              onTap: () => controller.selectSubject(subject),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.studentBrand : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: AppColors.borderGrey.withValues(alpha: 0.5),
                        ),
                ),
                alignment: Alignment.center,
                child: Text(
                  subject,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed('/student/study-material/detail', arguments: item),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(item['subjectBgColor']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['subject'],
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(item['subjectTextColor']),
                    ),
                  ),
                ),
                Text(
                  item['date'],
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['title'],
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['description'],
              style: AppTextStyles.lexend(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  item['isVideo']
                      ? Icons.play_circle_outline_rounded
                      : Icons.insert_drive_file_outlined,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${item['fileCount']} file${item['fileCount'] > 1 ? 's' : ''}',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '·',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item['teacher'],
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
