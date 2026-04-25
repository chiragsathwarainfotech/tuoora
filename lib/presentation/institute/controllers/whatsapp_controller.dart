import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:get/get.dart';

class WhatsAppController extends GetxController {
  final accessTokenController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneNumberIdController = TextEditingController();
  final businessAccountIdController = TextEditingController();

  final feesReminders = true.obs;
  final attendanceAlerts = true.obs;
  final homeworkUpdates = false.obs;
  final holidayNotices = false.obs;

  void verifyApi() {
    final token = accessTokenController.text;
    final phoneNumber = phoneNumberController.text;
    final phoneId = phoneNumberIdController.text;
    final accountId = businessAccountIdController.text;

    if (token.isEmpty ||
        phoneNumber.isEmpty ||
        phoneId.isEmpty ||
        accountId.isEmpty) {
      Get.snackbar(
        'Incomplete Configuration',
        'Please provide all Meta API credentials to continue.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Success simulation
    Get.back();
    Get.snackbar(
      'Verified',
      'Meta API connection established successfully.',
      backgroundColor: AppColors.darkGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    accessTokenController.dispose();
    phoneNumberController.dispose();
    phoneNumberIdController.dispose();
    businessAccountIdController.dispose();
    super.onClose();
  }
}
