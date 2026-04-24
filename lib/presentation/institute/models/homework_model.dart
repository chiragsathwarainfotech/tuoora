import 'package:fee_easy/data/models/student_model.dart';

class HomeworkModel {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String description;
  final List<String> resourcePaths;
  final String batchId;
  final List<HomeworkSubmission> submissions;

  HomeworkModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.description,
    this.resourcePaths = const [],
    required this.batchId,
    this.submissions = const [],
  });

  bool get isActive => dueDate.isAfter(DateTime.now());
  int get submittedCount => submissions.where((s) => s.isSubmitted).length;
}

class HomeworkSubmission {
  final Student student;
  bool isSubmitted;
  DateTime? submittedAt;
  double? score; // out of 10
  bool isLate;

  HomeworkSubmission({
    required this.student,
    this.isSubmitted = false,
    this.submittedAt,
    this.score,
    this.isLate = false,
  });

  String get status {
    if (!isSubmitted) return 'PENDING';
    if (isLate) return 'LATE';
    return 'SUBMITTED';
  }
}
