import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import '../models/fee_record.dart';

class Student {
  final String name;
  final String id;
  final String grade;
  final String batch;
  final String status;
  final String imageUrl;
  final bool showOnlineBadge;
  final bool isPending;

  Student({
    required this.name,
    required this.id,
    required this.grade,
    required this.batch,
    required this.status,
    required this.imageUrl,
    this.showOnlineBadge = false,
    this.isPending = false,
  });
}

class InstituteController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  late PageController pageController;

  // Student Registry Logic
  final selectedFilter = AppStrings.instFilterAll.obs;
  final students = <Student>[].obs;
  final filteredStudents = <Student>[].obs;

  // Fee Registry Logic
  final feeRecords = <FeeRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setInitialIndex();
    pageController = PageController(initialPage: _currentIndex.value);
    _loadMockStudents();
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

  void _loadMockStudents() {
    students.assignAll([
      Student(
        name: 'Arjun Malhotra',
        id: 'STU-2024-001',
        grade: '10th Std',
        batch: 'Evening • Batch A',
        status: 'Active',
        imageUrl: 'https://i.pravatar.cc/150?img=11',
        showOnlineBadge: true,
      ),
      Student(
        name: 'Sarah Jenkins',
        id: 'STU-2024-042',
        grade: '12th Std',
        batch: 'Morning • Advanced',
        status: 'Pending',
        imageUrl: 'https://i.pravatar.cc/150?img=32',
        isPending: true,
      ),
      Student(
        name: 'Rahul Sharma',
        id: 'STU-2024-105',
        grade: '10th Std',
        batch: 'Evening • Batch B',
        status: 'Active',
        imageUrl: 'https://i.pravatar.cc/150?img=12',
      ),
      Student(
        name: 'Priya Gupta',
        id: 'STU-2024-089',
        grade: '9th Std',
        batch: 'Evening • Batch A',
        status: 'Active',
        imageUrl: 'https://i.pravatar.cc/150?img=44',
        showOnlineBadge: true,
      ),
    ]);
    _applyFilter();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedFilter.value == AppStrings.instFilterAll) {
      filteredStudents.assignAll(students);
    } else if (selectedFilter.value == AppStrings.instFilter10th) {
      filteredStudents.assignAll(students.where((s) => s.grade.contains('10th')));
    } else if (selectedFilter.value == AppStrings.instFilter9th) {
      filteredStudents.assignAll(students.where((s) => s.grade.contains('9th')));
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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
