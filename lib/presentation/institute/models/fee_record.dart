import 'package:fee_easy/data/models/student_model.dart';

class FeeRecord {
  final int id;
  final int studentId;
  final int instituteId;
  final double totalAmount;
  final double paidAmount;
  final String status;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Student? student;

  FeeRecord({
    required this.id,
    required this.studentId,
    required this.instituteId,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.student,
  });

  factory FeeRecord.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    String safeString(dynamic value) {
      return value?.toString() ?? "";
    }

    DateTime safeDate(dynamic value) {
      if (value == null) return DateTime.now();
      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }

    return FeeRecord(
      id: safeInt(json['id']),
      studentId: safeInt(json['student_id']),
      instituteId: safeInt(json['institute_id']),
      totalAmount: safeDouble(json['total_amount']),
      paidAmount: safeDouble(json['paid_amount']),
      status: safeString(json['status']),
      date: safeDate(json['date']),
      createdAt: safeDate(json['created_at']),
      updatedAt: safeDate(json['updated_at']),
      student: json['student'] != null ? Student.fromJson(json['student']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'institute_id': instituteId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'status': status,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'student': student?.toJson(),
    };
  }
}

class FeeListResponse {
  final List<FeeRecord> items;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final double currentMonthTotal;

  FeeListResponse({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.currentMonthTotal,
  });

  factory FeeListResponse.fromJson(Map<String, dynamic> json) {
    double safeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return FeeListResponse(
      items: (json['items'] as List?)
              ?.map((i) => FeeRecord.fromJson(i))
              .toList() ??
          [],
      total: safeInt(json['total']),
      currentPage: safeInt(json['current_page']),
      lastPage: safeInt(json['last_page']),
      perPage: safeInt(json['per_page']),
      currentMonthTotal: safeDouble(json['current_month_total']),
    );
  }
}
