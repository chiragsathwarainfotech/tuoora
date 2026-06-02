import 'package:cached_network_image/cached_network_image.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/batch_details_controller.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/data/models/student_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_controller.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/controllers/batch_controller.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
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

  @override
  void onInit() {
    super.onInit();
    // Seed the picker with every globally-loaded student that is not yet
    // assigned to any batch, so the institute can scan the unassigned roster
    // immediately without typing anything.
    _loadUnassignedStudents();
  }

  // Filters [instituteController.students] down to those with no batch and
  // not already enrolled in / picked for THIS batch.
  void _loadUnassignedStudents() {
    final existingIds = batchDetailsController.assignedStudents
        .map((s) => s.student.id)
        .toSet();
    final selectedIds = selectedStudents.map((s) => s.student.id).toSet();

    searchResults.assignAll(
      instituteController.students
          .where(
            (s) =>
                s.batchId == null &&
                !existingIds.contains(s.id) &&
                !selectedIds.contains(s.id),
          )
          .toList(),
    );
  }

  void searchStudents(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _loadUnassignedStudents();
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
                (s.name.toLowerCase().contains(trimmed.toLowerCase()) ||
                    s.id.toString().toLowerCase().contains(
                      trimmed.toLowerCase(),
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
    // Re-show the default unassigned roster (now excluding the just-picked
    // student) so the picker stays usable for the next selection.
    _loadUnassignedStudents();
  }

  void removeStudentFromSelection(int studentId) {
    selectedStudents.removeWhere((s) => s.student.id == studentId);
    // If the user is currently on the default (no-search) view, refresh so
    // the un-selected student reappears in the available list.
    if (searchController.text.trim().isEmpty) {
      _loadUnassignedStudents();
    }
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
        final updatedStudent = bs.student.copyWith(
          batchId: int.parse(batch.id),
        );
        instituteController.updateStudent(updatedStudent);
      }

      batchDetailsController.studentCount.value =
          batchDetailsController.assignedStudents.length;
      batchDetailsController.assignedStudents.refresh();
      Get.back();
      AppSnackBar.success('Students assigned');
    } catch (e) {
      AppSnackBar.error('Failed to assign students');
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
                    padding: AppSpacing.x16.add(AppSpacing.y16),
                    child: Column(
                      children: [
                        _buildSearchSection(controller),
                        AppSpacing.v24,
                        Obx(() => _buildSelectionList(controller)),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      top: false,
                      minimum: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        color: AppColors.scaffoldBg,
                        padding: AppSpacing.all16,
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
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final student = controller.searchResults[index];
              return Container(
                padding: AppSpacing.cardPadding,
                margin: AppSpacing.bottom10,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPickerAvatar(
                      imageUrl: student.imageUrl,
                      name: student.name,
                    ),
                    AppSpacing.h16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: AppTextStyles.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Enrollment ID: ${student.id.toString()}',
                            style: AppTextStyles.outfit(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.addStudentToSelection(student);
                      },
                      child: const Icon(
                        Icons.add_circle_outline_rounded,
                        color: AppColors.primaryBrand,
                        size: 24,
                      ),
                    ),
                  ],
                ),
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
                style: AppTextStyles.outfit(color: AppColors.textMuted),
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
          margin: AppSpacing.bottom10,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildSelectedAvatar(
                    imageUrl: bs.student.imageUrl,
                    name: bs.student.name,
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bs.student.name,
                          style: AppTextStyles.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Enrollment ID: ${bs.student.id}',
                          style: AppTextStyles.outfit(
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
                        color: AppColors.surfaceBg,
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
                              style: AppTextStyles.outfit(
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

  Widget _buildPickerAvatar({required String imageUrl, required String name}) {
    final bool hasPhoto =
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com');
    final String initial = name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryBrandLight,
        shape: BoxShape.circle,
        image: hasPhoto
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasPhoto
          ? null
          : Center(
              child: Text(
                initial,
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                ),
              ),
            ),
    );
  }

  Widget _buildSelectedAvatar({
    required String imageUrl,
    required String name,
  }) {
    final bool hasPhoto =
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com');
    final String initial = name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primaryBrandLight,
          image: hasPhoto
              ? DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: hasPhoto
            ? null
            : Center(
                child: Text(
                  initial,
                  style: AppTextStyles.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                  ),
                ),
              ),
      ),
    );
  }
}
