import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeworkController extends GetxController {
  final BatchModel batch;
  final InstituteController instituteController = Get.find<InstituteController>();
  
  final homeworks = <HomeworkModel>[].obs;
  final searchQuery = ''.obs;

  HomeworkController(this.batch);

  @override
  void onInit() {
    super.onInit();
    _loadMockHomework();
  }

  void _loadMockHomework() {
    homeworks.assignAll([
      HomeworkModel(
        id: '1',
        title: 'Integration Methods',
        subject: 'Advanced Calculus',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        description: 'Complete all exercises from chapter 4.',
        batchId: batch.id,
        submissions: _createMockSubmissions(15),
      ),
      HomeworkModel(
        id: '2',
        title: 'Peer Review',
        subject: 'Fluid Dynamics',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        description: 'Review peer assignments.',
        batchId: batch.id,
        submissions: _createMockSubmissions(10),
      ),
      HomeworkModel(
        id: '3',
        title: 'Mid-term Quiz',
        subject: 'Thermodynamics',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Online quiz on thermodynamics.',
        batchId: batch.id,
        submissions: _createMockSubmissions(24),
      ),
    ]);
  }

  List<HomeworkSubmission> _createMockSubmissions(int count) {
    return instituteController.students.take(count).map((s) {
      final isSub = instituteController.students.indexOf(s) % 3 != 0;
      return HomeworkSubmission(
        student: s,
        isSubmitted: isSub,
        submittedAt: isSub ? DateTime.now().subtract(const Duration(days: 1)) : null,
        score: isSub ? (7 + (instituteController.students.indexOf(s) % 4).toDouble()) : null,
      );
    }).toList();
  }

  List<HomeworkModel> get filteredHomeworks {
    if (searchQuery.isEmpty) return homeworks;
    return homeworks.where((h) => h.title.toLowerCase().contains(searchQuery.value.toLowerCase()) || 
                                h.subject.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  // Create Homework Form State
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDate = Rxn<DateTime>();
  final resourcePaths = <String>[].obs;

  void createHomework() {
    if (titleController.text.isEmpty || dueDate.value == null) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    final newHw = HomeworkModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      subject: batch.title,
      dueDate: dueDate.value!,
      description: descriptionController.text,
      batchId: batch.id,
      resourcePaths: List.from(resourcePaths),
      submissions: instituteController.students.map((s) => HomeworkSubmission(student: s)).toList(),
    );

    homeworks.insert(0, newHw);
    clearForm();
    Get.back();
    Get.snackbar('Success', 'Homework created successfully');
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    dueDate.value = null;
    resourcePaths.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
