import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/data/models/daily_update_model.dart';
import 'package:tuoora/data/repositories_impl/daily_update_repository_impl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tuoora/data/models/batch_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';

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

  final triedToSave = false.obs;
  final subjectError = RxnString();
  final messageError = RxnString();

  bool validateForm() {
    bool isValid = true;

    if (subjectController.text.trim().isEmpty) {
      subjectError.value = 'Topic is required';
      isValid = false;
    } else {
      subjectError.value = null;
    }

    if (messageController.text.trim().isEmpty) {
      messageError.value = 'Message content is required';
      isValid = false;
    } else {
      messageError.value = null;
    }

    return isValid;
  }

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
      AppSnackBar.error('Failed to load batches: $e');
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
      AppSnackBar.error('Failed to load updates: $e');
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
      AppSnackBar.error('Could not pick files: $e');
    }
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  Future<void> broadcastUpdate() async {
    triedToSave.value = true;
    if (!validateForm()) return;

    // When the audience is a specific batch we must have a batch selected,
    // otherwise the request goes out with target_type=batch and no batch_id
    // and the backend rejects it.
    final targetsBatch =
        selectedRecipient.value != UpdateRecipient.parents &&
        selectedAudience.value == UpdateTargetType.batch;
    if (targetsBatch && selectedBatch.value == null) {
      AppSnackBar.error('Please select a batch for this update.');
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
        // No per-student targeting exists in this screen — only "All
        // Students" or "Specific Batch". studentId must stay null so we
        // never send a bogus student_id (a hardcoded mock here used to make
        // "All Students" broadcasts fail intermittently).
        batchId: targetsBatch ? selectedBatch.value?.id : null,
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
      triedToSave.value = false;
      subjectError.value = null;
      messageError.value = null;

      Get.back();
      AppSnackBar.success('Update broadcasted successfully');
    } catch (e) {
      AppSnackBar.error('Failed to broadcast update: $e');
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
