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

enum AppInputFieldVariant { standard, profile }

enum ResourceType { image, video, document }

enum ChatMenuAction { delete }

enum MessageStatus { sending, sent, delivered, read, failed }

enum FeedbackRating { loveIt, useful, meh, broken }

enum FeeStatus { paid, pending }

enum AssignmentBadge { today, tomorrow, done }

enum AssignmentAttachmentKind { document, image, video, audio }
