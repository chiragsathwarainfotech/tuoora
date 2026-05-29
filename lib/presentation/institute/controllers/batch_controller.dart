import 'package:tuoora/core/widgets/app_pickers.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/core/widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/api/api_exception.dart';

class BatchController extends GetxController {
  final InstituteRepositoryImpl _repository;

  BatchController(this._repository);

  final batchesList = <BatchModel>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;

  // Debounced search for the batches list (separate from [searchQuery]
  // which is used by the assign-students flow).
  final batchSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    batchNameController.addListener(() => _clearError(batchNameError));
    subjectController.addListener(() => _clearError(subjectError));
    batchFeeController.addListener(() => _clearError(feeError));
    debounce(
      batchSearchQuery,
      (_) => loadBatches(isRefresh: true),
      time: const Duration(milliseconds: 500),
    );
  }

  void onBatchSearchChanged(String query) {
    batchSearchQuery.value = query;
  }

  void _clearError(RxnString error) {
    if (triedToSave.value && error.value != null) {
      error.value = null;
    }
  }

  final isEditMode = false.obs;
  final batchNameController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final batchFeeController = TextEditingController();
  final classroomController = TextEditingController();
  final startTime = const TimeOfDay(hour: 0, minute: 0).obs;
  final endTime = const TimeOfDay(hour: 0, minute: 0).obs;
  final selectedDays = <String>[].obs;
  final selectedStudentIds = <String>[].obs;
  final searchQuery = ''.obs;
  final currentEditingBatchId = ''.obs;
  final allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final triedToSave = false.obs;
  final batchNameError = RxnString();
  final subjectError = RxnString();
  final feeError = RxnString();
  final daysError = RxnString();

  bool validateForm() {
    bool isValid = true;

    final nameVal = ValidationUtils.validateRequired(
      batchNameController.text,
      'Batch name',
    );
    batchNameError.value = nameVal;
    if (nameVal != null) isValid = false;

    final subjectVal = ValidationUtils.validateRequired(
      subjectController.text,
      'Subject',
    );
    subjectError.value = subjectVal;
    if (subjectVal != null) isValid = false;

    final feeVal = ValidationUtils.validateAmount(
      batchFeeController.text,
      'Batch fee',
    );
    feeError.value = feeVal;
    if (feeVal != null) isValid = false;

    final daysVal = ValidationUtils.validateDaysSelection(
      selectedDays.toList(),
    );
    daysError.value = daysVal;
    if (daysVal != null) isValid = false;

    return isValid;
  }

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
      final response = await _repository.listBatches(
        page: currentPage.value,
        search: batchSearchQuery.value.trim().isEmpty
            ? null
            : batchSearchQuery.value.trim(),
      );
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
      AppSnackBar.error('Failed to load batches: ${e.toString()}');
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
    classroomController.clear();
    startTime.value = const TimeOfDay(hour: 0, minute: 0);
    endTime.value = const TimeOfDay(hour: 0, minute: 0);
    selectedDays.clear();
    selectedStudentIds.clear();
    searchQuery.value = '';
    currentEditingBatchId.value = '';
    triedToSave.value = false;
    batchNameError.value = null;
    subjectError.value = null;
    feeError.value = null;
    daysError.value = null;
  }

  void initEditMode(BatchModel batch) {
    isEditMode.value = true;
    currentEditingBatchId.value = batch.id;
    batchNameController.text = batch.title;
    subjectController.text = batch.subject;
    descriptionController.text = batch.description;
    batchFeeController.text = batch.baseFee.toStringAsFixed(0);
    classroomController.text = batch.classroom ?? '';

    final times = batch.time.split(' - ');
    if (times.length == 2) {
      startTime.value = _parseTime(times[0]);
      endTime.value = _parseTime(times[1]);
    }

    selectedDays.assignAll(batch.days);
    searchQuery.value = '';
    triedToSave.value = false;
    batchNameError.value = null;
    subjectError.value = null;
    feeError.value = null;
    daysError.value = null;
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
    _clearError(daysError);
  }

  void toggleStudent(String id) {
    if (selectedStudentIds.contains(id)) {
      selectedStudentIds.remove(id);
    } else {
      selectedStudentIds.add(id);
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await AppPickers.time(
      context,
      initialTime: startTime.value,
    );
    if (picked != null) startTime.value = picked;
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await AppPickers.time(
      context,
      initialTime: endTime.value,
    );
    if (picked != null) endTime.value = picked;
  }

  void deleteBatchWithConfirmation(String id) {
    CommonDialog.showDeleteConfirmation(
      title: 'Delete Batch',
      description: 'Are you sure you want to delete this batch?',
      onConfirm: () async {
        try {
          isLoading.value = true;
          await _repository.deleteBatch(int.parse(id));
          batchesList.removeWhere((batch) => batch.id == id);
          AppSnackBar.success('Batch deleted successfully', title: 'Deleted');
        } catch (e) {
          AppSnackBar.error(e.toString());
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> saveBatch(BuildContext context) async {
    triedToSave.value = true;
    if (!validateForm()) return;

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
      'classroom': classroomController.text.trim(),
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
      AppSnackBar.success(
        'Successfully saved ${batchNameController.text}',
        title: isEditMode.value ? 'Batch Updated' : 'Batch Created',
      );
    } catch (e) {
      if (e is ValidationException) {
        _handleValidationErrors(e.errors);
        AppSnackBar.error('Please correct the highlighted errors');
      } else {
        AppSnackBar.error(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _handleValidationErrors(Map<String, dynamic> errors) {
    if (errors.containsKey('name')) {
      batchNameError.value = (errors['name'] as List).first.toString();
    }
    if (errors.containsKey('subject')) {
      subjectError.value = (errors['subject'] as List).first.toString();
    }
    if (errors.containsKey('fees')) {
      feeError.value = (errors['fees'] as List).first.toString();
    }
    if (errors.containsKey('days')) {
      daysError.value = (errors['days'] as List).first.toString();
    }
  }

  void applyStudentAssignment() {
    // This part might need API support for assigning students to batch
    // For now keeping it local or showing a placeholder message
    Get.back();
    AppSnackBar.warning(
      'Student assignment is currently managed via Student Profile',
      title: 'Notice',
    );
  }

  @override
  void onClose() {
    batchNameController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    batchFeeController.dispose();
    classroomController.dispose();
    super.onClose();
  }
}
