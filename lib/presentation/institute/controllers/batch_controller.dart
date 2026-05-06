import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/core/widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';

class BatchController extends GetxController {
  final InstituteRepositoryImpl _repository;

  BatchController(this._repository);

  final batchesList = <BatchModel>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;

  final isEditMode = false.obs;
  final batchNameController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final batchFeeController = TextEditingController();
  final startTime = const TimeOfDay(hour: 0, minute: 0).obs;
  final endTime = const TimeOfDay(hour: 0, minute: 0).obs;
  final selectedDays = <String>[].obs;
  final selectedStudentIds = <String>[].obs;
  final searchQuery = ''.obs;
  final currentEditingBatchId = ''.obs;
  final allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Future<void> loadBatches({bool isRefresh = true}) async {
    if (isRefresh) {
      currentPage.value = 1;
      // Only show central loading if we don't have ANY data yet
      // This prevents double loaders (RefreshIndicator + CommonStateWidget)
      if (batchesList.isEmpty) {
        isLoading.value = true;
      }
    } else {
      if (currentPage.value >= lastPage.value) return;
      isMoreLoading.value = true;
    }

    try {
      final response = await _repository.listBatches(page: currentPage.value);
      final uiBatches = response.items.map((b) => b.toUIModel()).toList();

      if (isRefresh) {
        batchesList.assignAll(uiBatches);
      } else {
        batchesList.addAll(uiBatches);
      }

      lastPage.value = response.lastPage;
      if (currentPage.value < lastPage.value) {
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load batches: ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void initAddMode() {
    isEditMode.value = false;
    batchNameController.clear();
    subjectController.clear();
    descriptionController.clear();
    batchFeeController.clear();
    startTime.value = const TimeOfDay(hour: 0, minute: 0);
    endTime.value = const TimeOfDay(hour: 0, minute: 0);
    selectedDays.clear();
    selectedStudentIds.clear();
    searchQuery.value = '';
    currentEditingBatchId.value = '';
  }

  void initEditMode(BatchModel batch) {
    isEditMode.value = true;
    currentEditingBatchId.value = batch.id;
    batchNameController.text = batch.title;
    subjectController.text = batch.subject;
    descriptionController.text = batch.description;
    batchFeeController.text = batch.baseFee.toStringAsFixed(0);

    final times = batch.time.split(' - ');
    if (times.length == 2) {
      startTime.value = _parseTime(times[0]);
      endTime.value = _parseTime(times[1]);
    }

    selectedDays.assignAll(batch.days);
    searchQuery.value = '';
  }

  TimeOfDay _parseTime(String timeStr) {
    try {
      // Handle "18:00" or "06:00 PM" etc.
      final cleanTime = timeStr.trim();
      final hasAmPm =
          cleanTime.toUpperCase().contains('AM') ||
          cleanTime.toUpperCase().contains('PM');

      if (hasAmPm) {
        final timeParts = cleanTime.split(' ');
        final hourMin = timeParts[0].split(':');
        int hour = int.parse(hourMin[0]);
        int minute = int.parse(hourMin[1]);

        if (cleanTime.toUpperCase().contains('PM') && hour < 12) hour += 12;
        if (cleanTime.toUpperCase().contains('AM') && hour == 12) hour = 0;

        return TimeOfDay(hour: hour, minute: minute);
      } else {
        final parts = cleanTime.split(':');
        if (parts.length >= 2) {
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      }
    } catch (_) {}
    return const TimeOfDay(hour: 8, minute: 0);
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
    CommonDialog.show(
      title: 'Delete Batch',
      description: 'Are you sure you want to delete this batch?',
      icon: Icons.delete_forever_rounded,
      confirmText: 'Delete',
      onConfirm: () async {
        try {
          Get.back(); // Close dialog
          isLoading.value = true;
          await _repository.deleteBatch(int.parse(id));
          batchesList.removeWhere((batch) => batch.id == id);
          Get.back(); // Go back from details screen to BatchesScreen
          Get.snackbar(
            'Deleted',
            'Batch deleted successfully',
            backgroundColor: AppColors.darkGreen,
            colorText: AppColors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
            backgroundColor: Colors.redAccent,
            colorText: AppColors.white,
          );
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> saveBatch(BuildContext context) async {
    if (batchNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter batch name',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
      return;
    }

    final data = {
      'name': batchNameController.text.trim(),
      'subject': subjectController.text.trim(),
      'description': descriptionController.text.trim(),
      'fees': batchFeeController.text.trim(),
      'start_time':
          '${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${endTime.value.hour.toString().padLeft(2, '0')}:${endTime.value.minute.toString().padLeft(2, '0')}',
      'days': selectedDays.toList(),
    };

    try {
      isLoading.value = true;
      if (isEditMode.value) {
        final updatedBatch = await _repository.updateBatch(
          int.parse(currentEditingBatchId.value),
          data,
        );
        final index = batchesList.indexWhere(
          (b) => b.id == currentEditingBatchId.value,
        );
        if (index != -1) {
          batchesList[index] = updatedBatch.toUIModel();
        }
      } else {
        final newBatch = await _repository.createBatch(data);
        batchesList.insert(0, newBatch.toUIModel());
      }

      batchesList.refresh();

      if (isEditMode.value) {
        // If editing, go back twice: EditScreen -> DetailsScreen -> BatchesScreen
        Get.back();
        Get.back();
      } else {
        // If adding, just go back once to BatchesScreen
        Get.back();
      }

      Get.snackbar(
        isEditMode.value ? 'Batch Updated' : 'Batch Created',
        'Successfully saved ${batchNameController.text}',
        backgroundColor: AppColors.darkGreen,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyStudentAssignment() {
    // This part might need API support for assigning students to batch
    // For now keeping it local or showing a placeholder message
    Get.back();
    Get.snackbar(
      'Notice',
      'Student assignment is currently managed via Student Profile',
      backgroundColor: AppColors.primaryBrand,
      colorText: AppColors.white,
    );
  }

  @override
  void onClose() {
    batchNameController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    batchFeeController.dispose();
    super.onClose();
  }
}
