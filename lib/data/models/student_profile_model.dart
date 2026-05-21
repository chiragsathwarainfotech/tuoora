class StudentProfileModel {
  final StudentProfileHeader header;
  final StudentProfileStats stats;
  final StudentProfileQr studentQr;
  final StudentProfileInfo info;

  StudentProfileModel({
    required this.header,
    required this.stats,
    required this.studentQr,
    required this.info,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      header: StudentProfileHeader.fromJson(json['header'] ?? {}),
      stats: StudentProfileStats.fromJson(json['stats'] ?? {}),
      studentQr: StudentProfileQr.fromJson(json['student_qr'] ?? {}),
      info: StudentProfileInfo.fromJson(json['info'] ?? {}),
    );
  }
}

class StudentProfileHeader {
  final String name;
  final String initials;
  final String avatarUrl;
  final String standard;
  final String batchName;
  final String subject;
  final String rollNo;
  final String memberSince;

  StudentProfileHeader({
    required this.name,
    required this.initials,
    required this.avatarUrl,
    required this.standard,
    required this.batchName,
    required this.subject,
    required this.rollNo,
    required this.memberSince,
  });

  factory StudentProfileHeader.fromJson(Map<String, dynamic> json) {
    return StudentProfileHeader(
      name: json['name'] ?? '',
      initials: json['initials'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      standard: json['standard'] ?? '',
      batchName: json['batch_name'] ?? '',
      subject: json['subject'] ?? '',
      rollNo: json['roll_no'] ?? '',
      memberSince: json['member_since'] ?? '',
    );
  }
}

class StudentProfileStats {
  final int attendancePct;
  final String attendanceLabel;
  final int assignmentsPct;
  final String assignmentsLabel;

  StudentProfileStats({
    required this.attendancePct,
    required this.attendanceLabel,
    required this.assignmentsPct,
    required this.assignmentsLabel,
  });

  factory StudentProfileStats.fromJson(Map<String, dynamic> json) {
    return StudentProfileStats(
      attendancePct: json['attendance_pct'] ?? 0,
      attendanceLabel: json['attendance_label'] ?? '',
      assignmentsPct: json['assignments_pct'] ?? 0,
      assignmentsLabel: json['assignments_label'] ?? '',
    );
  }
}

class StudentProfileQr {
  final String idHash;
  final String displayId;
  final String hint;

  StudentProfileQr({
    required this.idHash,
    required this.displayId,
    required this.hint,
  });

  factory StudentProfileQr.fromJson(Map<String, dynamic> json) {
    return StudentProfileQr(
      idHash: json['id_hash'] ?? '',
      displayId: json['display_id'] ?? '',
      hint: json['hint'] ?? '',
    );
  }
}

class StudentProfileInfo {
  final String phone;
  final String email;
  final String? parentName;
  final String? parentPhone;
  final String parentRelation;

  StudentProfileInfo({
    required this.phone,
    required this.email,
    this.parentName,
    this.parentPhone,
    required this.parentRelation,
  });

  factory StudentProfileInfo.fromJson(Map<String, dynamic> json) {
    return StudentProfileInfo(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      parentName: json['parent_name'],
      parentPhone: json['parent_phone'],
      parentRelation: json['parent_relation'] ?? '',
    );
  }
}
