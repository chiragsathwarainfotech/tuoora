import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/data/repositories/auth_repository.dart';
import 'package:tuoora/core/services/auth_service.dart';
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

  /// Inline per-field error messages rendered under each input. Replaces
  /// the old "Please fill in all fields" snackbar — a single shared toast
  /// can't point a finger at which field was wrong.
  final emailError = RxnString();
  final passwordError = RxnString();

  /// Tracks the role the login screen was opened for (read from
  /// [Get.arguments]). Drives per-role Remember Me prefill so an
  /// institute's credentials never leak into a student login attempt.
  String _activeRole = 'INSTITUTE';

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleStayAuthenticated() =>
      stayAuthenticated.value = !stayAuthenticated.value;

  Future<void> login(String role) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Inline per-field validation — both messages render under their
    // respective inputs so the user immediately sees which one's missing.
    emailError.value = email.isEmpty ? 'Email is required' : null;
    passwordError.value = password.isEmpty ? 'Password is required' : null;
    if (emailError.value != null || passwordError.value != null) return;

    isLoading.value = true;
    try {
      dynamic user;
      if (role == 'INSTITUTE') {
        user = await _authRepository.loginInstitute(email, password);
      } else if (role == 'STUDENT') {
        user = await _authRepository.loginStudent(email, password);
      }

      if (user != null) {
        // Use the actual email/password entered, as user object might not have them
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
    } catch (e) {
      AppSnackBar.error(e.toString(), title: 'Login Failed');
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToDashboard(String role) {
    if (role == 'INSTITUTE') {
      // The login response carries is_profile_setup. If the institute hasn't
      // finished onboarding, resume profile setup instead of the dashboard.
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

    // Always clear first so switching roles (Institute → Student) drops
    // any prefill left in the field from the previous role.
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
