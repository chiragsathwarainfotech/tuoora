import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchController extends GetxController {
  final batchesList = <BatchModel>[].obs;

  // Form State
  final isEditMode = false.obs;
  final batchNameController = TextEditingController();
  final selectedSubject = 'Mathematics'.obs;
  final startTime = const TimeOfDay(hour: 8, minute: 0).obs;
  final endTime = const TimeOfDay(hour: 9, minute: 30).obs;
  final selectedDays = <String>['Mon', 'Wed', 'Fri'].obs;
  final selectedStudentIds = <String>[].obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final currentEditingBatchId = ''.obs;

  final subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
    'Algebra',
  ];
  final allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void onInit() {
    super.onInit();
    _loadMockBatches();
  }

  void _loadMockBatches() {
    batchesList.assignAll([
      BatchModel(
        id: '1',
        title: 'Mathematics - 10th Std',
        time: '08:00 AM - 09:30 AM',
        subject: 'Mathematics',
        studentCount: '42 Students',
        location: 'Lab A',
        statusLabel: AppStrings.instStatusHighCapacity,
        statusBg: AppColors.instStatusHighCapacityBg,
        leftBorderColor: AppColors.instBorderHighCapacity,
      ),
      BatchModel(
        id: '2',
        title: 'Physics - Advanced',
        time: '10:30 AM - 12:00 PM',
        subject: 'Mathematics',
        studentCount: '50 Students',
        location: 'Hall 3',
        statusLabel: AppStrings.instStatusFull,
        statusBg: AppColors.instStatusFullBg,
        leftBorderColor: AppColors.instBorderFull,
      ),
      BatchModel(
        id: '3',
        title: 'Literature 101',
        time: '02:00 PM - 03:30 PM',
        subject: 'Mathematics',
        studentCount: '18 Students',
        location: 'Room 12',
        statusLabel: AppStrings.instStatusOpen,
        statusBg: AppColors.instStatusOpenBg,
        leftBorderColor: AppColors.instBorderOpen,
        statusTextColor: AppColors.instStatusOpenText,
      ),
    ]);
  }

  void initAddMode() {
    isEditMode.value = false;
    batchNameController.clear();
    selectedSubject.value = subjects[0];
    startTime.value = const TimeOfDay(hour: 8, minute: 0);
    endTime.value = const TimeOfDay(hour: 9, minute: 30);
    selectedDays.assignAll(['Mon', 'Wed', 'Fri']);
    selectedStudentIds.clear();
    searchQuery.value = '';
    currentEditingBatchId.value = '';
    searchController.clear();
  }

  void initEditMode(BatchModel batch) {
    isEditMode.value = true;
    currentEditingBatchId.value = batch.id;
    batchNameController.text = batch.title;
    selectedSubject.value = batch.subject;
    selectedSubject.value = 'Algebra';
    selectedDays.assignAll(['Mon', 'Wed', 'Fri']);
    searchQuery.value = '';
    searchController.clear();
  }

  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  void toggleStudent(String id) {
    if (selectedStudentIds.contains(id)) {
      selectedStudentIds.remove(id);
    } else {
      selectedStudentIds.add(id);
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime.value,
    );
    if (picked != null) startTime.value = picked;
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime.value,
    );
    if (picked != null) endTime.value = picked;
  }

  void deleteBatchWithConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Batch'),
        content: const Text('Are you sure you want to delete this batch?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              batchesList.removeWhere((batch) => batch.id == id);
              Get.back(); // close dialog
              Get.back(); // go back from screen
              Get.snackbar(
                'Deleted',
                'Batch deleted successfully',
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void saveBatch(BuildContext context) {
    if (batchNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter batch name',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final newBatch = BatchModel(
      id: isEditMode.value
          ? currentEditingBatchId.value
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: batchNameController.text.trim(),
      time:
          '${startTime.value.format(context)} - ${endTime.value.format(context)}',
      subject: selectedSubject.value,
      studentCount: '${selectedStudentIds.length} Students',
      location: 'TBD',
      statusLabel: 'Active',
      statusBg: AppColors.instStatusOpenBg,
      leftBorderColor: AppColors.instBorderOpen,
      statusTextColor: AppColors.instStatusOpenText,
    );

    if (isEditMode.value) {
      final index = batchesList.indexWhere(
        (b) => b.id == currentEditingBatchId.value,
      );

      if (index != -1) {
        batchesList[index] = newBatch;
      }
    } else {
      batchesList.add(newBatch);
    }

    batchesList.refresh();

    Get.back(); // go back FIRST

    Future.delayed(const Duration(milliseconds: 200), () {
      Get.snackbar(
        isEditMode.value ? 'Batch Updated' : 'Batch Created',
        'Successfully saved ${batchNameController.text}',
        backgroundColor: const Color(0xFF027A48),
        colorText: Colors.white,
      );
    });
  }

  void openAssignStudents(BatchModel batch) {
    currentEditingBatchId.value = batch.id;
    selectedStudentIds.clear();
    Get.toNamed(AppRoutes.instituteAssignStudents);
  }

  void applyStudentAssignment() {
    final index = batchesList.indexWhere(
      (b) => b.id == currentEditingBatchId.value,
    );

    if (index != -1) {
      final batch = batchesList[index];

      batchesList[index] = BatchModel(
        id: batch.id,
        title: batch.title,
        subject: batch.subject,
        time: batch.time,
        studentCount: '${selectedStudentIds.length} Students',
        location: batch.location,
        statusLabel: batch.statusLabel,
        statusBg: batch.statusBg,
        leftBorderColor: batch.leftBorderColor,
        statusTextColor: batch.statusTextColor,
      );

      batchesList.refresh();
    }
  }

  void deleteBatch(String id) {
    batchesList.removeWhere((batch) => batch.id == id);
    Get.snackbar(
      'Batch Deleted',
      'The batch has been removed successfully.',
      backgroundColor: const Color(0xFF027A48),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
