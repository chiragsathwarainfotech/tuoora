import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/core/constants/app_colors.dart';

class Batch {
  final int id;
  final int instituteId;
  final String name;
  final String subject;
  final String description;
  final String fees;
  final String startTime;
  final String endTime;
  final List<String> days;
  final String? classroom;
  final int? maxCapacity;
  final String createdAt;
  final String updatedAt;
  final int? studentsCount;
  final dynamic totalPaid;
  final dynamic totalExpected;
  final List<BatchStudent>? students;

  Batch({
    required this.id,
    required this.instituteId,
    required this.name,
    required this.subject,
    required this.description,
    required this.fees,
    required this.startTime,
    required this.endTime,
    required this.days,
    this.classroom,
    this.maxCapacity,
    required this.createdAt,
    required this.updatedAt,
    this.studentsCount,
    this.totalPaid,
    this.totalExpected,
    this.students,
  });

  BatchModel toUIModel() {
    return BatchModel(
      id: id.toString(),
      title: name,
      time: '$startTime - $endTime',
      subject: subject,
      studentCount: '${studentsCount ?? 0} Students',
      location: classroom ?? 'Main Hall',
      statusLabel: 'Active',
      statusBg: AppColors.instStatusOpenBg,
      leftBorderColor: AppColors.instBorderOpen,
      statusTextColor: AppColors.instStatusOpenText,
      baseFee: double.tryParse(fees.toString()) ?? 0.0,
      description: description,
      totalExpected: totalExpected,
      totalPaid: totalPaid,
      days: days,
      students: students,
    );
  }

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      instituteId: json['institute_id'],
      name: json['name'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      fees: json['fees']?.toString() ?? '0.00',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      days: List<String>.from(json['days'] ?? []),
      classroom: json['classroom'],
      maxCapacity: json['max_capacity'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      studentsCount: json['students_count'],
      totalPaid: json['total_paid'],
      totalExpected: json['total_expected'],
      students: json['students'] != null
          ? (json['students'] as List)
                .map((i) => BatchStudent.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institute_id': instituteId,
      'name': name,
      'subject': subject,
      'description': description,
      'fees': fees,
      'start_time': startTime,
      'end_time': endTime,
      'days': days,
      'classroom': classroom,
      'max_capacity': maxCapacity,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'students_count': studentsCount,
      'total_paid': totalPaid,
      'total_expected': totalExpected,
      'students': students?.map((s) => s.toJson()).toList(),
    };
  }
}

class BatchStudent {
  final int id;
  final String name;
  final int batchId;
  final String? profileImageUrl;

  BatchStudent({
    required this.id,
    required this.name,
    required this.batchId,
    this.profileImageUrl,
  });

  factory BatchStudent.fromJson(Map<String, dynamic> json) {
    return BatchStudent(
      id: json['id'],
      name: json['name'] ?? '',
      batchId: json['batch_id'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'batch_id': batchId,
      'profile_image_url': profileImageUrl,
    };
  }
}

class BatchListResponse {
  final List<Batch> items;
  final int total;
  final int currentPage;
  final int lastPage;

  BatchListResponse({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });

  factory BatchListResponse.fromJson(Map<String, dynamic> json) {
    return BatchListResponse(
      items: (json['items'] as List).map((i) => Batch.fromJson(i)).toList(),
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}
