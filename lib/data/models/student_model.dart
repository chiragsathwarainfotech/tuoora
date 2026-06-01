class Student {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int instituteId;
  final int? parentId;
  final int? batchId;
  final String standard;
  final String dob;
  final String? guardianName;
  final String? monthlyFee;
  final String? schoolName;
  final String status;
  final String idHash;
  final String createdAt;
  final String updatedAt;
  final String profileImageUrl;
  final dynamic batch;

  /// Outstanding fee amount for this student (server-computed). Positive
  /// when the student owes money, zero when settled, can be negative when
  /// the student has overpaid / has a credit.
  final num totalDue;

  /// Past fee transactions for this student. Used to populate the fees
  /// list below the ID card on the institute Student Profile screen.
  final List<StudentFee> fees;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.instituteId,
    this.parentId,
    this.batchId,
    required this.standard,
    required this.dob,
    this.guardianName,
    this.monthlyFee,
    this.schoolName,
    required this.status,
    required this.idHash,
    required this.createdAt,
    required this.updatedAt,
    required this.profileImageUrl,
    this.batch,
    this.totalDue = 0,
    this.fees = const [],
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic value, {int fallback = 0}) {
      if (value == null) return fallback;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? fallback;
    }

    int? safeNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    return Student(
      id: safeInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      instituteId: safeInt(json['institute_id']),
      parentId: safeNullableInt(json['parent_id']),
      batchId: safeNullableInt(json['batch_id']),
      standard: json['standard']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      guardianName: json['guardian_name']?.toString(),
      monthlyFee: json['monthly_fee']?.toString(),
      schoolName: json['school_name']?.toString(),
      status: json['status']?.toString() ?? '1',
      idHash: json['id_hash']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      profileImageUrl: json['profile_image_url']?.toString() ?? '',
      batch: json['batch'],
      totalDue: num.tryParse(json['total_due']?.toString() ?? '0') ?? 0,
      fees: (json['fees'] as List?)
              ?.whereType<Map>()
              .map((e) => StudentFee.fromJson(e.cast<String, dynamic>()))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'institute_id': instituteId,
      'parent_id': parentId,
      'batch_id': batchId,
      'standard': standard,
      'dob': dob,
      'guardian_name': guardianName,
      'monthly_fee': monthlyFee,
      'school_name': schoolName,
      'status': status,
      'id_hash': idHash,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'profile_image_url': profileImageUrl,
      'batch': batch,
      'total_due': totalDue,
      'fees': fees.map((f) => f.toJson()).toList(),
    };
  }

  Student copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? instituteId,
    int? parentId,
    int? batchId,
    String? standard,
    String? dob,
    String? guardianName,
    String? monthlyFee,
    String? schoolName,
    String? status,
    String? idHash,
    String? createdAt,
    String? updatedAt,
    String? profileImageUrl,
    dynamic batch,
    num? totalDue,
    List<StudentFee>? fees,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      instituteId: instituteId ?? this.instituteId,
      parentId: parentId ?? this.parentId,
      batchId: batchId ?? this.batchId,
      standard: standard ?? this.standard,
      dob: dob ?? this.dob,
      guardianName: guardianName ?? this.guardianName,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      schoolName: schoolName ?? this.schoolName,
      status: status ?? this.status,
      idHash: idHash ?? this.idHash,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      batch: batch ?? this.batch,
      totalDue: totalDue ?? this.totalDue,
      fees: fees ?? this.fees,
    );
  }

  // Helper getters for UI compatibility
  String get grade => standard;
  String get imageUrl => profileImageUrl;
  String get currentBatchName {
    if (batch != null && batch is Map) {
      return batch['name'] ?? 'Not Assigned';
    }
    return 'Not Assigned';
  }
}

/// One fee transaction belonging to a [Student]. Mirrors the entries the
/// student-list API returns under `student.fees[]`.
class StudentFee {
  final int id;
  final int studentId;
  final String totalAmount;
  final String paidAmount;
  final String status;
  final String date;

  const StudentFee({
    required this.id,
    required this.studentId,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    required this.date,
  });

  factory StudentFee.fromJson(Map<String, dynamic> json) {
    return StudentFee(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      studentId: int.tryParse(json['student_id']?.toString() ?? '0') ?? 0,
      totalAmount: json['total_amount']?.toString() ?? '0.00',
      paidAmount: json['paid_amount']?.toString() ?? '0.00',
      status: json['status']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'total_amount': totalAmount,
        'paid_amount': paidAmount,
        'status': status,
        'date': date,
      };
}

