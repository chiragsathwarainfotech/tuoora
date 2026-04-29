import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/data/repositories/institute_repository.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:fee_easy/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';

class SignupController extends GetxController {
  final InstituteRepository _repository;
  final _authService = Get.find<AuthService>();

  SignupController(this._repository);

  final instituteNameController = TextEditingController();
  final instituteOwnerNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final phoneController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();

  final otpController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  final selectedLogoPath = Rxn<String>();
  final _picker = ImagePicker();

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> pickLogo() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        selectedLogoPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final instituteName = instituteNameController.text.trim();

    if (instituteName.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    final passwordError = ValidationUtils.validatePassword(password);
    if (passwordError != null) {
      Get.snackbar(
        'Invalid Password',
        passwordError,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final message = await _repository.registerInstitute({
        'email': email,
        'password': password,
        'institute_name': instituteName,
      });

      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      Get.toNamed(AppRoutes.instituteOtp);
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    final email = emailController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter OTP',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final token = await _repository.verifyOtp({'email': email, 'otp': otp});

      final user = User(
        id: 0,
        name: instituteNameController.text,
        email: email,
        token: token,
        role: 'INSTITUTE',
        instituteName: instituteNameController.text,
      );

      await _authService.saveSession(user);

      Get.snackbar(
        'Success',
        'OTP verified successfully.',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );

      Get.toNamed(AppRoutes.instituteProfileSetup);
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeProfile() async {
    if (instituteOwnerNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressLine1Controller.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        countryController.text.isEmpty ||
        pincodeController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final Map<String, dynamic> data = {
        'name': instituteOwnerNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressLine1Controller.text.trim(),
        'address_line_2': addressLine2Controller.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'country': countryController.text.trim(),
        'institute_name': instituteNameController.text.trim(),
        'pincode': pincodeController.text.trim(),
      };

      if (selectedLogoPath.value != null) {
        data['logo_url'] = selectedLogoPath.value;
      }

      await _repository.updateProfile(data);

      Get.offAllNamed(AppRoutes.instituteDashboard);
      Get.snackbar(
        'Success',
        'Profile created successfully',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Setup Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    instituteNameController.dispose();
    instituteOwnerNameController.dispose();
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
