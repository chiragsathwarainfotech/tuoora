import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';

class SignupController extends GetxController {
  // Signup fields
  final instituteNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Profile setup fields
  final phoneController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();

  // OTP field
  final otpController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;

  Future<void> register() async {
    if (instituteNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed(AppRoutes.instituteOtp);
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    isLoading.value = true;
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed(AppRoutes.instituteProfileSetup);
    } catch (e) {
      Get.snackbar('Verification Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeProfile() async {
    if (phoneController.text.isEmpty ||
        addressLine1Controller.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        countryController.text.isEmpty ||
        pincodeController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields');
      return;
    }

    isLoading.value = true;
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppRoutes.instituteDashboard);
      Get.snackbar('Success', 'Institute profile setup complete!');
    } catch (e) {
      Get.snackbar('Setup Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    instituteNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
