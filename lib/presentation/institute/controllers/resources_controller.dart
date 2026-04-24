import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourcesController extends GetxController {
  final BatchModel batch;
  final resources = <ResourceModel>[].obs;

  ResourcesController(this.batch);

  @override
  void onInit() {
    super.onInit();
    _loadMockResources();
  }

  void _loadMockResources() {
    resources.assignAll([
      ResourceModel(
        id: '1',
        subject: 'Quantum Mechanics Notes',
        description: 'Chapter 1 and 2 detailed derivation notes.',
        fileName: 'quantum_notes_ch1.pdf',
        type: ResourceType.document,
        uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
        batchId: batch.id,
      ),
      ResourceModel(
        id: '2',
        subject: 'Lecture: Wave Function',
        description: 'Recording of the live session held on Monday.',
        fileName: 'wave_function_lecture.mp4',
        type: ResourceType.video,
        uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
        batchId: batch.id,
      ),
      ResourceModel(
        id: '3',
        subject: 'Reference Diagram',
        description: 'Schematic for the upcoming laboratory experiment.',
        fileName: 'experiment_diagram.png',
        type: ResourceType.image,
        uploadedAt: DateTime.now(),
        batchId: batch.id,
      ),
    ]);
  }

  // Dialog Controllers
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedFileName = ''.obs;
  final selectedType = ResourceType.document.obs;

  void uploadResource() {
    if (subjectController.text.isEmpty || selectedFileName.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    final newResource = ResourceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subjectController.text,
      description: descriptionController.text,
      fileName: selectedFileName.value,
      type: selectedType.value,
      uploadedAt: DateTime.now(),
      batchId: batch.id,
    );

    resources.insert(0, newResource);
    clearForm();
    Get.back();
    Get.snackbar('Success', 'Resource uploaded successfully');
  }

  void clearForm() {
    subjectController.clear();
    descriptionController.clear();
    selectedFileName.value = '';
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
