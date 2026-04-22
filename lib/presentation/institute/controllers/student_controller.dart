import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class InstituteStudentController extends GetxController {
  final StudentRepositoryImpl _studentRepository =
      Get.find<StudentRepositoryImpl>();

  final studentNameController = TextEditingController();
  final guardianNameController = TextEditingController();
  final phoneController = TextEditingController();

  final selectedGrade = 'Select Grade'.obs;
  final selectedBatchIndex = 0.obs;
  final isFeeStructureExpanded = false.obs;
  final selectedImagePath = Rxn<String>();
  final isLoading = false.obs;

  String? editingStudentId;

  final feeBreakdown = {
    'Tuition Fee': '2000'.obs,
    'Lab Fee': '300'.obs,
    'Activities': '200'.obs,
  };

  final totalMonthlyFee = '₹0.00'.obs;

  @override
  void onInit() {
    super.onInit();
    _handleArgs();
    calculateTotal();
  }

  void _handleArgs() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['studentId'] != null) {
        editingStudentId = args['studentId'];
        fetchStudentDetails(editingStudentId!);

        if (args['student'] != null) {
          final studentData = args['student'];
          studentNameController.text = studentData['name'] ?? '';
          guardianNameController.text = studentData['guardianName'] ?? '';
          phoneController.text = studentData['phone'] ?? '';
          selectedGrade.value = studentData['grade'] ?? 'Select Grade';
        }
      }
    }
  }

  Future<void> fetchStudentDetails(String id) async {
    try {
      isLoading.value = true;
      final student = await _studentRepository.getStudentById(id);
      studentNameController.text = student.name;
      guardianNameController.text = student.guardianName ?? '';
      phoneController.text = student.phone ?? '';
      selectedGrade.value = student.grade;
    } catch (e) {
      debugPrint('Error fetching student: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    studentNameController.dispose();
    guardianNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void setGrade(String grade) {
    selectedGrade.value = grade;
  }

  void setBatch(int index) {
    selectedBatchIndex.value = index;
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

  Future<void> saveStudent() async {
    if (studentNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter student name');
      return;
    }

    try {
      isLoading.value = true;

      final studentData = {
        'name': studentNameController.text,
        'guardian_name': guardianNameController.text,
        'phone': phoneController.text,
        'grade': selectedGrade.value,
        'batch': selectedBatchIndex.value == 0 ? 'Morning' : 'Evening',
        'fee_breakdown': feeBreakdown.map(
          (key, value) => MapEntry(key, value.value),
        ),
      };

      if (editingStudentId != null) {
        await _studentRepository.updateStudent(editingStudentId!, studentData);
      } else {
        await _studentRepository.createStudent(studentData);
      }

      Get.snackbar(
        'Success',
        editingStudentId != null
            ? 'Student information updated successfully'
            : 'Student created successfully',
        backgroundColor: const Color(0xFF027A48),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Refresh list in main controller if it exists
      if (Get.isRegistered<InstituteController>()) {
        Get.find<InstituteController>().fetchStudents();
      }

      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save student: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStudent() async {
    if (editingStudentId == null) return;

    try {
      isLoading.value = true;
      final success = await _studentRepository.deleteStudent(editingStudentId!);

      if (success) {
        Get.snackbar(
          'Deleted',
          'Student records removed successfully',
          backgroundColor: Colors.black87,
          colorText: Colors.white,
        );

        if (Get.isRegistered<InstituteController>()) {
          Get.find<InstituteController>().fetchStudents();
        }

        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete student: $e');
    } finally {
      isLoading.value = false;
    }
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
