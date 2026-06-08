import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/data/repositories/institute_repository.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuoora/data/repositories/auth_repository.dart';
import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class SignupController extends GetxController {
  final _repository = Get.find<InstituteRepository>();
  final _authRepository = Get.find<AuthRepository>();
  final _authService = Get.find<AuthService>();

  SignupController();
  bool _fromLoginRedirect = false;

  @override
  void onInit() {
    super.onInit();
    _prefillFromSession();
    _prefillFromRouteArguments();
  }

  @override
  void onReady() {
    super.onReady();
    if (_fromLoginRedirect) {
      _fromLoginRedirect = false;
      _autoSendFreshOtpOnArrival();
    }
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
      if (instituteOwnerNameController.text.isEmpty) {
        instituteOwnerNameController.text = user.name;
      }
    }
  }

  void _prefillFromRouteArguments() {
    final args = Get.arguments;
    if (args is! Map) return;
    final email = args['email']?.toString();
    final password = args['password']?.toString();
    if (email != null && email.isNotEmpty) {
      emailController.text = email;
    }
    if (password != null && password.isNotEmpty) {
      passwordController.text = password;
    }
    _fromLoginRedirect = true;
  }

  Future<void> _autoSendFreshOtpOnArrival() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;
    isLoading.value = true;
    try {
      await _authRepository.forgotPassword(email);
    } catch (_) {
      // Resend manually after the 60-second cooldown.
    } finally {
      isLoading.value = false;
      startTimer();
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

  /// Inline per-field error messages for the signup + OTP flows. Replaces
  /// the old "Please fill in all fields" blanket snackbar so the user sees
  /// which specific input is missing or invalid.
  final instituteNameError = RxnString();
  final ownerNameError = RxnString();
  final emailError = RxnString();
  final passwordError = RxnString();
  final otpError = RxnString();
  // Profile-setup screen fields (completeProfile flow).
  final phoneError = RxnString();
  final addressLine1Error = RxnString();
  final cityError = RxnString();
  final stateError = RxnString();
  final countryError = RxnString();
  final pincodeError = RxnString();

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
              AppStrings.selectLogoSource,
              style: AppTextStyles.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
                AppStrings.labelCamera,
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
                AppStrings.labelGallery,
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (status.isPermanentlyDenied) {
          openAppSettings();
          return;
        } else if (!status.isGranted) {
          return;
        }
      } else if (source == ImageSource.gallery) {
        if (Platform.isIOS) {
          final status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            openAppSettings();
            return;
          } else if (!status.isGranted && !status.isLimited) {
            return;
          }
        } else {
          final storage = await Permission.storage.request();
          final photos = await Permission.photos.request();
          if (storage.isPermanentlyDenied || photos.isPermanentlyDenied) {
            openAppSettings();
            return;
          } else if (!storage.isGranted && !photos.isGranted) {
            return;
          }
        }
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        selectedLogoPath.value = image.path;
      }
    } catch (e) {
      AppSnackBar.error(AppStrings.errFailedPickImage);
    }
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final instituteName = instituteNameController.text.trim();
    final ownerName = instituteOwnerNameController.text.trim();

    // Per-field validation — each error renders under its own input.
    instituteNameError.value = instituteName.isEmpty
        ? 'Institute name is required'
        : null;
    ownerNameError.value = ownerName.isEmpty ? 'Owner name is required' : null;
    emailError.value = email.isEmpty ? 'Email is required' : null;
    passwordError.value = password.isEmpty ? 'Password is required' : null;
    if (instituteNameError.value != null ||
        ownerNameError.value != null ||
        emailError.value != null ||
        passwordError.value != null) {
      return;
    }

    if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email';
      return;
    }

    final pwdValidation = ValidationUtils.validatePassword(password);
    if (pwdValidation != null) {
      passwordError.value = pwdValidation;
      return;
    }

    isLoading.value = true;
    try {
      final message = await _repository.registerInstitute({
        'email': email,
        'name': ownerName,
        'password': password,
        'institute_name': instituteName,
      });

      AppSnackBar.success(message);

      Get.toNamed(AppRoutes.instituteOtp);
      startTimer();
    } catch (e) {
      AppSnackBar.error(
        e.toString().replaceAll('Exception: ', ''),
        title: AppStrings.registrationFailed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    final email = emailController.text.trim();

    if (otp.isEmpty) {
      otpError.value = 'OTP is required';
      return;
    }
    otpError.value = null;

    isLoading.value = true;
    try {
      final token = await _repository.verifyOtp({'email': email, 'otp': otp});

      final user = User(
        id: 0,
        name: instituteOwnerNameController.text,
        email: email,
        token: token,
        accessToken: token,
        refreshToken: '',
        role: 'INSTITUTE',
        instituteName: instituteNameController.text,
        isProfileSetup: false,
        emailVerifiedAt: DateTime.now().toUtc().toIso8601String(),
      );

      await _authService.saveSession(
        user,
        stayAuthenticated: true,
        loggedIn: false,
      );

      AppSnackBar.success(AppStrings.otpVerifiedSuccessfully);

      Get.toNamed(AppRoutes.instituteProfileSetup);
    } catch (e) {
      AppSnackBar.error(
        e.toString().replaceAll('Exception: ', ''),
        title: AppStrings.verificationFailed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeProfile() async {
    ownerNameError.value = instituteOwnerNameController.text.trim().isEmpty
        ? 'Owner name is required'
        : null;
    instituteNameError.value = instituteNameController.text.trim().isEmpty
        ? 'Institute name is required'
        : null;
    phoneError.value = phoneController.text.trim().isEmpty
        ? 'Phone number is required'
        : null;
    addressLine1Error.value = addressLine1Controller.text.trim().isEmpty
        ? 'Address is required'
        : null;
    cityError.value = cityController.text.trim().isEmpty
        ? 'City is required'
        : null;
    stateError.value = stateController.text.trim().isEmpty
        ? 'State is required'
        : null;
    countryError.value = countryController.text.trim().isEmpty
        ? 'Country is required'
        : null;
    pincodeError.value = pincodeController.text.trim().isEmpty
        ? 'Pincode is required'
        : null;
    if (ownerNameError.value != null ||
        instituteNameError.value != null ||
        phoneError.value != null ||
        addressLine1Error.value != null ||
        cityError.value != null ||
        stateError.value != null ||
        countryError.value != null ||
        pincodeError.value != null) {
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

      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        final updatedUser = User(
          id: currentUser.id,
          name: data['name'],
          email: currentUser.email,
          token: currentUser.token,
          accessToken: currentUser.accessToken,
          refreshToken: currentUser.refreshToken,
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
      AppSnackBar.success(AppStrings.profileCreatedSuccessfully);
    } catch (e) {
      AppSnackBar.error(
        e.toString().replaceAll('Exception: ', ''),
        title: AppStrings.setupFailed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    canResend.value = false;
    timerSeconds.value = 15;
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
      AppSnackBar.success(AppStrings.msgOtpResent);
      startTimer();
    } catch (e) {
      AppSnackBar.error(e.toString());
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
