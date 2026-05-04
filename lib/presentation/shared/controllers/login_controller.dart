import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/data/repositories/auth_repository.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:fee_easy/config/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository;
  final AuthService _authService = Get.find<AuthService>();

  LoginController(this._authRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final stayAuthenticated = false.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleStayAuthenticated() =>
      stayAuthenticated.value = !stayAuthenticated.value;

  Future<void> login(String role) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;
    try {
      dynamic user;
      if (role == 'INSTITUTE') {
        user = await _authRepository.loginInstitute(email, password);
      } else if (role == 'STUDENT') {
        user = await _authRepository.loginStudent(email, password);
      } else if (role == 'PARENT') {
        user = await _authRepository.loginParent(email, password);
      }

      if (user != null) {
        // Use the actual email/password entered, as user object might not have them
        await _authService.saveSession(
          user, 
          stayAuthenticated: stayAuthenticated.value,
          email: email,
          password: stayAuthenticated.value ? password : null,
        );
        _navigateToDashboard(role);
      }
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToDashboard(String role) {
    if (role == 'INSTITUTE') {
      Get.offAllNamed(AppRoutes.instituteDashboard);
    } else if (role == 'STUDENT') {
      Get.offAllNamed(AppRoutes.studentDashboard);
    } else if (role == 'PARENT') {
      Get.offAllNamed(AppRoutes.parentDashboard);
    }
  }

  @override
  void onReady() {
    super.onReady();
    _prefillCredentials();
  }

  void _prefillCredentials() {
    final rememberedEmail = _authService.rememberedEmail;
    final rememberedPassword = _authService.rememberedPassword;
    print('LoginController: Prefilling credentials. Email: $rememberedEmail');
    
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
    // Also try onInit just in case
    _prefillCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
