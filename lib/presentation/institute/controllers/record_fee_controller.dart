import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'institute_controller.dart';

class RecordFeeController extends GetxController {
  final InstituteController instituteController =
      Get.find<InstituteController>();

  // Student Selection state
  final searchQuery = ''.obs;
  final isStudentSelected = false.obs;
  final selectedStudent = Rxn<Student>();
  final filteredStudents = <Student>[].obs;

  // Form state
  final selectedStatus = AppStrings.instStatusPaid.obs;
  final selectedMonth = ''.obs;
  final amount = '1500'.obs;
  final paymentMethod = AppStrings.instPaymentCash.obs;

  @override
  void onInit() {
    super.onInit();
    // Set default month
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
                  s.id.toLowerCase().contains(searchQuery.value.toLowerCase()),
            )
            .toList(),
      );
    }
  }

  void selectStudent(Student student) {
    selectedStudent.value = student;
    isStudentSelected.value = true;
    searchQuery.value = '';
    // Optionally pre-populate amount if students had a fee field
  }

  void changeStudent() {
    isStudentSelected.value = false;
    selectedStudent.value = null;
    _performSearch();
  }

  void setStatus(String status) {
    selectedStatus.value = status;
  }

  void setPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void setMonth(String month) {
    selectedMonth.value = month;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.instPrimaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedMonth.value = DateFormat('MMMM yyyy').format(picked);
    }
  }

  void saveRecord() {
    if (selectedStudent.value == null) {
      Get.snackbar('Error', 'Please select a student');
      return;
    }

    Color bg;
    Color text;
    if (selectedStatus.value == AppStrings.instStatusPaid) {
      bg = AppColors.instFeesPaidBadgeBg;
      text = AppColors.instFeesPaidText;
    } else {
      bg = AppColors.instFeesDueBadgeBg;
      text = AppColors.instFeesDueText;
    }

    final newRecord = FeeRecord(
      studentName: selectedStudent.value?.name ?? "",
      studentId: selectedStudent.value?.id ?? "",
      batch: selectedStudent.value?.batch ?? "",
      amount: '₹${amount.value}',
      month: selectedMonth.value,
      paymentMethod: paymentMethod.value,
      timestamp: DateTime.now(),
    );

    instituteController.feeRecords.insert(0, newRecord);
    Get.back();
    Get.snackbar('Success', 'Fee record saved successfully');
  }
}
