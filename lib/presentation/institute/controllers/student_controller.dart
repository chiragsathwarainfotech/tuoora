import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fee_easy/data/models/student_model.dart';

class InstituteStudentController extends GetxController {
  final StudentRepositoryImpl _studentRepository =
      Get.find<StudentRepositoryImpl>();

  final selectedGrade = AppStrings.instGradeHint.obs;
  final selectedImagePath = Rxn<String>();
  final isLoading = false.obs;
  final isFormValid = false.obs;
  final currentStudent = Rxn<Student>();

  final nameController = TextEditingController();
  final parentNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final standardController = TextEditingController();

  final editingStudentId = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(validateForm);
    parentNameController.addListener(validateForm);
    phoneController.addListener(validateForm);
    emailController.addListener(validateForm);
    dobController.addListener(validateForm);
    addressController.addListener(validateForm);
    standardController.addListener(validateForm);
    handleArguments();
  }

  void handleArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;

      if (args['student'] != null) {
        if (args['student'] is Student) {
          final student = args['student'] as Student;
          editingStudentId.value = student.id;
          currentStudent.value = student;
          preFillData(student);
          return;
        } else if (args['student'] is Map) {
          final student = Student.fromJson(args['student']);
          editingStudentId.value = student.id;
          currentStudent.value = student;
          preFillData(student);
          return;
        }
      }

      editingStudentId.value = args['studentId'];

      if (editingStudentId.value != null) {
        currentStudent.value = null;
        fetchStudentDetails(editingStudentId.value!);
      }
    } else {
      clearForm();
    }
  }

  void clearForm() {
    editingStudentId.value = null;
    currentStudent.value = null;
    nameController.clear();
    parentNameController.clear();
    phoneController.clear();
    emailController.clear();
    dobController.clear();
    addressController.clear();
    standardController.clear();
    selectedImagePath.value = null;
    validateForm();
  }

  @override
  void onClose() {
    nameController.dispose();
    parentNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    addressController.dispose();
    standardController.dispose();
    super.onClose();
  }

  void validateForm() {
    bool isValid =
        nameController.text.isNotEmpty &&
        parentNameController.text.isNotEmpty &&
        phoneController.text.length >= 10 &&
        ValidationUtils.validateEmail(emailController.text) == null &&
        dobController.text.isNotEmpty &&
        standardController.text.isNotEmpty;

    isFormValid.value = isValid;
  }

  Future<void> fetchStudentDetails(dynamic id) async {
    try {
      isLoading.value = true;
      final student = await _studentRepository.getStudentById(id);
      currentStudent.value = student;
      preFillData(student);
    } catch (e) {
      debugPrint('Error fetching student: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void preFillData(Student student) {
    editingStudentId.value = student.id;
    nameController.text = student.name;
    emailController.text = student.email;
    dobController.text = student.dob;
    parentNameController.text = student.guardianName ?? '';
    phoneController.text = student.phone;
    standardController.text = student.standard;

    validateForm();
  }

  void setGrade(String grade) {
    selectedGrade.value = grade;
  }

  Future<void> selectDOB(BuildContext context) async {
    DateTime initialDate = DateTime.now().subtract(
      const Duration(days: 365 * 10),
    ); // Default to 10 years ago

    // Try to parse existing DOB if available
    if (dobController.text.isNotEmpty) {
      try {
        final parts = dobController.text.split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          final existingDate = DateTime(year, month, day);
          if (existingDate.isBefore(DateTime.now())) {
            initialDate = existingDate;
          }
        }
      } catch (e) {
        debugPrint('Error parsing DOB: $e');
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      validateForm();
    }
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
      Get.snackbar('Error', 'Could not pick image: $e');
    }
  }

  void showImagePickerSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveStudent({bool isEdit = false}) async {
    if (!isFormValid.value) return;

    try {
      isLoading.value = true;

      final studentData = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'guardian_name': parentNameController.text,
        'dob': dobController.text,
        'standard': standardController.text,
      };

      if (isEdit && editingStudentId.value != null) {
        await _studentRepository.updateStudent(
          editingStudentId.value!,
          studentData,
        );
      } else {
        await _studentRepository.createStudent(studentData);
      }

      // Refresh list
      if (Get.isRegistered<InstituteController>()) {
        Get.find<InstituteController>().fetchStudents(reset: true);
      }

      // Navigate back to registry first
      if (isEdit) {
        Get.back(); // Back from Edit
        Get.back(); // Back from Profile to Registry
      } else {
        Get.back(); // Back from Add to Registry
      }

      // Success UI logic - Show AFTER navigation to avoid "disposed snackbar" error
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Success',
          isEdit
              ? 'Student updated successfully'
              : 'Student added successfully',
          backgroundColor: Colors.green.withValues(alpha: 0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: AppSpacing.all16,
        );
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to save student: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStudent() async {
    if (editingStudentId.value == null) return;
    try {
      isLoading.value = true;
      final success = await _studentRepository.deleteStudent(
        editingStudentId.value!,
      );
      if (success) {
        // Locally remove to show immediate update
        final instController = Get.find<InstituteController>();
        instController.students.removeWhere(
          (s) => s.id == editingStudentId.value,
        );
        instController.students.refresh();

        Get.back(); // Return to registry screen

        // Refresh from server to ensure sync
        instController.fetchStudents(reset: true);
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void discardChanges() {
    Get.back();
  }

  void showGradeSelection(BuildContext context, List<String> grades) {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...grades.map(
              (grade) => ListTile(
                title: Text(grade),
                onTap: () {
                  selectedGrade.value = grade;
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
