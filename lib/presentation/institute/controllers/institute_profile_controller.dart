import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:tuoora/data/models/institute_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuoora/core/api/api_exception.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';

class InstituteProfileController extends GetxController {
  final InstituteRepositoryImpl _instituteRepository;

  InstituteProfileController(this._instituteRepository);

  // Current Profile Model
  final profile = Rxn<InstituteProfile>();

  // Observable fields for UI display
  final instituteName = "".obs;
  final profileImagePath = RxnString();
  final ownerName = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final addressLine1 = "".obs;
  final addressLine2 = "".obs;
  final city = "".obs;
  final state = "".obs;
  final country = "".obs;
  final pincode = "".obs;

  final isLoading = false.obs;
  final triedToSave = false.obs;

  final instituteNameError = RxnString();
  final ownerNameError = RxnString();
  final emailError = RxnString();
  final phoneError = RxnString();
  final pincodeError = RxnString();

  // Controllers for text fields (for editing)
  late TextEditingController nameController;
  late TextEditingController ownerController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController pincodeController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    fetchProfile();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: instituteName.value);
    ownerController = TextEditingController(text: ownerName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phone.value);
    addressLine1Controller = TextEditingController(text: addressLine1.value);
    addressLine2Controller = TextEditingController(text: addressLine2.value);
    cityController = TextEditingController(text: city.value);
    stateController = TextEditingController(text: state.value);
    countryController = TextEditingController(text: country.value);
    pincodeController = TextEditingController(text: pincode.value);

    _addListeners();
  }

  void _addListeners() {
    nameController.addListener(() => _clearError(instituteNameError));
    ownerController.addListener(() => _clearError(ownerNameError));
    emailController.addListener(() => _clearError(emailError));
    phoneController.addListener(() => _clearError(phoneError));
    pincodeController.addListener(() => _clearError(pincodeError));
  }

  void _clearError(RxnString error) {
    if (triedToSave.value && error.value != null) {
      error.value = null;
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _instituteRepository.getProfile();
      profile.value = data;

      instituteName.value = data.instituteName ?? '';
      ownerName.value = data.name;
      email.value = data.email;
      phone.value = data.phone;
      addressLine1.value = data.address ?? '';
      addressLine2.value = data.addressLine2 ?? '';
      city.value = data.city ?? '';
      state.value = data.state ?? '';
      country.value = data.country ?? 'India';
      pincode.value = data.pincode ?? '';

      if (data.logoUrl != null) {
        profileImagePath.value = data.logoUrl;
      }

      _initializeControllers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
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
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                Get.back();
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  profileImagePath.value = image.path;
                }
              },
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
                style: AppTextStyles.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                Get.back();
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  profileImagePath.value = image.path;
                }
              },
            ),
            AppSpacing.v16,
          ],
        ),
      ),
    );
  }

  Future<void> saveProfile() async {
    triedToSave.value = true;
    _resetErrors();

    final nameErr = ValidationUtils.validateRequired(
      nameController.text,
      'Institute name',
    );
    instituteNameError.value = nameErr;
    if (nameErr != null) return;

    final ownerErr = ValidationUtils.validateRequired(
      ownerController.text,
      'Owner name',
    );
    ownerNameError.value = ownerErr;
    if (ownerErr != null) return;

    final emailErr = ValidationUtils.validateEmail(emailController.text);
    emailError.value = emailErr;
    if (emailErr != null) return;

    final phoneErr = ValidationUtils.validatePhone(phoneController.text);
    phoneError.value = phoneErr;
    if (phoneErr != null) return;

    try {
      isLoading.value = true;
      final updateData = {
        'name': ownerController.text,
        'institute_name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressLine1Controller.text,
        'address_line_2': addressLine2Controller.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
        'pincode': pincodeController.text,
        if (profileImagePath.value != null) 'logo_url': profileImagePath.value,
      };

      await _instituteRepository.updateProfile(updateData);

      await fetchProfile();

      Get.back();
      Get.snackbar(
        'Profile Updated',
        'Institute details have been successfully saved.',
        backgroundColor: AppColors.darkGreen,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      if (e is ValidationException) {
        _handleValidationErrors(e.errors);
        AppSnackBar.error('Please correct the highlighted errors');
      } else {
        AppSnackBar.error('Failed to update profile: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _handleValidationErrors(Map<String, dynamic> errors) {
    if (errors.containsKey('institute_name')) {
      instituteNameError.value = (errors['institute_name'] as List).first
          .toString();
    }
    if (errors.containsKey('name')) {
      ownerNameError.value = (errors['name'] as List).first.toString();
    }
    if (errors.containsKey('email')) {
      emailError.value = (errors['email'] as List).first.toString();
    }
    if (errors.containsKey('phone')) {
      phoneError.value = (errors['phone'] as List).first.toString();
    }
    if (errors.containsKey('pincode')) {
      pincodeError.value = (errors['pincode'] as List).first.toString();
    }
  }

  void _resetErrors() {
    instituteNameError.value = null;
    ownerNameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    pincodeError.value = null;
  }

  void discardChanges() {
    _initializeControllers();
    Get.back();
  }

  void logout() async {
    final authService = Get.find<AuthService>();
    await authService.clearSession();
    Get.offAllNamed(AppRoutes.roleSelection);
  }

  @override
  void onClose() {
    nameController.dispose();
    ownerController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    super.onClose();
  }
}
