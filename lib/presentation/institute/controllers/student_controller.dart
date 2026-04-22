import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fee_easy/data/models/student_model.dart';

class InstituteStudentController extends GetxController {
  final StudentRepositoryImpl _studentRepository = Get.find<StudentRepositoryImpl>();

  // Rx Fields
  final selectedGrade = AppStrings.instGradeHint.obs;
  final selectedBatchId = ''.obs;
  final isFeeStructureExpanded = false.obs;
  final selectedImagePath = Rxn<String>();
  final isLoading = false.obs;
  final isFormValid = false.obs;
  final totalMonthlyFee = '₹0.00'.obs;

  // Controllers
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

  String? editingStudentId;

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

    // Handle Arguments (Add/Edit/Profile Mode)
    _handleArguments();
  }

  void _handleArguments() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;

      // Set editing student ID from various possible argument keys
      editingStudentId = args['studentId'] ??
          (args['student'] is Map
              ? args['student']['id']
              : (args['student'] is Student ? args['student'].id : null));

      if (editingStudentId != null) {
        if (args['student'] is Map) {
          // If full map was passed (from mock profile), use it directly
          _preFillFromMap(args['student'] as Map);
        } else {
          fetchStudentDetails(editingStudentId!);
        }
      }
    } else {
      // Clear form if no arguments (Add mode)
      clearForm();
    }
  }

  void clearForm() {
    editingStudentId = null;
    nameController.clear();
    parentNameController.clear();
    phoneController.clear();
    emailController.clear();
    dobController.clear();
    addressController.clear();
    selectedGrade.value = AppStrings.instGradeHint;
    selectedBatchId.value = '';
    selectedImagePath.value = null;
    feeBreakdown.forEach((key, value) => value.value = '0');
    calculateTotal();
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
    super.onClose();
  }

  void validateForm() {
    bool isValid = nameController.text.isNotEmpty &&
        parentNameController.text.isNotEmpty &&
        phoneController.text.length >= 10 &&
        ValidationUtils.validateEmail(emailController.text) == null &&
        dobController.text.isNotEmpty &&
        selectedBatchId.value.isNotEmpty &&
        selectedGrade.value != AppStrings.instGradeHint;

    isFormValid.value = isValid;
  }

  Future<void> fetchStudentDetails(String id) async {
    try {
      isLoading.value = true;
      final student = await _studentRepository.getStudentById(id);
      preFillData(student);
    } catch (e) {
      debugPrint('Error fetching student: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void preFillData(Student student) {
    editingStudentId = student.id;
    nameController.text = student.name;
    parentNameController.text = student.guardianName ?? '';
    phoneController.text = student.phone ?? '';
    selectedGrade.value = student.grade;

    final batchController = Get.find<BatchController>();
    final batch = batchController.batchesList.firstWhereOrNull(
      (b) => student.batch.contains(b.title),
    );
    if (batch != null) {
      selectedBatchId.value = batch.id;
      feeBreakdown['Tuition Fee']!.value = batch.baseFee.toStringAsFixed(0);
    }

    calculateTotal();
    validateForm();
  }

  void _preFillFromMap(Map student) {
    editingStudentId = student['id'];
    nameController.text = student['name'] ?? '';
    parentNameController.text = student['guardianName'] ?? '';
    phoneController.text = student['phone'] ?? '';
    selectedGrade.value = student['grade'] ?? AppStrings.instGradeHint;

    // Use default fees if not in student map
    final batchController = Get.find<BatchController>();
    final batch = batchController.batchesList.firstWhereOrNull(
      (b) => (student['batch'] ?? '').contains(b.title),
    );
    if (batch != null) {
      selectedBatchId.value = batch.id;
      feeBreakdown['Tuition Fee']!.value = batch.baseFee.toStringAsFixed(0);
    }

    calculateTotal();
    validateForm();
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
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 10)); // Default to 10 years ago
    
    // Try to parse existing DOB if available
    if (dobController.text.isNotEmpty) {
      try {
        final parts = dobController.text.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
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
      dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      validateForm();
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
              onTap: () { Get.back(); pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () { Get.back(); pickImage(ImageSource.gallery); },
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
        'guardian_name': parentNameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'grade': selectedGrade.value,
        'batch_id': selectedBatchId.value,
        'fee_breakdown': feeBreakdown.map((key, value) => MapEntry(key, value.value)),
      };

      if (isEdit && editingStudentId != null) {
        await _studentRepository.updateStudent(editingStudentId!, studentData);
      } else {
        await _studentRepository.createStudent(studentData);
      }

      // Success UI logic
      _showSuccessDialog(isEdit);

      // Refresh list
      if (Get.isRegistered<InstituteController>()) {
        Get.find<InstituteController>().fetchStudents();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save student: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog(bool isEdit) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: AppSpacing.all32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              AppSpacing.v24,
              Text(isEdit ? 'Updated' : 'Added', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              AppSpacing.v32,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { Get.back(); Get.back(); },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> deleteStudent() async {
    if (editingStudentId == null) return;
    try {
      isLoading.value = true;
      final success = await _studentRepository.deleteStudent(editingStudentId!);
      if (success) {
        Get.find<InstituteController>().fetchStudents();
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFeeChanges() {
    calculateTotal();
    isFeeStructureExpanded.value = false;
  }

  void discardChanges() {
    Get.back();
  }

  void showGradeSelection(BuildContext context, List<String> grades) {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...grades.map((grade) => ListTile(
              title: Text(grade),
              onTap: () { selectedGrade.value = grade; Get.back(); },
            )),
          ],
        ),
      ),
    );
  }
}
