import 'package:fee_easy/data/repositories_impl/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InstituteProfileController extends GetxController {
  final AuthRepositoryImpl _authRepository;

  InstituteProfileController(this._authRepository);

  // Current values (for display)
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

  // Controllers for text fields
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
      final user = await _authRepository.getInstituteProfile();

      instituteName.value = user.instituteName ?? '';
      ownerName.value = user.name;
      email.value = user.email;
      phone.value = user.phone ?? '';
      addressLine1.value = user.address ?? '';
      addressLine2.value = ''; // Map as needed from backend
      city.value = user.city ?? '';
      state.value = user.state ?? '';
      country.value = 'India'; // Default or from user model
      pincode.value = user.pincode ?? '';

      if (user.logo != null) {
        profileImagePath.value = user.logo;
      }

      _initializeControllers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
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
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
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
          ],
        ),
      ),
    );
  }

  void saveProfile() {
    instituteName.value = nameController.text;
    ownerName.value = ownerController.text;
    email.value = emailController.text;
    phone.value = phoneController.text;
    addressLine1.value = addressLine1Controller.text;
    addressLine2.value = addressLine2Controller.text;
    city.value = cityController.text;
    state.value = stateController.text;
    country.value = countryController.text;
    pincode.value = pincodeController.text;

    Get.back();
    Get.snackbar(
      'Profile Updated',
      'Institute details have been successfully saved.',
      backgroundColor: const Color(0xFF027A48),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void discardChanges() {
    _initializeControllers();
    Get.back();
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
