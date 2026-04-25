import 'package:fee_easy/presentation/institute/models/student_performance_model.dart';

class BatchPerformance {
  final String batchId;
  final String batchName;
  final double averageRating;
  final int totalStudents;
  final List<StudentPerformance> studentPerformances;

  BatchPerformance({
    required this.batchId,
    required this.batchName,
    required this.averageRating,
    required this.totalStudents,
    required this.studentPerformances,
  });
}
