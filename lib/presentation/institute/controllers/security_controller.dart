import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:get/get.dart';

class SecurityController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void toggleCurrentPasswordVisibility() =>
      isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void updatePassword() {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill in all password fields.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass.length < 8) {
      Get.snackbar(
        'Weak Password',
        'New password must be at least 8 characters long.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass != confirm) {
      Get.snackbar(
        'Mismatch',
        'New password and confirm password do not match.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Success simulation
    Get.back();
    Get.snackbar(
      'Success',
      'Your password has been updated securely.',
      backgroundColor: AppColors.darkGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );

    // Clear fields
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
