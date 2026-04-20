class UpdateModel {
  final String id;
  final String category;
  final String audience;
  final String subject;
  final String message;
  final DateTime date;
  final List<String> attachments;
  final bool appNotification;
  final bool whatsapp;

  UpdateModel({
    required this.id,
    required this.category,
    required this.audience,
    required this.subject,
    required this.message,
    required this.date,
    this.attachments = const [],
    this.appNotification = true,
    this.whatsapp = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
