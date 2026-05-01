import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/data/models/institute_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
        colorText: Colors.white,
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
          color: Colors.white,
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
                style: AppTextStyles.manrope(
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
                style: AppTextStyles.manrope(
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
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
