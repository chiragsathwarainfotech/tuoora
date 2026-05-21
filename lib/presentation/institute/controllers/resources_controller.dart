import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/presentation/institute/models/resource_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';

class ResourcesController extends GetxController {
  final BatchModel batch;
  final InstituteRepositoryImpl _repository =
      Get.find<InstituteRepositoryImpl>();

  final resources = <ResourceModel>[].obs;

  void removeResource(String id) {
    resources.removeWhere((r) => r.id == id);
  }

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
      AppSnackBar.error('Failed to fetch resources: ${e.toString()}');
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

  final triedToSave = false.obs;
  final subjectError = RxnString();
  final fileError = RxnString();

  bool validateForm() {
    bool isValid = true;

    if (subjectController.text.trim().isEmpty) {
      subjectError.value = 'Title is required';
      isValid = false;
    } else {
      subjectError.value = null;
    }

    if (selectedFilePath.isEmpty) {
      fileError.value = 'Please select a file';
      isValid = false;
    } else {
      fileError.value = null;
    }

    return isValid;
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final extension = file.name.split('.').last.toLowerCase();
        final isVideo = ['mp4', 'mov', 'avi'].contains(extension);

        if (isVideo) {
          final double sizeInMb = file.size / (1024 * 1024);
          if (sizeInMb > 50) {
            AppSnackBar.error(
              'Video files must be under 50 MB. Selected file is ${sizeInMb.toStringAsFixed(2)} MB.',
              title: 'File Too Large',
            );
            return;
          }
          selectedType.value = ResourceType.video;
        } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
          selectedType.value = ResourceType.image;
        } else {
          selectedType.value = ResourceType.document;
        }

        selectedFilePath.value = file.path!;
        selectedFileName.value = file.name;
        fileError.value = null;
      }
    } catch (e) {
      AppSnackBar.error('Failed to pick file: ${e.toString()}');
    }
  }

  Future<void> uploadResource() async {
    triedToSave.value = true;
    if (!validateForm()) return;

    try {
      CommonLoading.show();

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

      CommonLoading.dismiss();
      // Close creation dialog
      Get.back();

      AppSnackBar.success('Resource uploaded successfully');
    } catch (e) {
      // Close loader if open
      CommonLoading.dismiss();
      AppSnackBar.error('Failed to upload resource: ${e.toString()}');
    }
  }

  void clearForm() {
    subjectController.clear();
    descriptionController.clear();
    selectedFileName.value = '';
    selectedFilePath.value = '';
    triedToSave.value = false;
    subjectError.value = null;
    fileError.value = null;
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
