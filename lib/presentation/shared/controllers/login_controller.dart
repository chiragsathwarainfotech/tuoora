import 'dart:async';

import 'package:tuoora/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/data/repositories/auth_repository.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/services/institute_account_status_handler.dart';
import 'package:tuoora/core/services/push_notification_service.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/config/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;
  final AuthService _authService = Get.find<AuthService>();

  LoginController(this._authRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final stayAuthenticated = false.obs;

  final emailError = RxnString();
  final passwordError = RxnString();
  final accountError = RxnString();

  String _activeRole = 'INSTITUTE';

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleStayAuthenticated() =>
      stayAuthenticated.value = !stayAuthenticated.value;

  Future<void> login(String role) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    emailError.value = email.isEmpty ? 'Email is required' : null;
    passwordError.value = password.isEmpty ? 'Password is required' : null;
    if (emailError.value != null || passwordError.value != null) return;

    isLoading.value = true;
    accountError.value = null;
    try {
      dynamic user;
      if (role == 'INSTITUTE') {
        user = await _authRepository.loginInstitute(email, password);
      } else if (role == 'STUDENT') {
        user = await _authRepository.loginStudent(email, password);
      }

      if (user != null) {
        if (role == 'INSTITUTE' && !user.isEmailVerified) {
          accountError.value = AppStrings.errEmailNotVerified;
          await Future<void>.delayed(const Duration(seconds: 10));
          Get.toNamed(
            AppRoutes.instituteOtp,
            arguments: {'email': email, 'password': password},
          );
          return;
        }

        await _authService.saveSession(
          user,
          stayAuthenticated: stayAuthenticated.value,
          loggedIn: true,
          email: email,
          password: stayAuthenticated.value ? password : null,
          role: role,
        );
        if (Get.isRegistered<PushNotificationService>()) {
          unawaited(Get.find<PushNotificationService>().syncToken());
        }
        _navigateToDashboard(role);
      }
    } on AccountStatusException catch (e) {
      accountError.value = e.message;
    } catch (e) {
      AppSnackBar.error(e.toString(), title: AppStrings.loginFailed);
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToDashboard(String role) {
    if (role == 'INSTITUTE') {
      final isProfileSetup = _authService.currentUser?.isProfileSetup ?? true;
      if (isProfileSetup) {
        Get.offAllNamed(AppRoutes.instituteDashboard);
      } else {
        Get.offAllNamed(AppRoutes.instituteProfileSetup);
      }
    } else if (role == 'STUDENT') {
      Get.offAllNamed(AppRoutes.studentDashboard);
    }
  }

  @override
  void onReady() {
    super.onReady();
    _captureRole();
    _prefillCredentials();
  }

  void _captureRole() {
    final arg = Get.arguments;
    if (arg is String && arg.isNotEmpty) {
      _activeRole = arg.toUpperCase();
    }
  }

  void _prefillCredentials() {
    final rememberedEmail = _authService.rememberedEmailFor(_activeRole);
    final rememberedPassword = _authService.rememberedPasswordFor(_activeRole);

    emailController.clear();
    passwordController.clear();
    emailError.value = null;
    passwordError.value = null;
    stayAuthenticated.value = false;

    if (rememberedEmail != null) {
      emailController.text = rememberedEmail;
      if (rememberedPassword != null) {
        passwordController.text = rememberedPassword;
      }
      stayAuthenticated.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _captureRole();
    _prefillCredentials();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
