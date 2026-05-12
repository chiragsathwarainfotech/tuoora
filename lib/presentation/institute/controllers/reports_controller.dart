import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_performance_model.dart';
import 'package:fee_easy/presentation/institute/models/report_models.dart';
import 'package:fee_easy/core/services/download_service.dart';
import 'package:fee_easy/presentation/institute/models/student_performance_model.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  final BatchController batchController = Get.find<BatchController>();
  final InstituteController instituteController =
      Get.find<InstituteController>();
  final InstituteRepositoryImpl _repository =
      Get.find<InstituteRepositoryImpl>();
  final DownloadService _downloadService = Get.find<DownloadService>();

  final batchPerformances = <BatchPerformance>[].obs;

  // Fee Data
  final feeReport = Rxn<FeeReportResponse>();
  final isFeeLoading = false.obs;

  final attendanceReport = Rxn<AttendanceReportResponse>();
  final isAttendanceLoading = false.obs;

  final performanceReport = Rxn<PerformanceReportResponse>();
  final isPerformanceLoading = false.obs;

  final batchFeeDetail = Rxn<BatchFeeDetailResponse>();
  final batchAttendanceDetail = Rxn<BatchAttendanceDetailResponse>();
  final batchPerformanceDetail = Rxn<BatchPerformanceDetailResponse>();

  final isBatchDetailLoading = false.obs;
  final overallAttendance = '92%'.obs;
  final attendanceTrend = '2% decrease from last week'.obs;

  final selectedBatchId = Rxn<int>();
  final selectedReportType = 'Fee'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllReports();
  }

  void loadAllReports() {
    loadPerformanceData();
    loadFeeReport();
    loadAttendanceReport();
    loadPerformanceReport();
  }

  Future<void> loadFeeReport() async {
    try {
      isFeeLoading.value = true;
      feeReport.value = await _repository.getFeeReport();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load fee report: $e',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isFeeLoading.value = false;
    }
  }

  Future<void> loadAttendanceReport() async {
    try {
      isAttendanceLoading.value = true;
      attendanceReport.value = await _repository.getAttendanceReport();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load attendance report: $e',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  Future<void> loadPerformanceReport() async {
    try {
      isPerformanceLoading.value = true;
      performanceReport.value = await _repository.getPerformanceReport();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load performance report: $e',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isPerformanceLoading.value = false;
    }
  }

  Future<void> loadBatchDetail(int batchId, String type) async {
    try {
      selectedBatchId.value = batchId;
      selectedReportType.value = type;
      isBatchDetailLoading.value = true;

      if (type == 'Fee') {
        batchFeeDetail.value = await _repository.getBatchFeeReport(batchId);
      } else if (type == 'Attendance') {
        batchAttendanceDetail.value = await _repository
            .getBatchAttendanceReport(batchId);
      } else if (type == 'Performance') {
        batchPerformanceDetail.value = await _repository
            .getBatchPerformanceReport(batchId);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load batch $type details: $e',
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    } finally {
      isBatchDetailLoading.value = false;
    }
  }

  Future<void> exportReport(String type) async {
    try {
      Get.snackbar(
        'Downloading',
        'Preparing $type report...',
        backgroundColor: AppColors.primaryBrand,
        colorText: AppColors.white,
        showProgressIndicator: true,
      );

      List<int> bytes;
      if (type == 'Fee') {
        bytes = await _repository.exportFeeReport();
      } else if (type == 'Attendance') {
        bytes = await _repository.exportAttendanceReport();
      } else {
        bytes = await _repository.exportPerformanceReport();
      }

      final fileName =
          '${type}_Report_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await _downloadService.saveFile(
        bytes: bytes,
        fileName: fileName,
        successMessage: '$type report downloaded successfully',
      );
    } catch (e) {
      Get.snackbar(
        'Download Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.redAccent,
        colorText: AppColors.white,
      );
    }
  }

  void loadPerformanceData() {
    isPerformanceLoading.value = true;

    final List<BatchPerformance> data = batchController.batchesList.map((
      batch,
    ) {
      final studentCountStr = batch.studentCount.split(' ')[0];
      final studentCount = int.tryParse(studentCountStr) ?? 0;

      final List<StudentPerformance> students = instituteController.students
          .take(studentCount)
          .map((s) {
            final index = instituteController.students.indexOf(s);
            final rating = 7.0 + (index % 4) * 0.75;
            return StudentPerformance(
              studentId: s.id.toString(),
              studentName: s.name,
              averageRating: rating,
            );
          })
          .toList();

      double totalRating = 0;
      for (var s in students) {
        totalRating += s.averageRating;
      }
      final batchAvg = students.isEmpty ? 0.0 : totalRating / students.length;

      return BatchPerformance(
        batchId: batch.id,
        batchName: batch.title,
        averageRating: batchAvg,
        totalStudents: studentCount,
        studentPerformances: students,
      );
    }).toList();

    batchPerformances.assignAll(data);
    isPerformanceLoading.value = false;
  }

  double get overallAveragePerformance {
    if (batchPerformances.isEmpty) return 0.0;
    double total = 0;
    for (var b in batchPerformances) {
      total += b.averageRating;
    }
    return total / batchPerformances.length;
  }

  BatchPerformance? getBatchPerformance(String batchId) {
    return batchPerformances.firstWhereOrNull((b) => b.batchId == batchId);
  }
}

