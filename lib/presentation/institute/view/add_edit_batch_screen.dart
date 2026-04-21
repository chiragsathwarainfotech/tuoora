import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditBatchScreen extends GetView<BatchController> {
  const AddEditBatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => InstituteAppBar(
                title: controller.isEditMode.value ? 'Edit Batch' : 'Add Batch',
                isRoot: false,
                actions: [
                  if (controller.isEditMode.value)
                    IconButton(
                      onPressed: () => controller.deleteBatchWithConfirmation(
                        controller.currentEditingBatchId.value,
                      ),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Batch Name'),
                    AppSpacing.v12,
                    _buildTextField(
                      controller: controller.batchNameController,
                      hint: 'e.g., Advanced Algebra - Section A',
                    ),
                    AppSpacing.v24,
                    _buildLabel('Subject'),
                    AppSpacing.v12,
                    _buildDropdown(),
                    AppSpacing.v32,
                    _buildSectionHeader(
                      Icons.access_time_filled_rounded,
                      'Schedule Settings',
                    ),
                    AppSpacing.v20,
                    _buildScheduleCard(context),
                    AppSpacing.v24,
                    _buildLabel('ACTIVE DAYS'),
                    AppSpacing.v16,
                    _buildDaysSelection(),
                    AppSpacing.v32,
                    _buildAssignStudentsHeader(),
                    AppSpacing.v16,
                    _buildStudentsSection(),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(child: _buildSaveButton(context)),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF4B5563),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.manrope(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.manrope(fontSize: 14, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedSubject.value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: controller.subjects.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) controller.selectedSubject.value = val;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
        AppSpacing.h12,
        Text(
          title,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIME SLOT',
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v16,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_filled,
                  color: Color(0xFF1E3A8A),
                  size: 24,
                ),
                AppSpacing.h16,
                Expanded(
                  child: Obx(
                    () => Text(
                      '${controller.startTime.value.format(context)} — ${controller.endTime.value.format(context)}',
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showTimeRangePicker(context),
                  child: Text(
                    'Change',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTimeRangePicker(BuildContext context) async {
    await controller.selectStartTime(context);
    if (context.mounted) {
      await controller.selectEndTime(context);
    }
  }

  Widget _buildDaysSelection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controller.allDays.map((day) {
        return Obx(() {
          final isSelected = controller.selectedDays.contains(day);
          return GestureDetector(
            onTap: () => controller.toggleDay(day),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF003D82)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                day,
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF4B5563),
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildAssignStudentsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.people_alt_rounded,
              color: Color(0xFF1E3A8A),
              size: 20,
            ),
            AppSpacing.h12,
            Text(
              'Assign Students',
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ],
        ),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${controller.selectedStudentIds.length} Selected',
              style: AppTextStyles.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E40AF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsSection() {
    final instituteController = Get.find<InstituteController>();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search roster by name or ID...',
                  hintStyle: AppTextStyles.manrope(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  icon: const Icon(Icons.search, color: Colors.grey, size: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Obx(() {
            final query = controller.searchQuery.value.toLowerCase();
            final filteredList = instituteController.students
                .where((s) {
                  return s.name.toLowerCase().contains(query) ||
                      s.id.toLowerCase().contains(query);
                })
                .take(3)
                .toList();

            return Container(
              color: Colors.white,
              child: Column(
                children: filteredList.map((student) {
                  return _buildStudentTile(student);
                }).toList(),
              ),
            );
          }),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteAssignStudents),
            child: Container(
              padding: AppSpacing.all16,
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Color(0xFF1E3A8A),
                    size: 20,
                  ),
                  AppSpacing.h12,
                  Text(
                    'Manage Student Assignment',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(Student student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(student.imageUrl),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                Text(
                  'ID: ${student.id}',
                  style: AppTextStyles.manrope(
                    fontSize: 11,
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
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: AppSpacing.all24,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          controller.saveBatch(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0051B3),
          padding: AppSpacing.y20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save_rounded, color: Colors.white, size: 20),
            AppSpacing.h12,
            Text(
              'Save Batch Details',
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
