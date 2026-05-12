import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchStudent {
  final Student student;
  double assignedFee;

  BatchStudent({required this.student, required this.assignedFee});
}

class BatchDetailsController extends GetxController {
  final InstituteController instituteController =
      Get.find<InstituteController>();
  final InstituteRepositoryImpl _repository =
      Get.find<InstituteRepositoryImpl>();
  final BatchModel batch;

  final assignedStudents = <BatchStudent>[].obs;
  final isLoading = false.obs;
  final studentCount = 0.obs;

  final assignedSearchController = TextEditingController();
  final assignedSearchQuery = ''.obs;

  List<BatchStudent> get filteredAssignedStudents {
    if (assignedSearchQuery.isEmpty) return assignedStudents;
    return assignedStudents
        .where(
          (bs) => bs.student.name.toLowerCase().contains(
            assignedSearchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  BatchDetailsController(this.batch);

  @override
  void onInit() {
    super.onInit();
    studentCount.value = int.tryParse(batch.studentCount.split(' ')[0]) ?? 0;
    _loadAssignedStudents();
  }

  void _loadAssignedStudents() {
    assignedStudents.clear();

    if (batch.students != null && batch.students!.isNotEmpty) {
      final List<BatchStudent> loadedStudents = [];
      for (var s in batch.students!) {
        final studentModel = Student(
          id: s.id,
          name: s.name,
          email: '',
          phone: '',
          instituteId: 0,
          standard: '',
          dob: '',
          status: 'Active',
          idHash: '',
          createdAt: '',
          updatedAt: '',
          profileImageUrl: s.profileImageUrl ?? '',
        );
        loadedStudents.add(
          BatchStudent(student: studentModel, assignedFee: batch.baseFee),
        );
      }
      assignedStudents.assignAll(loadedStudents);
      studentCount.value = assignedStudents.length;
    }
    assignedStudents.refresh();
  }

  Future<void> removeStudentFromBatch(int studentId) async {
    try {
      isLoading.value = true;

      final studentName = assignedStudents
          .firstWhereOrNull((s) => s.student.id == studentId)
          ?.student
          .name;

      await _repository.removeStudentFromBatch(int.parse(batch.id), studentId);

      // Refresh the batches list in BatchController
      if (Get.isRegistered<BatchController>()) {
        Get.find<BatchController>().loadBatches(isRefresh: true);
      }

      // Update local list and count
      assignedStudents.removeWhere((s) => s.student.id == studentId);
      studentCount.value = assignedStudents.length;
      assignedStudents.refresh();

      Get.snackbar(
        'Success',
        '${studentName ?? 'Student'} removed from batch successfully.',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove student: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStudents() async {
    // This could be used if we had a "Get Batch Details" API
    // For now, it just ensures the local state is fresh
    _loadAssignedStudents();
  }

  @override
  void onClose() {
    assignedSearchController.dispose();
    super.onClose();
  }
}

