import 'package:fee_easy/presentation/institute/models/update_model.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatesController extends GetxController {
  final updatesList = <UpdateModel>[].obs;

  // Create Update State
  final selectedCategory = 'Fee Reminder'.obs;
  final selectedRecipient = 'Student'.obs;
  final selectedAudience = 'All Students'.obs;
  final selectedGrade = 'Grade 9'.obs;
  final selectedBatch = 'Evening • Batch A'.obs;

  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final attachments = <String>[].obs;
  final appNotificationEnabled = true.obs;
  final whatsappEnabled = false.obs;

  final availableGrades = ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'];
  final availableBatches = [
    'Evening • Batch A',
    'Morning • Advanced',
    'Evening • Batch B',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadMockUpdates();
  }

  void _loadMockUpdates() {
    updatesList.assignAll([
      UpdateModel(
        id: '1',
        category: 'Fee Reminder',
        audience: 'All Students',
        subject: 'March Tuition Fee Reminder',
        message:
            'Kindly clear the dues for March 2024 by 20th to avoid late fees.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      UpdateModel(
        id: '2',
        category: 'Holiday',
        audience: 'Grade 10',
        subject: 'Eid-ul-Fitr Holiday Notice',
        message:
            'The institute will remain closed on April 10th and 11th on account of Eid.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
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

  void broadcastUpdate() {
    if (subjectController.text.isEmpty || messageController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    String audienceLabel = selectedRecipient.value;
    if (selectedRecipient.value == 'Student' ||
        selectedRecipient.value == 'Both') {
      String prefix = selectedRecipient.value == 'Both'
          ? 'Students & Parents'
          : 'Students';
      if (selectedAudience.value == 'All Students') {
        audienceLabel = 'All $prefix';
      } else if (selectedAudience.value == 'Specific Batch') {
        audienceLabel = '$prefix - ${selectedBatch.value}';
      }
    }

    final newUpdate = UpdateModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: selectedCategory.value,
      audience: audienceLabel,
      subject: subjectController.text,
      message: messageController.text,
      date: DateTime.now(),
      attachments: List.from(attachments),
      appNotification: appNotificationEnabled.value,
      whatsapp: whatsappEnabled.value,
    );

    updatesList.insert(0, newUpdate);

    // Clear fields
    subjectController.clear();
    messageController.clear();
    attachments.clear();
    selectedCategory.value = 'Fee Reminder';
    selectedRecipient.value = 'Student';
    selectedAudience.value = 'All Students';
    selectedGrade.value = 'Grade 9';
    selectedBatch.value = 'Evening • Batch A';

    Get.back();
    Get.snackbar(
      'Update Broadcasted',
      'Your message has been sent to $audienceLabel.',
      backgroundColor: AppColors.darkGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
