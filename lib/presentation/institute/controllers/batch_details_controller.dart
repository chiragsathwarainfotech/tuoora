import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
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
  final BatchModel batch;

  final assignedStudents = <BatchStudent>[].obs;

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
    // Load mock assigned students for this batch
    _loadMockAssignedStudents();
  }

  void _loadMockAssignedStudents() {
    if (instituteController.students.isNotEmpty) {
      assignedStudents.assignAll([
        BatchStudent(
          student: instituteController.students[0],
          assignedFee: batch.baseFee,
        ),
        if (instituteController.students.length > 1)
          BatchStudent(
            student: instituteController.students[1],
            assignedFee: batch.baseFee,
          ),
      ]);
    }
  }

  void removeStudentFromBatch(String studentId) {
    final studentName = assignedStudents
        .firstWhereOrNull((s) => s.student.id == studentId)
        ?.student
        .name;
    assignedStudents.removeWhere((s) => s.student.id == studentId);
    Get.snackbar('Removed', '$studentName removed from batch successfully.');
  }

  @override
  void onClose() {
    assignedSearchController.dispose();
    super.onClose();
  }
}
