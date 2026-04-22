import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/core/constants/app_colors.dart';

class InstituteController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  late PageController pageController;

  // Student Registry Logic
  final StudentRepositoryImpl _studentRepository =
      Get.find<StudentRepositoryImpl>();
  final selectedFilter = AppStrings.instFilterAll.obs;
  final students = <Student>[].obs;
  final filteredStudents = <Student>[].obs;
  final isLoadingStudents = false.obs;

  final feeRecords = <FeeRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setInitialIndex();
    pageController = PageController(initialPage: _currentIndex.value);
    fetchStudents();
    _loadMockFeeRecords();
  }

  void _loadMockFeeRecords() {
    feeRecords.assignAll([
      FeeRecord(
        studentName: 'Arjun Malhotra',
        studentId: 'STU-2024-001',
        batch: 'Evening • Batch A',
        amount: '₹2,500',
        status: 'Paid',
        month: 'October 2023',
        paymentMethod: 'Online',
        timestamp: DateTime.now(),
        statusBg: AppColors.instFeesPaidBadgeBg,
        statusText: AppColors.instFeesPaidText,
      ),
      FeeRecord(
        studentName: 'Sarah Jenkins',
        studentId: 'STU-2024-042',
        batch: 'Morning • Advanced',
        amount: '₹2,500',
        status: 'Due',
        month: 'October 2023',
        paymentMethod: 'Cash',
        timestamp: DateTime.now(),
        statusBg: AppColors.instFeesDueBadgeBg,
        statusText: AppColors.instFeesDueText,
      ),
      FeeRecord(
        studentName: 'Rahul Sharma',
        studentId: 'STU-2024-105',
        batch: 'Evening • Batch B',
        amount: '₹2,500',
        status: 'Paid',
        month: 'October 2023',
        paymentMethod: 'Online',
        timestamp: DateTime.now(),
        statusBg: AppColors.instFeesPaidBadgeBg,
        statusText: AppColors.instFeesPaidText,
      ),
      FeeRecord(
        studentName: 'Priya Gupta',
        studentId: 'STU-2024-089',
        batch: 'Evening • Batch A',
        amount: '₹2,500',
        status: 'Due',
        month: 'October 2023',
        paymentMethod: 'Cash',
        timestamp: DateTime.now(),
        statusBg: AppColors.instFeesDueBadgeBg,
        statusText: AppColors.instFeesDueText,
      ),
    ]);
  }

  Future<void> fetchStudents() async {
    try {
      isLoadingStudents.value = true;
      final result = await _studentRepository.listStudents();
      students.assignAll(result);
      _applyFilter();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch students: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoadingStudents.value = false;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedFilter.value == AppStrings.instFilterAll) {
      filteredStudents.assignAll(students);
    } else if (selectedFilter.value == AppStrings.instFilter10th) {
      filteredStudents.assignAll(
        students.where((s) => s.grade.contains('10th')),
      );
    } else if (selectedFilter.value == AppStrings.instFilter9th) {
      filteredStudents.assignAll(
        students.where((s) => s.grade.contains('9th')),
      );
    } else if (selectedFilter.value == AppStrings.instFilterBatches) {
      // Logic for batches filter if needed
      filteredStudents.assignAll(students);
    }
  }

  void _setInitialIndex() {
    final route = Get.currentRoute;
    if (route == AppRoutes.instituteStudents) {
      _currentIndex.value = 1;
    } else if (route == AppRoutes.instituteBatches) {
      _currentIndex.value = 2;
    } else if (route == AppRoutes.instituteFees) {
      _currentIndex.value = 3;
    } else if (route == AppRoutes.instituteProfile) {
      _currentIndex.value = 4;
    } else {
      _currentIndex.value = 0;
    }
  }

  void changePage(int index) {
    if (_currentIndex.value == index) return;

    _currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setIndex(int index) {
    _currentIndex.value = index;
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
  }

  void addStudent(Student student) {
    students.insert(0, student);
    students.refresh();
  }

  void updateStudent(Student student) {
    final index = students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      students[index] = student;
      students.refresh();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
