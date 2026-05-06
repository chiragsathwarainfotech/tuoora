import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/data/repositories/institute_repository.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:fee_easy/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fee_easy/data/repositories/auth_repository.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'dart:async';

class SignupController extends GetxController {
  final _repository = Get.find<InstituteRepository>();
  final _authRepository = Get.find<AuthRepository>();
  final _authService = Get.find<AuthService>();

  SignupController();

  @override
  void onInit() {
    super.onInit();
    _prefillFromSession();
  }

  void _prefillFromSession() {
    final user = _authService.currentUser;
    if (user != null && user.role == 'INSTITUTE') {
      if (emailController.text.isEmpty) {
        emailController.text = user.email;
      }
      if (instituteNameController.text.isEmpty) {
        instituteNameController.text = user.instituteName ?? '';
      }
    }
  }

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
  final timerSeconds = 60.obs;
  final canResend = false.obs;
  Timer? _timer;

  final selectedLogoPath = Rxn<String>();
  final _picker = ImagePicker();

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  Future<void> pickLogo() async {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all32,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Logo Source',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v24,
            ListTile(
              leading: Container(
                padding: AppSpacing.all8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primaryBrand,
                ),
              ),
              title: Text(
                'Camera',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () => _handleImageSelection(ImageSource.camera),
            ),
            AppSpacing.v8,
            ListTile(
              leading: Container(
                padding: AppSpacing.all8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primaryBrand,
                ),
              ),
              title: Text(
                'Gallery',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () => _handleImageSelection(ImageSource.gallery),
            ),
            AppSpacing.v16,
          ],
        ),
      ),
    );
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    Get.back();
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
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
      startTimer();
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
        isProfileSetup: false,
      );

      await _authService.saveSession(user, stayAuthenticated: true);

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

      // Update local session with isProfileSetup = true
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        final updatedUser = User(
          id: currentUser.id,
          name: data['name'],
          email: currentUser.email,
          token: currentUser.token,
          role: currentUser.role,
          instituteName: data['institute_name'],
          phone: data['phone'],
          address: data['address'],
          city: data['city'],
          state: data['state'],
          pincode: data['pincode'],
          isProfileSetup: true,
        );
        await _authService.saveSession(updatedUser, stayAuthenticated: true);
      }

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
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
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
