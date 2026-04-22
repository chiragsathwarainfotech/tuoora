import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InstituteStudentController extends GetxController {
  final selectedGrade = AppStrings.instGradeHint.obs;
  final selectedBatchId = ''.obs;
  final isFeeStructureExpanded = false.obs;
  final selectedImagePath = Rxn<String>();

  final nameController = TextEditingController();
  final parentNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();

  final feeBreakdown = {
    'Tuition Fee': '0'.obs,
    'Lab Fee': '0'.obs,
    'Activities': '0'.obs,
  };

  final totalMonthlyFee = '₹0.00'.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotal();

    // Add listeners for validation
    nameController.addListener(validateForm);
    parentNameController.addListener(validateForm);
    phoneController.addListener(validateForm);
    emailController.addListener(validateForm);
    dobController.addListener(validateForm);
    addressController.addListener(validateForm);

    ever(selectedGrade, (_) => validateForm());
    ever(selectedBatchId, (_) => validateForm());

    // Pre-fill if arguments are passed (Edit Mode)
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      final student = Student(
        name: args['name'] ?? '',
        id: 'STU-2024-001',
        grade: args['grade'] ?? '',
        batch: args['batch'] ?? '',
        status: 'Active',
        imageUrl: 'https://i.pravatar.cc/150?u=student_arjun',
      );
      preFillData(student);
    }
  }

  void validateForm() {
    bool isValid =
        nameController.text.isNotEmpty &&
        parentNameController.text.isNotEmpty &&
        phoneController.text.length >= 10 &&
        ValidationUtils.validateEmail(emailController.text) == null &&
        dobController.text.isNotEmpty &&
        selectedBatchId.isNotEmpty &&
        selectedGrade.value != AppStrings.instGradeHint;

    isFormValid.value = isValid;
  }

  void setGrade(String grade) {
    selectedGrade.value = grade;
  }

  void setBatchById(String id, double baseFee) {
    selectedBatchId.value = id;
    feeBreakdown['Tuition Fee']!.value = baseFee.toStringAsFixed(0);
    calculateTotal();
  }

  Future<void> selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  void toggleFeeStructure() {
    isFeeStructureExpanded.value = !isFeeStructureExpanded.value;
  }

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
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.instDarkBtnBlue,
              ),
              title: Text('Camera', style: AppTextStyles.lexend(fontSize: 16)),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: AppColors.instDarkBtnBlue,
              ),
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

  void saveStudent({bool isEdit = false}) {
    if (!isFormValid.value) {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final instController = Get.find<InstituteController>();

    final newStudent = Student(
      name: nameController.text,
      id: isEdit
          ? 'STU-2024-001'
          : 'STU-2024-${DateTime.now().millisecond}', // Mock ID
      grade: selectedGrade.value,
      batch: Get.find<BatchController>().batchesList
          .firstWhere((b) => b.id == selectedBatchId.value)
          .title,
      status: 'Active',
      imageUrl:
          selectedImagePath.value ??
          'https://i.pravatar.cc/150?img=${DateTime.now().second % 70}',
      showOnlineBadge: true,
    );

    if (isEdit) {
      instController.updateStudent(newStudent);
    } else {
      instController.addStudent(newStudent);
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: AppSpacing.all32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF027A48),
                size: 64,
              ),
              AppSpacing.v24,
              Text(
                isEdit ? 'Updated Successfully' : 'Added Successfully',
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              AppSpacing.v12,
              Text(
                isEdit
                    ? 'Student profile has been updated.'
                    : 'New student has been registered to the institute.',
                textAlign: TextAlign.center,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              AppSpacing.v32,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to list
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.instDarkBtnBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: AppSpacing.y16,
                  ),
                  child: Text(
                    'Done',
                    style: AppTextStyles.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void preFillData(Student student) {
    nameController.text = student.name;
    // Mocking other fields since Student model is limited
    parentNameController.text = 'Parent of ${student.name}';
    phoneController.text = '9876543210';
    emailController.text =
        '${student.name.toLowerCase().replaceAll(' ', '.')}@example.com';
    dobController.text = '12/05/2005';
    addressController.text = 'Mock Address, City';
    selectedGrade.value = student.grade;

    // Match batch name to ID (mock logic)
    final batchController = Get.find<BatchController>();
    final batch = batchController.batchesList.firstWhereOrNull(
      (b) => student.batch.contains(b.title),
    );
    if (batch != null) {
      selectedBatchId.value = batch.id;
      feeBreakdown['Tuition Fee']!.value = batch.baseFee.toStringAsFixed(0);
    }

    validateForm();
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
            ...grades.map(
              (grade) => ListTile(
                title: Text(grade, style: AppTextStyles.lexend(fontSize: 16)),
                onTap: () {
                  setGrade(grade);
                  Get.back();
                },
              ),
            ),
            AppSpacing.v24,
          ],
        ),
      ),
    );
  }
}
