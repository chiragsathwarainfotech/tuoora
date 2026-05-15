import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_details_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignToBatchController extends GetxController {
  final BatchModel batch;
  final InstituteController instituteController =
      Get.find<InstituteController>();
  final BatchDetailsController batchDetailsController;
  final InstituteRepositoryImpl _repository =
      Get.find<InstituteRepositoryImpl>();

  final searchController = TextEditingController();
  final searchResults = <Student>[].obs;
  final selectedStudents = <BatchStudent>[].obs;
  final isLoading = false.obs;

  AssignToBatchController(this.batch, this.batchDetailsController);

  void searchStudents(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    final existingIds = batchDetailsController.assignedStudents
        .map((s) => s.student.id)
        .toSet();
    final selectedIds = selectedStudents.map((s) => s.student.id).toSet();

    searchResults.assignAll(
      instituteController.students
          .where(
            (s) =>
                (s.name.toLowerCase().contains(query.toLowerCase()) ||
                    s.id.toString().toLowerCase().contains(
                      query.toLowerCase(),
                    )) &&
                s.batchId == null &&
                !existingIds.contains(s.id) &&
                !selectedIds.contains(s.id),
          )
          .toList(),
    );
  }

  void addStudentToSelection(Student student) {
    selectedStudents.add(
      BatchStudent(student: student, assignedFee: batch.baseFee),
    );
    searchController.clear();
    searchResults.clear();
  }

  void removeStudentFromSelection(int studentId) {
    selectedStudents.removeWhere((s) => s.student.id == studentId);
  }

  void updateStudentFee(int studentId, String feeStr) {
    final index = selectedStudents.indexWhere((s) => s.student.id == studentId);
    if (index != -1) {
      double fee = double.tryParse(feeStr) ?? batch.baseFee;
      selectedStudents[index].assignedFee = fee;
    }
  }

  Future<void> confirmAssignment() async {
    if (selectedStudents.isEmpty) return;

    try {
      isLoading.value = true;

      final List<Map<String, dynamic>> studentsData = selectedStudents
          .map((bs) => {'id': bs.student.id, 'fee': bs.assignedFee.toInt()})
          .toList();

      await _repository.assignStudentsToBatch(
        int.parse(batch.id),
        studentsData,
      );

      // Refresh the batches list in BatchController
      if (Get.isRegistered<BatchController>()) {
        Get.find<BatchController>().loadBatches(isRefresh: true);
      }

      batchDetailsController.assignedStudents.addAll(selectedStudents);
      
      // Update global students list to reflect new batch assignment
      for (var bs in selectedStudents) {
        final updatedStudent = bs.student.copyWith(batchId: int.parse(batch.id));
        instituteController.updateStudent(updatedStudent);
      }

      batchDetailsController.studentCount.value =
          batchDetailsController.assignedStudents.length;
      batchDetailsController.assignedStudents.refresh();
      Get.back();
      Get.snackbar(
        'Success',
        '${selectedStudents.length} students assigned to batch successfully.',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign students: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class AssignToBatchScreen extends StatelessWidget {
  const AssignToBatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BatchModel batch = Get.arguments;
    final BatchDetailsController detailsController =
        Get.find<BatchDetailsController>(tag: batch.id);
    final controller = Get.put(
      AssignToBatchController(batch, detailsController),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Assign to Batch',
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: AppSpacing.x24.add(AppSpacing.y16),
                    child: Column(
                      children: [
                        _buildSearchSection(controller),
                        AppSpacing.v24,
                        Obx(() => _buildSelectionList(controller)),
                        const SizedBox(
                          height: 120,
                        ), // Space for the pinned button
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: AppSpacing.all24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.scaffoldBg.withValues(alpha: 0.0),
                            AppColors.scaffoldBg.withValues(alpha: 0.9),
                            AppColors.scaffoldBg,
                          ],
                          stops: const [0.0, 0.3, 1.0],
                        ),
                      ),
                      child: Obx(
                        () => AppButton(
                          label: 'Confirm & Save Assignment',
                          icon: Icons.check_circle_rounded,
                          isLoading: controller.isLoading.value,
                          isDisabled: controller.selectedStudents.isEmpty,
                          onPressed: controller.selectedStudents.isEmpty
                              ? null
                              : controller.confirmAssignment,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(AssignToBatchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(
          hintText: 'Search and add students to this batch',
          controller: controller.searchController,
          onChanged: controller.searchStudents,
        ),
        Obx(() {
          if (controller.searchResults.isEmpty) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = controller.searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryBrandLight,
                    child: Text(student.name[0]),
                  ),
                  title: Text(
                    student.name,
                    style: AppTextStyles.manrope(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    student.id.toString(),
                    style: AppTextStyles.lexend(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.primaryBrand,
                  ),
                  onTap: () => controller.addStudentToSelection(student),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSelectionList(AssignToBatchController controller) {
    if (controller.selectedStudents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(
                Icons.person_add_rounded,
                size: 48,
                color: Colors.grey.shade200,
              ),
              AppSpacing.v16,
              Text(
                'No students selected yet',
                style: AppTextStyles.lexend(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.selectedStudents.length,
      itemBuilder: (context, index) {
        final bs = controller.selectedStudents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: AppSpacing.all16,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 48,
                      height: 48,
                      color: AppColors.primaryBrandLight,
                      child: Center(
                        child: Text(
                          bs.student.name[0],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bs.student.name,
                          style: AppTextStyles.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'ID: ${bs.student.id}',
                          style: AppTextStyles.lexend(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        controller.removeStudentFromSelection(bs.student.id),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              AppSpacing.v16,
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '₹',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBrand,
                            ),
                          ),
                          AppSpacing.h12,
                          Expanded(
                            child: TextFormField(
                              initialValue: bs.assignedFee.toStringAsFixed(0),
                              onChanged: (val) => controller.updateStudentFee(
                                bs.student.id,
                                val,
                              ),
                              keyboardType: TextInputType.number,
                              style: AppTextStyles.manrope(
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Enter Fee',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
