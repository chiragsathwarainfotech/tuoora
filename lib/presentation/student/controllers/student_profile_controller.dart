import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/student_profile_model.dart';
import 'package:tuoora/data/repositories/student_profile_repository.dart';

class StudentProfileController extends GetxController {
  /// Local path of the most-recently-picked image. Shown immediately
  /// after picking so the avatar updates without waiting on the upload.
  /// Cleared on upload failure so the UI reverts to the prior avatar.
  final RxString profileImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = true.obs;
  final RxBool isUploadingAvatar = false.obs;
  final Rxn<StudentProfileModel> profileData = Rxn<StudentProfileModel>();
  late final StudentProfileRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentProfileRepository(Get.find<ApiClient>());
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _repository.getProfile();
      profileData.value = data;
    } catch (e) {
      AppSnackBar.error('Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    final previousLocalPath = profileImagePath.value;
    profileImagePath.value = image.path;

    try {
      isUploadingAvatar.value = true;
      final newAvatarUrl = await _repository.uploadAvatar(File(image.path));

      final existing = profileData.value;
      if (existing != null) {
        profileData.value = existing.copyWithAvatarUrl(newAvatarUrl);
      }
      AppSnackBar.success('Profile photo updated');
    } catch (e) {
      profileImagePath.value = previousLocalPath;
      AppSnackBar.error(
        e.toString().replaceAll('Exception: ', ''),
        title: 'Upload failed',
      );
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      // SafeArea(top:false) pushes the sheet content above the system
      // gesture / navigation area so the Camera / Gallery tiles stay
      // fully tappable on phones with a bottom nav bar.
      SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s24,
            AppSpacing.s24,
            AppSpacing.s24,
            AppSpacing.s16,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle for affordance
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
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
                  await pickImage(ImageSource.camera);
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
                  await pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
