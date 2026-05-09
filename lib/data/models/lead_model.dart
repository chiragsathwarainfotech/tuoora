class LeadListResponse {
  final List<Lead> data;
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  LeadListResponse({
    required this.data,
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory LeadListResponse.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] ?? {};
    return LeadListResponse(
      data: (json['data'] as List).map((i) => Lead.fromJson(i)).toList(),
      total: pagination['total'] ?? 0,
      perPage: pagination['per_page'] ?? 10,
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
    );
  }
}

class Lead {
  final int id;
  final int instituteId;
  final String fullName;
  final String phone;
  final String email;
  final String? address;
  final String? courseSelection;
  final String? reference;
  final String status;
  final List<LeadNote> notes;
  final DateTime createdAt;

  Lead({
    required this.id,
    required this.instituteId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.address,
    this.courseSelection,
    this.reference,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      instituteId: json['institute_id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      courseSelection: json['course_selection'],
      reference: json['reference'],
      status: json['status'] ?? 'New',
      notes: json['notes'] != null
          ? (json['notes'] as List).map((i) => LeadNote.fromJson(i)).toList()
          : [],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class LeadNote {
  final int id;
  final int leadId;
  final int instituteId;
  final String title;
  final String note;
  final DateTime createdAt;

  LeadNote({
    required this.id,
    required this.leadId,
    required this.instituteId,
    required this.title,
    required this.note,
    required this.createdAt,
  });

  factory LeadNote.fromJson(Map<String, dynamic> json) {
    return LeadNote(
      id: json['id'],
      leadId: json['lead_id'],
      instituteId: json['institute_id'],
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
