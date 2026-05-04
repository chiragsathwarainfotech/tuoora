import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/enums/update_enums.dart';
import 'package:fee_easy/data/models/daily_update_model.dart';
import 'package:fee_easy/data/repositories_impl/daily_update_repository_impl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fee_easy/data/models/batch_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatesController extends GetxController {
  final DailyUpdateRepositoryImpl _updateRepository;
  final InstituteRepositoryImpl _instituteRepository;

  UpdatesController(this._updateRepository, this._instituteRepository);

  final updatesList = <DailyUpdate>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;

  // Create Update State
  final selectedCategory = UpdateCategory.Academic.obs;
  final selectedRecipient = UpdateRecipient.students.obs;
  final selectedAudience = UpdateTargetType.all.obs;
  final selectedBatch = Rxn<Batch>();

  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final attachments = <String>[].obs;
  final appNotificationEnabled = true.obs;
  final whatsappEnabled = false.obs;

  final availableBatches = <Batch>[].obs;
  final isLoadingBatches = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpdates();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    try {
      isLoadingBatches.value = true;
      final response = await _instituteRepository.listBatches();
      availableBatches.assignAll(response.items);
      if (availableBatches.isNotEmpty) {
        selectedBatch.value = availableBatches.first;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load batches: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoadingBatches.value = false;
    }
  }

  Future<void> fetchUpdates() async {
    isLoading.value = true;
    try {
      final updates = await _updateRepository.listDailyUpdates();
      updatesList.assignAll(updates);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load updates: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAttachments() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
      );

      if (result != null) {
        attachments.addAll(result.paths.whereType<String>());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not pick files: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  Future<void> broadcastUpdate() async {
    if (subjectController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isCreating.value = true;
      final dailyUpdate = DailyUpdate(
        recipient: selectedRecipient.value,
        targetType: selectedAudience.value,
        topic: subjectController.text,
        description: messageController.text,
        category: selectedCategory.value,
        studentId: selectedAudience.value == UpdateTargetType.all
            ? 7
            : null, // Mock ID
        batchId: selectedAudience.value == UpdateTargetType.batch
            ? selectedBatch.value?.id
            : null,
      );

      await _updateRepository.createDailyUpdate(dailyUpdate.toJson());

      await fetchUpdates();

      // Reset fields
      subjectController.clear();
      messageController.clear();
      attachments.clear();
      selectedCategory.value = UpdateCategory.Academic;
      selectedRecipient.value = UpdateRecipient.students;
      selectedAudience.value = UpdateTargetType.all;
      if (availableBatches.isNotEmpty) {
        selectedBatch.value = availableBatches.first;
      }

      Get.back();
      Get.snackbar(
        'Success',
        'Update broadcasted successfully',
        backgroundColor: AppColors.darkGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to broadcast update: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
