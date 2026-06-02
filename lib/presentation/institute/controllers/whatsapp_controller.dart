import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/data/models/whatsapp_settings_model.dart';
import 'package:flutter/material.dart';
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
      AppSnackBar.warning('Enter all credentials');
      return;
    }

    if (phoneNumber.length < 10) {
      AppSnackBar.warning('Invalid phone number');
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
      AppSnackBar.success('Settings saved');
    } catch (e) {
      AppSnackBar.error('Failed to save settings');
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

