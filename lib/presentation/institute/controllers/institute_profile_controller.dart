import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InstituteProfileController extends GetxController {
  // Current values (for display)
  final instituteName = "St. Augustine's Institute".obs;
  final ownerName = 'Dr. Elizabeth Sterling'.obs;
  final email = 'admin@st-augustine.edu'.obs;
  final phone = '+44 20 7946 0123'.obs;
  final address = 'Academic District, Cambridge, UK'.obs;
  final profileImagePath = RxnString();

  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController ownerController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: instituteName.value);
    ownerController = TextEditingController(text: ownerName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phone.value);
    addressController = TextEditingController(text: address.value);
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
    address.value = addressController.text;

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
    addressController.dispose();
    super.onClose();
  }
}
