import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_performance_model.dart';
import 'package:fee_easy/presentation/institute/models/student_performance_model.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  final BatchController batchController = Get.find<BatchController>();
  final InstituteController instituteController =
      Get.find<InstituteController>();

  // Performance Data
  final batchPerformances = <BatchPerformance>[].obs;
  final isPerformanceLoading = false.obs;

  // Fee Data
  final totalFeeCollection = '₹42,850.00'.obs;
  final feeTrend = '12.5% increase from last month'.obs;
  final feeBatches = <Map<String, dynamic>>[
    {
      'name': 'Advanced Physics (A1)',
      'strength': 42,
      'collected': '₹8,400',
      'progress': 0.85,
    },
    {
      'name': 'Data Structures (DS2)',
      'strength': 30,
      'collected': '₹12,000',
      'progress': 0.6,
    },
    {
      'name': 'Web Architecture (W4)',
      'strength': 18,
      'collected': '₹9,500',
      'progress': 0.95,
    },
    {
      'name': 'Graphic Design (GD1)',
      'strength': 25,
      'collected': '₹6,250',
      'progress': 0.5,
    },
  ].obs;

  // Attendance Data
  final overallAttendance = '92%'.obs;
  final attendanceTrend = '2% decrease from last week'.obs;
  final attendanceBatches = <Map<String, dynamic>>[
    {
      'name': 'Advanced Physics (A1)',
      'strength': 42,
      'rate': '95%',
      'progress': 0.95,
      'absentees': 2,
    },
    {
      'name': 'Data Structures (DS2)',
      'strength': 30,
      'rate': '82%',
      'progress': 0.82,
      'absentees': 5,
    },
    {
      'name': 'Web Architecture (W4)',
      'strength': 18,
      'rate': '98%',
      'progress': 0.98,
      'absentees': 0,
    },
    {
      'name': 'Graphic Design (GD1)',
      'strength': 25,
      'rate': '70%',
      'progress': 0.70,
      'absentees': 7,
    },
  ].obs;

  // Defaulters Data
  final defaulters = <Map<String, dynamic>>[
    {
      'name': 'Julian Casablancas',
      'id': 'FE-1024',
      'amount': '₹4,500',
      'daysOverdue': 12,
    },
    {
      'name': 'Albert Hammond',
      'id': 'FE-0982',
      'amount': '₹2,300',
      'daysOverdue': 5,
    },
    {
      'name': 'Fabrizio Moretti',
      'id': 'FE-0871',
      'amount': '₹1,500',
      'daysOverdue': 3,
    },
    {
      'name': 'Nick Valensi',
      'id': 'FE-1102',
      'amount': '₹5,000',
      'daysOverdue': 15,
    },
    {
      'name': 'Nikolai Fraiture',
      'id': 'FE-1005',
      'amount': '₹3,200',
      'daysOverdue': 8,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllReports();
  }

  void loadAllReports() {
    loadPerformanceData();
    // Add logic for Fee and Attendance reports here when APIs are ready
  }

  void loadPerformanceData() {
    isPerformanceLoading.value = true;

    // Simulate fetching and calculating performance data based on homework ratings
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
