import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/data/models/student_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_controller.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/controllers/batch_controller.dart';
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
  final totalExpected = ''.obs;
  final totalPaid = ''.obs;

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
    totalExpected.value = batch.totalExpected?.toString() ?? '0';
    totalPaid.value = batch.totalPaid?.toString() ?? '0';
    _loadAssignedStudents(batch.students);
  }

  void _loadAssignedStudents(List<dynamic>? studentsList) {
    assignedStudents.clear();

    if (studentsList != null && studentsList.isNotEmpty) {
      final List<BatchStudent> loadedStudents = [];
      for (var s in studentsList) {
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

      await _repository.removeStudentFromBatch(int.parse(batch.id), studentId);

      // Refresh the batches list in BatchController
      if (Get.isRegistered<BatchController>()) {
        Get.find<BatchController>().loadBatches(isRefresh: true);
      }

      // Update global students list to reflect batch removal
      final student = assignedStudents
          .firstWhereOrNull((s) => s.student.id == studentId)
          ?.student;
      if (student != null) {
        // We use -1 or null? The copyWith expects int?. 
        // Usually, safeNullableInt handles null.
        instituteController.updateStudent(student.copyWith(batchId: null));
      }

      // Update local list and count
      assignedStudents.removeWhere((s) => s.student.id == studentId);
      studentCount.value = assignedStudents.length;
      assignedStudents.refresh();

      AppSnackBar.success(AppStrings.studentRemoved);
    } catch (e) {
      AppSnackBar.error(AppStrings.failedToRemoveStudent);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStudents() async {
    if (Get.isRegistered<BatchController>()) {
      final bc = Get.find<BatchController>();
      await bc.loadBatches(isRefresh: true);
      
      final updatedBatch = bc.batchesList.firstWhereOrNull((b) => b.id == batch.id);
      if (updatedBatch != null) {
        studentCount.value = int.tryParse(updatedBatch.studentCount.split(' ')[0]) ?? 0;
        totalExpected.value = updatedBatch.totalExpected?.toString() ?? '0';
        totalPaid.value = updatedBatch.totalPaid?.toString() ?? '0';
        _loadAssignedStudents(updatedBatch.students);
      }
    }
  }

  @override
  void onClose() {
    assignedSearchController.dispose();
    super.onClose();
  }
}

