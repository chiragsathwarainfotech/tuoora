class NotificationModel {
  final int id;
  final String userType;
  final int userId;
  final String title;
  final String message;
  final String? image;
  final String type;
  final String target;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userType,
    required this.userId,
    required this.title,
    required this.message,
    this.image,
    required this.type,
    required this.target,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userType: json['user_type'] ?? '',
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      image: json['image'],
      type: json['type'] ?? '',
      target: json['target'] ?? '',
      referenceId: json['reference_id']?.toString(),
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
      'user_id': userId,
      'title': title,
      'message': message,
      'image': image,
      'type': type,
      'target': target,
      'reference_id': referenceId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

