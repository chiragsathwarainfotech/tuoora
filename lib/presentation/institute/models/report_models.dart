import 'package:fee_easy/presentation/institute/models/fee_record.dart';

class FeeReportSummary {
  final double totalAmount;
  final double paidAmount;
  final double dueAmount;
  final int count;

  FeeReportSummary({
    required this.totalAmount,
    required this.paidAmount,
    required this.dueAmount,
    required this.count,
  });

  factory FeeReportSummary.fromJson(Map<String, dynamic> json) {
    return FeeReportSummary(
      totalAmount: FeeRecord.safeDouble(json['total_amount']),
      paidAmount: FeeRecord.safeDouble(json['paid_amount']),
      dueAmount: FeeRecord.safeDouble(json['due_amount']),
      count: FeeRecord.safeInt(json['count']),
    );
  }
}

class FeeReportBatch {
  final int batchId;
  final String batchName;
  final double batchFees;
  final double totalCollected;
  final double totalDue;
  final int studentsCount;

  FeeReportBatch({
    required this.batchId,
    required this.batchName,
    required this.batchFees,
    required this.totalCollected,
    required this.totalDue,
    required this.studentsCount,
  });

  factory FeeReportBatch.fromJson(Map<String, dynamic> json) {
    return FeeReportBatch(
      batchId: FeeRecord.safeInt(json['batch_id']),
      batchName: FeeRecord.safeString(json['batch_name']),
      batchFees: FeeRecord.safeDouble(json['batch_fees']),
      totalCollected: FeeRecord.safeDouble(json['total_collected']),
      totalDue: FeeRecord.safeDouble(json['total_due']),
      studentsCount: FeeRecord.safeInt(json['students_count']),
    );
  }
}

class FeeReportResponse {
  final FeeReportSummary summary;
  final List<FeeReportBatch> batches;

  FeeReportResponse({
    required this.summary,
    required this.batches,
  });

  factory FeeReportResponse.fromJson(Map<String, dynamic> json) {
    return FeeReportResponse(
      summary: FeeReportSummary.fromJson(json['summary'] ?? {}),
      batches: (json['batches'] as List? ?? [])
          .map((i) => FeeReportBatch.fromJson(i))
          .toList(),
    );
  }
}

class BatchFeeDetailResponse {
  final FeeReportSummary summary;
  final List<FeeRecord> fees;

  BatchFeeDetailResponse({
    required this.summary,
    required this.fees,
  });

  factory BatchFeeDetailResponse.fromJson(Map<String, dynamic> json) {
    return BatchFeeDetailResponse(
      summary: FeeReportSummary.fromJson(json['summary'] ?? {}),
      fees: (json['fees'] as List? ?? [])
          .map((i) => FeeRecord.fromJson(i))
          .toList(),
    );
  }
}

// Attendance Reports
class AttendanceReportSummary {
  final int present;
  final int absent;
  final int leave;
  final int total;

  AttendanceReportSummary({
    required this.present,
    required this.absent,
    required this.leave,
    required this.total,
  });

  factory AttendanceReportSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceReportSummary(
      present: FeeRecord.safeInt(json['present']),
      absent: FeeRecord.safeInt(json['absent']),
      leave: FeeRecord.safeInt(json['leave']),
      total: FeeRecord.safeInt(json['total']),
    );
  }
}

class AttendanceReportBatch {
  final int batchId;
  final String batchName;
  final double avgAttendance;
  final int studentsCount;

  AttendanceReportBatch({
    required this.batchId,
    required this.batchName,
    required this.avgAttendance,
    required this.studentsCount,
  });

  factory AttendanceReportBatch.fromJson(Map<String, dynamic> json) {
    return AttendanceReportBatch(
      batchId: FeeRecord.safeInt(json['batch_id']),
      batchName: FeeRecord.safeString(json['batch_name']),
      avgAttendance: FeeRecord.safeDouble(json['avg_attendance']),
      studentsCount: FeeRecord.safeInt(json['students_count']),
    );
  }
}

class AttendanceReportResponse {
  final AttendanceReportSummary summary;
  final List<AttendanceReportBatch> batches;

  AttendanceReportResponse({
    required this.summary,
    required this.batches,
  });

  factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceReportResponse(
      summary: AttendanceReportSummary.fromJson(json['summary'] ?? {}),
      batches: (json['batches'] as List? ?? [])
          .map((i) => AttendanceReportBatch.fromJson(i))
          .toList(),
    );
  }
}

class AttendanceDetailRecord {
  final int id;
  final int studentId;
  final String status;
  final String studentName;
  final int presentDays;

  AttendanceDetailRecord({
    required this.id,
    required this.studentId,
    required this.status,
    required this.studentName,
    required this.presentDays,
  });

  factory AttendanceDetailRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceDetailRecord(
      id: FeeRecord.safeInt(json['id']),
      studentId: FeeRecord.safeInt(json['student_id']),
      status: FeeRecord.safeString(json['status']),
      studentName: FeeRecord.safeString(json['student']?['name']),
      presentDays: FeeRecord.safeInt(json['student']?['present_days']),
    );
  }
}

class BatchAttendanceDetailResponse {
  final AttendanceReportSummary summary;
  final List<AttendanceDetailRecord> attendance;

  BatchAttendanceDetailResponse({
    required this.summary,
    required this.attendance,
  });

  factory BatchAttendanceDetailResponse.fromJson(Map<String, dynamic> json) {
    return BatchAttendanceDetailResponse(
      summary: AttendanceReportSummary.fromJson(json['summary'] ?? {}),
      attendance: (json['attendance'] as List? ?? [])
          .map((i) => AttendanceDetailRecord.fromJson(i))
          .toList(),
    );
  }
}

// Performance Reports
class PerformanceReportSummary {
  final String averagePerformance;

  PerformanceReportSummary({required this.averagePerformance});

  factory PerformanceReportSummary.fromJson(Map<String, dynamic> json) {
    return PerformanceReportSummary(
      averagePerformance: FeeRecord.safeString(json['average_performance']),
    );
  }
}

class PerformanceReportBatch {
  final int batchId;
  final String batchName;
  final String avgScore;
  final int studentsCount;

  PerformanceReportBatch({
    required this.batchId,
    required this.batchName,
    required this.avgScore,
    required this.studentsCount,
  });

  factory PerformanceReportBatch.fromJson(Map<String, dynamic> json) {
    return PerformanceReportBatch(
      batchId: FeeRecord.safeInt(json['batch_id']),
      batchName: FeeRecord.safeString(json['batch_name']),
      avgScore: FeeRecord.safeString(json['avg_score']),
      studentsCount: FeeRecord.safeInt(json['students_count']),
    );
  }
}

class PerformanceReportResponse {
  final PerformanceReportSummary summary;
  final List<PerformanceReportBatch> batches;

  PerformanceReportResponse({
    required this.summary,
    required this.batches,
  });

  factory PerformanceReportResponse.fromJson(Map<String, dynamic> json) {
    return PerformanceReportResponse(
      summary: PerformanceReportSummary.fromJson(json['summary'] ?? {}),
      batches: (json['batches'] as List? ?? [])
          .map((i) => PerformanceReportBatch.fromJson(i))
          .toList(),
    );
  }
}

class StudentPerformanceDetail {
  final int studentId;
  final String studentName;
  final String avgScore;

  StudentPerformanceDetail({
    required this.studentId,
    required this.studentName,
    required this.avgScore,
  });

  factory StudentPerformanceDetail.fromJson(Map<String, dynamic> json) {
    return StudentPerformanceDetail(
      studentId: FeeRecord.safeInt(json['student_id']),
      studentName: FeeRecord.safeString(json['student_name']),
      avgScore: FeeRecord.safeString(json['avg_score']),
    );
  }
}

class BatchPerformanceDetailResponse {
  final PerformanceReportSummary summary;
  final List<StudentPerformanceDetail> students;

  BatchPerformanceDetailResponse({
    required this.summary,
    required this.students,
  });

  factory BatchPerformanceDetailResponse.fromJson(Map<String, dynamic> json) {
    return BatchPerformanceDetailResponse(
      summary: PerformanceReportSummary.fromJson(json['summary'] ?? {}),
      students: (json['students'] as List? ?? [])
          .map((i) => StudentPerformanceDetail.fromJson(i))
          .toList(),
    );
  }
}
