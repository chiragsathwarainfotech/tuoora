import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'institute_controller.dart';

class RecordFeeController extends GetxController {
  final InstituteController instituteController =
      Get.find<InstituteController>();
  final InstituteRepositoryImpl _instituteRepository =
      Get.find<InstituteRepositoryImpl>();

  final searchQuery = ''.obs;
  final isStudentSelected = false.obs;
  final selectedStudent = Rxn<Student>();
  final filteredStudents = <Student>[].obs;

  final selectedMonth = ''.obs;
  final amount = ''.obs;
  final paymentMethod = 'Cash'.obs;
  final selectedRecordDate = DateTime.now().obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedMonth.value = DateFormat('MMMM yyyy').format(DateTime.now());
    // Initialize results with all students
    filteredStudents.assignAll(instituteController.students);

    // Setup search listener
    debounce(
      searchQuery,
      (_) => _performSearch(),
      time: const Duration(milliseconds: 300),
    );
  }

  void _performSearch() {
    if (searchQuery.value.isEmpty) {
      filteredStudents.assignAll(instituteController.students);
    } else {
      filteredStudents.assignAll(
        instituteController.students
            .where(
              (s) =>
                  s.name.toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ) ||
                  s.id.toString().toLowerCase().contains(
                    searchQuery.value.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
  }

  void selectStudent(Student student) {
    selectedStudent.value = student;
    isStudentSelected.value = true;
    searchQuery.value = '';
  }

  void changeStudent() {
    isStudentSelected.value = false;
    selectedStudent.value = null;
    _performSearch();
  }

  void setPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  Future<void> selectRecordDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedRecordDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBrand,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedRecordDate.value = picked;
    }
  }

  Future<void> saveRecord() async {
    if (selectedStudent.value == null) {
      Get.snackbar('Error', 'Please select a student');
      return;
    }

    if (amount.value.isEmpty || double.tryParse(amount.value) == null) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    try {
      isLoading.value = true;
      final data = {
        'student_id': selectedStudent.value!.id,
        'total_amount': double.parse(amount.value),
        'date': DateFormat('yyyy-MM-dd').format(selectedRecordDate.value),
        'payment_method': paymentMethod.value,
      };

      await _instituteRepository.createFee(data);

      await instituteController.refreshFees();

      Get.back();
      Get.snackbar(
        'Success',
        'Fee record created and collected successfully',
        backgroundColor: AppColors.darkGreen,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
