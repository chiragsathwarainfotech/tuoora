/// Discriminator for `/student/notifications` rows. The `value` matches
/// the API `type` string so we can round-trip without a switch in
/// callers.
enum NotificationKind {
  homework('homework'),
  homeworkReminder('homework_reminder'),
  homeworkGraded('homework_graded'),
  attendance('attendance'),
  resource('resource'),
  dailyUpdate('daily_update'),
  batchAssignment('batch_assignment'),
  batchRemoval('batch_removal'),
  unknown('');

  final String value;
  const NotificationKind(this.value);

  static NotificationKind fromString(String? raw) {
    if (raw == null) return NotificationKind.unknown;
    for (final k in NotificationKind.values) {
      if (k.value == raw) return k;
    }
    return NotificationKind.unknown;
  }
}

class StudentNotification {
  final int id;
  final String title;
  final String message;
  final String? image;
  final NotificationKind kind;

  /// API id the notification points to (e.g. homework id, resource id).
  /// Returned as a string by the API; parsed lazily via [referenceIdInt].
  final String? referenceId;

  final bool isRead;
  final DateTime? createdAt;

  const StudentNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.image,
    required this.kind,
    required this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  int? get referenceIdInt =>
      referenceId == null ? null : int.tryParse(referenceId!);

  factory StudentNotification.fromJson(Map<String, dynamic> json) {
    DateTime? created;
    final rawCreated = json['created_at']?.toString();
    if (rawCreated != null && rawCreated.isNotEmpty) {
      try {
        created = DateTime.parse(rawCreated).toLocal();
      } catch (_) {}
    }

    return StudentNotification(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      image: json['image']?.toString(),
      kind: NotificationKind.fromString(json['type']?.toString()),
      referenceId: json['reference_id']?.toString(),
      isRead: json['is_read'] == true,
      createdAt: created,
    );
  }
}
