import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InstituteStudentController extends GetxController {
  // Form State
  final selectedGrade = AppStrings.instGradeHint.obs;
  final selectedBatchIndex = 0.obs;
  final isFeeStructureExpanded = false.obs;
  final selectedImagePath = Rxn<String>();
  
  // Fee Management
  final feeBreakdown = {
    'Tuition Fee': '2000'.obs,
    'Lab Fee': '300'.obs,
    'Activities': '200'.obs,
  };
  
  final totalMonthlyFee = '₹2,500.00'.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotal();
  }

  // Grade Selection Logic
  void setGrade(String grade) {
    selectedGrade.value = grade;
  }

  // Batch Selection Logic
  void setBatch(int index) {
    selectedBatchIndex.value = index;
  }

  // Fee Structure expansion logic
  void toggleFeeStructure() {
    isFeeStructureExpanded.value = !isFeeStructureExpanded.value;
  }

  // Fee Editing logic
  void updateFee(String key, String value) {
    if (feeBreakdown.containsKey(key)) {
      feeBreakdown[key]!.value = value;
      calculateTotal();
    }
  }

  void calculateTotal() {
    double total = 0;
    feeBreakdown.forEach((key, value) {
      double? amount = double.tryParse(value.value.replaceAll(',', ''));
      if (amount != null) {
        total += amount;
      }
    });
    totalMonthlyFee.value = '₹${total.toStringAsFixed(2)}';
  }

  // Image Picking Logic
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not pick image: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    }
  }

  void showImagePickerSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Image Source',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v20,
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: AppColors.instDarkBtnBlue),
              title: Text('Camera', style: AppTextStyles.lexend(fontSize: 16)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded, color: AppColors.instDarkBtnBlue),
              title: Text('Gallery', style: AppTextStyles.lexend(fontSize: 16)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            AppSpacing.v16,
          ],
        ),
      ),
    );
  }

  // Form Submission Logic
  void saveStudent() {
    Get.snackbar(
      'Success',
      'Student information updated successfully',
      backgroundColor: const Color(0xFF027A48),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: AppSpacing.all16,
      duration: const Duration(seconds: 2),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  void applyFeeChanges() {
    calculateTotal();
    isFeeStructureExpanded.value = false;
    Get.snackbar(
      'Updated',
      'Monthly fee structure has been updated',
      backgroundColor: AppColors.instDarkBtnBlue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void discardChanges() {
    Get.back();
  }

  // UI Helpers
  void showGradeSelection(BuildContext context, List<String> grades) {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Grade',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v16,
            ...grades.map((grade) => ListTile(
                  title: Text(
                    grade,
                    style: AppTextStyles.lexend(fontSize: 16),
                  ),
                  onTap: () {
                    setGrade(grade);
                    Get.back();
                  },
                )),
            AppSpacing.v24,
          ],
        ),
      ),
    );
  }
}
