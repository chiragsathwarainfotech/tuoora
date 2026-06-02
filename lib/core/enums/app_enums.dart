enum NotificationKind {
  homework('homework'),
  homeworkReminder('homework_reminder'),
  homeworkGraded('homework_graded'),
  attendance('attendance'),
  resource('resource'),
  dailyUpdate('daily_update'),
  batchAssignment('batch_assignment'),
  batchRemoval('batch_removal'),
  holidays('holidays'),
  paymentReceiver('payment_receiver'),
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

enum UpdateRecipient {
  students,
  parents,
  both;

  String toJson() => name;
}

enum UpdateTargetType {
  all,
  batch;

  String toJson() => name;
}

enum UpdateCategory {
  Academic,
  Administrative,
  Emergency,
  Event,
  Other;

  String toJson() => name;
}

enum ResourceType { image, video, document }

enum ChatMenuAction { delete }

enum MessageStatus { sending, sent, delivered, read, failed }

enum FeedbackRating { loveIt, useful, meh, broken }

enum FeeStatus { paid, pending }

enum AssignmentBadge { today, tomorrow, done }

enum AssignmentAttachmentKind { document, image, video, audio }

enum ReportPeriod { thisWeek, fourWeeks, twelveWeeks }

enum AttachmentSourceType { assignment, resource }
