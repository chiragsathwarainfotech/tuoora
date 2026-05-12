import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:intl/intl.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/core/api/api_exception.dart';

class HomeworkController extends GetxController {
  final BatchModel batch;
  final InstituteRepositoryImpl _repository =
      Get.find<InstituteRepositoryImpl>();

  final homeworks = <HomeworkModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  HomeworkController(this.batch);

  @override
  void onInit() {
    super.onInit();
    fetchHomeworks();

    titleController.addListener(() {
      if (triedToSave.value && titleError.value != null) {
        titleError.value = null;
      }
    });

    ever(dueDate, (_) {
      if (triedToSave.value && dateError.value != null) {
        dateError.value = null;
      }
    });
  }

  Future<void> fetchHomeworks() async {
    try {
      isLoading.value = true;
      final response = await _repository.getHomeworks(int.parse(batch.id));
      homeworks.assignAll(response);
    } catch (e) {
      AppSnackbar.error('Failed to fetch homeworks: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  List<HomeworkModel> get filteredHomeworks {
    if (searchQuery.isEmpty) return homeworks;
    return homeworks
        .where(
          (h) =>
              h.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              h.description.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
        )
        .toList();
  }

  // Create Homework Form State
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDate = Rxn<DateTime>();
  final selectedAttachment = Rxn<String>();

  final triedToSave = false.obs;
  final titleError = RxnString();
  final dateError = RxnString();

  bool validateForm() {
    bool isValid = true;

    final tErr = ValidationUtils.validateRequired(
      titleController.text,
      'Title',
    );
    titleError.value = tErr;
    if (tErr != null) isValid = false;

    final dErr = ValidationUtils.validateDateSelection(
      dueDate.value,
      'due date',
    );
    dateError.value = dErr;
    if (dErr != null) isValid = false;

    return isValid;
  }

  Future<void> pickAttachment() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedAttachment.value = result.files.single.path;
      }
    } catch (e) {
      AppSnackbar.error('Failed to pick file: $e');
    }
  }

  void removeAttachment() {
    selectedAttachment.value = null;
  }

  Future<void> createHomework() async {
    triedToSave.value = true;
    if (!validateForm()) return;

    try {
      // Show full screen non-dismissible loader
      CommonLoading.show();

      final Map<String, dynamic> data = {
        'batch_id': batch.id,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'due_date': DateFormat('yyyy-MM-dd').format(dueDate.value!),
      };

      if (selectedAttachment.value != null) {
        data['attachment'] = selectedAttachment.value;
      }

      await _repository.createHomework(data);
      await fetchHomeworks();

      clearForm();

      // Close loader
      CommonLoading.dismiss();
      // Close creation dialog
      Get.back();

      AppSnackbar.success('Homework created successfully');
    } catch (e) {
      // Close loader if open
      CommonLoading.dismiss();

      if (e is ValidationException) {
        _handleValidationErrors(e.errors);
        AppSnackbar.error('Please correct the highlighted errors');
      } else {
        AppSnackbar.error('Failed to create homework: ${e.toString()}');
      }
    }
  }

  void _handleValidationErrors(Map<String, dynamic> errors) {
    if (errors.containsKey('title')) {
      titleError.value = (errors['title'] as List).first.toString();
    }
    if (errors.containsKey('due_date')) {
      dateError.value = (errors['due_date'] as List).first.toString();
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    dueDate.value = null;
    selectedAttachment.value = null;
    triedToSave.value = false;
    titleError.value = null;
    dateError.value = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
