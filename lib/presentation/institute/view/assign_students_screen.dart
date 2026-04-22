import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignStudentsScreen extends GetView<BatchController> {
  const AssignStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instituteController = Get.find<InstituteController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Assign Students', isRoot: false),
            Padding(
              padding: AppSpacing.all24,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: (val) => controller.searchQuery.value = val,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search roster by name or ID...',
                    hintStyle: AppTextStyles.manrope(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: AppSpacing.all16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final query = controller.searchQuery.value.toLowerCase();
                final studentList = instituteController.students.where((s) {
                  return s.name.toLowerCase().contains(query) ||
                      s.id.toLowerCase().contains(query);
                }).toList();

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: studentList.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Color(0xFFF3F4F6)),
                  itemBuilder: (context, index) {
                    final student = studentList[index];
                    return _buildStudentTile(student);
                  },
                );
              }),
            ),
            Padding(
              padding: AppSpacing.all24,
              child: ElevatedButton(
                onPressed: () {
                  controller.applyStudentAssignment();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D82),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Assign Student to Batch',
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentTile(Student student) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(student.imageUrl),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  'ID: ${student.id}',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final isSelected = controller.selectedStudentIds.contains(
              student.id,
            );
            return GestureDetector(
              onTap: () => controller.toggleStudent(student.id),
              child: Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected
                    ? const Color(0xFF1E3A8A)
                    : const Color(0xFFD1D5DB),
                size: 28,
              ),
            );
          }),
        ],
      ),
    );
  }
}
