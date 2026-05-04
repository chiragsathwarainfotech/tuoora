import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/data/models/student_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';
import 'package:fee_easy/core/services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  late PageController pageController;

  final StudentRepositoryImpl _studentRepository =
      Get.find<StudentRepositoryImpl>();
  final InstituteRepositoryImpl _instituteRepository =
      Get.find<InstituteRepositoryImpl>();
  final selectedFilter = AppStrings.instFilterAll.obs;
  final students = <Student>[].obs;
  final isLoadingStudents = false.obs;

  // Pagination & Search
  final searchQuery = ''.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final isLoadMore = false.obs;

  // Fees State
  final feeRecords = <FeeRecord>[].obs;
  final isLoadingFees = false.obs;
  final currentMonthTotal = 0.0.obs;
  final feesCurrentPage = 1.obs;
  final feesHasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    _setInitialIndex();
    pageController = PageController(initialPage: _currentIndex.value);
    debounce(
      searchQuery,
      (_) => fetchStudents(reset: true),
      time: const Duration(milliseconds: 500),
    );
    fetchStudents();
    fetchFees();
  }

  Future<void> fetchFees({bool reset = false}) async {
    if (reset) {
      feesCurrentPage.value = 1;
      feesHasMore.value = true;
    }

    if (isLoadingFees.value || (!feesHasMore.value && !reset)) return;

    try {
      isLoadingFees.value = true;
      final result = await _instituteRepository.listFees(
        page: feesCurrentPage.value,
      );

      if (reset) {
        feeRecords.assignAll(result.items);
      } else {
        feeRecords.addAll(result.items);
      }

      currentMonthTotal.value = result.currentMonthTotal;

      if (result.items.isEmpty || result.items.length < 10) {
        feesHasMore.value = false;
      } else {
        feesCurrentPage.value++;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch fees: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoadingFees.value = false;
    }
  }

  Future<void> refreshFees() => fetchFees(reset: true);

  Future<void> downloadFeeReport() async {
    try {
      Get.snackbar(
        'Downloading',
        'Preparing your financial report...',
        backgroundColor: AppColors.primaryBrand,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
      );

      final bytes = await _instituteRepository.exportFees();

      final downloadService = Get.find<DownloadService>();
      final fileName =
          'Fee_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await downloadService.saveFile(
        bytes: bytes,
        fileName: fileName,
        successMessage: 'Record download successfully',
      );
    } catch (e) {
      Get.snackbar(
        'Download Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchStudents({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      hasMore.value = true;
    }

    if (isLoadingStudents.value || (!hasMore.value && !reset)) return;

    try {
      if (reset || students.isEmpty) {
        isLoadingStudents.value = true;
      } else {
        isLoadMore.value = true;
      }

      final result = await _studentRepository.listStudents(
        search: searchQuery.value,
        page: currentPage.value,
      );

      if (reset) {
        students.assignAll(result);
      } else {
        students.addAll(result);
      }

      if (result.isEmpty || result.length < 10) {
        hasMore.value = false;
      } else {
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch students: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
    } finally {
      isLoadingStudents.value = false;
      isLoadMore.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void loadMoreStudents() {
    if (hasMore.value && !isLoadingStudents.value && !isLoadMore.value) {
      fetchStudents();
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
