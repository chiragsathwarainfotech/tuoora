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

  final isSearching = false.obs;
  final searchController = TextEditingController();
  final assignedSearchController = TextEditingController();
  final searchResults = <Student>[].obs;
  final selectedStudent = Rxn<Student>();
  final feeController = TextEditingController();
  final assignedSearchQuery = ''.obs;

  List<BatchStudent> get filteredAssignedStudents {
    if (assignedSearchQuery.isEmpty) return assignedStudents;
    return assignedStudents
        .where((bs) =>
            bs.student.name
                .toLowerCase()
                .contains(assignedSearchQuery.value.toLowerCase()) ||
            bs.student.id
                .toLowerCase()
                .contains(assignedSearchQuery.value.toLowerCase()))
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
    // In a real app, this would come from a database based on batch.id
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

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      clearSearch();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    selectedStudent.value = null;
    feeController.clear();
  }

  void searchStudents(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    searchResults.assignAll(
      instituteController.students
          .where(
            (s) =>
                s.name.toLowerCase().contains(query.toLowerCase()) ||
                s.id.toLowerCase().contains(query.toLowerCase()),
          )
          .toList(),
    );
  }

  void selectStudent(Student student) {
    selectedStudent.value = student;
    feeController.text = batch.baseFee.toStringAsFixed(0);
    searchResults.clear();
    searchController.text = student.name;
  }

  void addStudentToBatch() {
    if (selectedStudent.value == null) return;

    double fee = double.tryParse(feeController.text) ?? batch.baseFee;

    // Check if already assigned
    if (assignedStudents.any(
      (s) => s.student.id == selectedStudent.value!.id,
    )) {
      Get.snackbar('Already Assigned', 'This student is already in the batch.');
      return;
    }

    assignedStudents.add(
      BatchStudent(student: selectedStudent.value!, assignedFee: fee),
    );

    Get.back(); // Close dialog
    Get.snackbar('Success', '${selectedStudent.value!.name} added to batch.');
  }

  @override
  void onClose() {
    searchController.dispose();
    assignedSearchController.dispose();
    feeController.dispose();
    super.onClose();
  }
}
