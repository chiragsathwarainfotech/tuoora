import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

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
  }

  Future<void> fetchHomeworks() async {
    try {
      isLoading.value = true;
      final response = await _repository.getHomeworks(int.parse(batch.id));
      homeworks.assignAll(response);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch homeworks: ${e.toString()}');
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
      Get.snackbar('Error', 'Failed to pick file: $e');
    }
  }

  void removeAttachment() {
    selectedAttachment.value = null;
  }

  Future<void> createHomework() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a title');
      return;
    }
    if (dueDate.value == null) {
      Get.snackbar('Error', 'Please select a due date');
      return;
    }

    try {
      isLoading.value = true;
      final Map<String, dynamic> data = {
        'batch_id': batch.id,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'due_date': DateFormat('yyyy-MM-dd').format(dueDate.value!),
      };

      if (selectedAttachment.value != null) {
        data['attachment'] = selectedAttachment.value;
      }

      final response = await _repository.createHomework(data);

      // If response is the new homework, add it to list
      if (response != null) {
        final newHw = HomeworkModel.fromJson(response);
        homeworks.insert(0, newHw);
      } else {
        // Fallback: re-fetch
        fetchHomeworks();
      }

      clearForm();
      Get.back();
      Get.snackbar('Success', 'Homework created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create homework: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    dueDate.value = null;
    selectedAttachment.value = null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
