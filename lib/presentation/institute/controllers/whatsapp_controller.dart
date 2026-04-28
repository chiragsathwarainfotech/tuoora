import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/data/models/whatsapp_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:get/get.dart';

class WhatsAppController extends GetxController {
  final InstituteRepositoryImpl _repository = Get.find<InstituteRepositoryImpl>();

  final accessTokenController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneNumberIdController = TextEditingController();
  final businessAccountIdController = TextEditingController();

  final feesReminders = true.obs;
  final attendanceAlerts = true.obs;
  final homeworkUpdates = false.obs;
  final holidayNotices = false.obs;

  final isLoading = false.obs;
  final currentSettings = Rxn<WhatsAppSettings>();

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      final settings = await _repository.getWhatsAppSettings();
      if (settings != null) {
        currentSettings.value = settings;
        _preFillControllers(settings);
      }
    } catch (e) {
      debugPrint('Error fetching WhatsApp settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _preFillControllers(WhatsAppSettings settings) {
    accessTokenController.text = settings.accessToken;
    phoneNumberController.text = settings.phoneNumber;
    phoneNumberIdController.text = settings.phoneNumberId;
    businessAccountIdController.text = settings.businessAccountId;
  }

  Future<void> saveSettings() async {
    final token = accessTokenController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final phoneId = phoneNumberIdController.text.trim();
    final accountId = businessAccountIdController.text.trim();

    if (token.isEmpty || phoneNumber.isEmpty || phoneId.isEmpty || accountId.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please provide all Meta API credentials to continue.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (phoneNumber.length < 10) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid phone number.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final data = {
        'phone_number': phoneNumber,
        'access_token': token,
        'phone_number_id': phoneId,
        'business_account_id': accountId,
      };

      WhatsAppSettings savedSettings;
      if (currentSettings.value != null) {
        savedSettings = await _repository.updateWhatsAppSettings(data);
      } else {
        savedSettings = await _repository.saveWhatsAppSettings(data);
      }
      
      currentSettings.value = savedSettings;

      Get.back();
      Get.snackbar(
        'Success',
        'WhatsApp settings saved successfully.',
        backgroundColor: AppColors.darkGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save settings: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
