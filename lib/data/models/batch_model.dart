import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/data/models/staff_model.dart';

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
  final int? staffId;
  final Staff? staff;

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
    this.staffId,
    this.staff,
  });

  BatchModel toUIModel() {
    return BatchModel(
      id: id.toString(),
      title: name,
      time: '${_format12Hour(startTime)} - ${_format12Hour(endTime)}',
      subject: subject,
      studentCount: '${studentsCount ?? 0} Students',
      location: classroom ?? 'Main Hall',
      statusLabel: 'Active',
      statusBg: AppColors.successBg,
      leftBorderColor: AppColors.primaryBrand,
      statusTextColor: AppColors.greenText,
      baseFee: double.tryParse(fees.toString()) ?? 0.0,
      description: description,
      totalExpected: totalExpected,
      totalPaid: totalPaid,
      days: days,
      students: students,
      classroom: classroom,
      staffId: staffId,
      staffName: staff?.fullName,
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
      staffId: json['staff_id'] == null
          ? null
          : int.tryParse(json['staff_id'].toString()),
      staff: json['staff'] != null ? Staff.fromJson(json['staff']) : null,
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
      'staff_id': staffId,
    };
  }

  // Converts a server-format time like "18:30" or "06:00 PM" into a 12-hour
  // display string like "6:30 PM". Falls back to the original input if it
  // cannot be parsed so we never blank out the schedule.
  static String _format12Hour(String raw) {
    if (raw.trim().isEmpty) return raw;
    final cleaned = raw.trim();
    final upper = cleaned.toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) return cleaned;
    final parts = cleaned.split(':');
    if (parts.length < 2) return cleaned;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return cleaned;
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = ((h + 11) % 12) + 1;
    final mm = m.toString().padLeft(2, '0');
    return '$hour12:$mm $period';
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

