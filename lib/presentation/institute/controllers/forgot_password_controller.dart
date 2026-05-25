import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/data/repositories/auth_repository.dart';
import 'package:tuoora/config/app_routes.dart';
import 'dart:async';
import 'package:tuoora/core/constants/app_colors.dart';

class ForgotPasswordController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  ForgotPasswordController();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final timerSeconds = 60.obs;
  final canResend = false.obs;
  Timer? _timer;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
        colorText: AppColors.errorRed,
      );
      return;
    }

    isLoading.value = true;
    try {
      final message = await _authRepository.forgotPassword(email);
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
      Get.toNamed(AppRoutes.instituteResetPassword, arguments: email);
      startTimer();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
        colorText: AppColors.errorRed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final password = passwordController.text.trim();

    if (otp.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
        colorText: AppColors.errorRed,
      );
      return;
    }

    final passwordError = ValidationUtils.validatePassword(password);
    if (passwordError != null) {
      Get.snackbar(
        'Invalid Password',
        passwordError,
        backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
        colorText: AppColors.errorRed,
      );
      return;
    }

    isLoading.value = true;
    try {
      final message = await _authRepository.resetPassword({
        'email': email,
        'otp': otp,
        'password': password,
      });
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
      Get.offAllNamed(AppRoutes.login, arguments: 'INSTITUTE');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
        colorText: AppColors.errorRed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    canResend.value = false;
    timerSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    isLoading.value = true;
    try {
      await _authRepository.forgotPassword(email);
      Get.snackbar(
        'Success',
        'OTP resend successfully',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
      startTimer();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
        colorText: AppColors.errorRed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is String) {
      emailController.text = Get.arguments;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
