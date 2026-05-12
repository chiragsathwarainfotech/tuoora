import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:get/get.dart';
import 'package:fee_easy/core/api/api_exception.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';

class SecurityController extends GetxController {
  final InstituteRepositoryImpl _instituteRepository;

  SecurityController(this._instituteRepository);

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  final triedToSave = false.obs;
  final currentPasswordError = RxnString();
  final newPasswordError = RxnString();
  final confirmPasswordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    currentPasswordController.addListener(
      () => _clearError(currentPasswordError),
    );
    newPasswordController.addListener(() => _clearError(newPasswordError));
    confirmPasswordController.addListener(
      () => _clearError(confirmPasswordError),
    );
  }

  void _clearError(RxnString error) {
    if (triedToSave.value && error.value != null) {
      error.value = null;
    }
  }

  void toggleCurrentPasswordVisibility() =>
      isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  Future<void> updatePassword() async {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    triedToSave.value = true;
    _resetErrors();

    final currentErr = ValidationUtils.validateRequired(
      current,
      'Current password',
    );
    currentPasswordError.value = currentErr;
    if (currentErr != null) return;

    final newErr = ValidationUtils.validatePassword(newPass);
    newPasswordError.value = newErr;
    if (newErr != null) return;

    final confirmErr = ValidationUtils.validateConfirmPassword(
      newPass,
      confirm,
    );
    confirmPasswordError.value = confirmErr;
    if (confirmErr != null) return;

    try {
      isLoading.value = true;
      final data = {
        'current_password': current,
        'new_password': newPass,
        'new_password_confirmation': confirm,
      };

      await _instituteRepository.changePassword(data);

      Get.back();
      Get.snackbar(
        'Success',
        'Your password has been updated securely.',
        backgroundColor: AppColors.darkGreen,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      _clearFields();
    } catch (e) {
      if (e is ValidationException) {
        _handleValidationErrors(e.errors);
      } else {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.redAccent,
          colorText: AppColors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _handleValidationErrors(Map<String, dynamic> errors) {
    if (errors.containsKey('current_password')) {
      currentPasswordError.value = (errors['current_password'] as List).first
          .toString();
    }
    if (errors.containsKey('new_password')) {
      newPasswordError.value = (errors['new_password'] as List).first
          .toString();
    }
    if (errors.containsKey('new_password_confirmation')) {
      confirmPasswordError.value = (errors['new_password_confirmation'] as List)
          .first
          .toString();
    }
  }

  void _resetErrors() {
    currentPasswordError.value = null;
    newPasswordError.value = null;
    confirmPasswordError.value = null;
  }

  void _clearFields() {
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
