import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class ResourcesController extends GetxController {
  final BatchModel batch;
  final InstituteRepositoryImpl _repository =
      Get.find<InstituteRepositoryImpl>();

  final resources = <ResourceModel>[].obs;
  final isLoading = false.obs;

  ResourcesController(this.batch);

  @override
  void onInit() {
    super.onInit();
    fetchResources();
  }

  Future<void> fetchResources() async {
    try {
      isLoading.value = true;
      final response = await _repository.getResources(int.parse(batch.id));
      resources.assignAll(response);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch resources: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Dialog Controllers
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedFileName = ''.obs;
  final selectedFilePath = ''.obs;
  final selectedType = ResourceType.document.obs;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        selectedFilePath.value = result.files.single.path!;
        selectedFileName.value = result.files.single.name;

        final extension = selectedFileName.value.split('.').last.toLowerCase();
        if (['jpg', 'jpeg', 'png'].contains(extension)) {
          selectedType.value = ResourceType.image;
        } else if (['mp4', 'mov', 'avi'].contains(extension)) {
          selectedType.value = ResourceType.video;
        } else {
          selectedType.value = ResourceType.document;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file: ${e.toString()}');
    }
  }

  Future<void> uploadResource() async {
    if (subjectController.text.isEmpty || selectedFilePath.isEmpty) {
      Get.snackbar('Error', 'Please provide a title and select a file');
      return;
    }

    try {
      isLoading.value = true;

      final String typeStr = selectedType.value == ResourceType.image
          ? 'image'
          : (selectedType.value == ResourceType.video ? 'video' : 'document');

      final Map<String, dynamic> data = {
        'batch_id': batch.id,
        'title': subjectController.text,
        'description': descriptionController.text,
        'file_type': typeStr,
        'file': selectedFilePath.value,
      };

      final responseData = await _repository.uploadResource(data);

      final newResource = ResourceModel.fromJson(responseData);
      resources.insert(0, newResource);

      clearForm();
      Get.back();
      Get.snackbar('Success', 'Resource uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload resource: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    subjectController.clear();
    descriptionController.clear();
    selectedFileName.value = '';
    selectedFilePath.value = '';
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
