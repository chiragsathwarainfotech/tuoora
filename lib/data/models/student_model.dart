class Student {
  final String id;
  final String name;
  final String? guardianName;
  final String? phone;
  final String grade;
  final String batch;
  final String status;
  final String imageUrl;
  final bool showOnlineBadge;
  final bool isPending;
  final Map<String, String>? feeBreakdown;

  const Student({
    required this.id,
    required this.name,
    this.guardianName,
    this.phone,
    required this.grade,
    required this.batch,
    required this.status,
    required this.imageUrl,
    this.showOnlineBadge = false,
    this.isPending = false,
    this.feeBreakdown,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    String batchName = 'Not Assigned';
    if (json['batch'] != null) {
      if (json['batch'] is Map) {
        batchName = json['batch']['name'] ?? 'Not Assigned';
      } else {
        batchName = json['batch'].toString();
      }
    }

    return Student(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      guardianName: json['guardian_name'],
      phone: json['phone'],
      grade: json['standard'] ?? 'Not Specified',
      batch: batchName,
      status: json['status'] == '1' ? 'Active' : 'Inactive',
      imageUrl: json['image_url'] ?? 'https://i.pravatar.cc/150?img=11',
      showOnlineBadge: json['show_online_badge'] ?? false,
      isPending: json['is_pending'] ?? false,
      feeBreakdown: json['fee_breakdown'] != null
          ? Map<String, String>.from(json['fee_breakdown'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guardian_name': guardianName,
      'phone': phone,
      'grade': grade,
      'batch': batch,
      'status': status,
      'image_url': imageUrl,
      'show_online_badge': showOnlineBadge,
      'is_pending': isPending,
      'fee_breakdown': feeBreakdown,
    };
  }
}
