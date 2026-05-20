import 'package:flutter/material.dart';

/// Pill shown on the right side of an assignment card.
enum AssignmentBadge { today, tomorrow, done }

/// Type of file attached to an assignment — drives the icon + colours in
/// the attachment file tile.
enum AssignmentAttachmentKind { document, image, video, audio }

/// A single file attached to an assignment.
class AssignmentAttachment {
  final String id;
  final String name; // e.g. 'Exercise 8.1 questions.pdf'
  final String sizeLabel; // e.g. '420 KB'
  final AssignmentAttachmentKind kind;
  final String? url;

  /// Optional. Used by [AssignmentAttachmentKind.video] / `audio` to show
  /// the clip length next to the size, e.g. `2:34`.
  final String? durationLabel;

  /// Optional total page count for documents. Drives the `PAGE 1 OF X`
  /// counter on the preview screen.
  final int? pageCount;

  /// Optional document file extension shown in lowercase on the preview
  /// (e.g. `PDF`). Defaults to inferring from the filename.
  final String? extensionLabel;

  const AssignmentAttachment({
    required this.id,
    required this.name,
    required this.sizeLabel,
    required this.kind,
    this.url,
    this.durationLabel,
    this.pageCount,
    this.extensionLabel,
  });

  /// `PDF`, `JPG`, `MP4`, etc — derived from filename or [extensionLabel].
  String get inferredExtension {
    if (extensionLabel != null) return extensionLabel!.toUpperCase();
    final dot = name.lastIndexOf('.');
    if (dot == -1 || dot == name.length - 1) return '';
    return name.substring(dot + 1).toUpperCase();
  }
}

/// Domain model for a single assignment row + detail screen.
///
/// Card-level fields (icon, stripe, badge, etc.) populate the list tile;
/// the optional detail fields (instructions, attachments, assignedBy, …)
/// populate the detail screen. All detail fields are nullable so that
/// list-only data sources don't have to provide them.
class Assignment {
  final String id;
  final String title;
  final String subjectLabel; // e.g. 'MATHEMATICS'
  final String dueLabel; // e.g. 'DUE TODAY', 'DUE 22 MAY'
  final IconData icon;
  final Color stripe;
  final Color iconBg;
  final Color iconColor;
  final AssignmentBadge badge;

  // ─── Detail-screen fields ────────────────────────────────────────────
  /// Human-friendly full due text shown on the detail page DUE card.
  /// e.g. `Today, 11:59 PM`, `22 May, 2026`.
  final String? dueDateFullText;

  /// Long instructional body for the detail page.
  final String? instructions;

  /// e.g. `Mr. R. Verma, 16 May 2026`.
  final String? assignedBy;

  /// Files attached by the teacher. Empty list when nothing is attached.
  final List<AssignmentAttachment> attachments;

  /// Pending-state banner subtitle. Used only when [badge] is
  /// [AssignmentBadge.today] / [AssignmentBadge.tomorrow].
  final String? pendingNote;

  /// First line in the completion banner.
  /// e.g. `Marked complete by institute on 19 May`.
  final String? completedNote;

  /// Second line in the completion banner.
  /// e.g. `Graded: Excellent`.
  final String? gradeNote;

  const Assignment({
    required this.id,
    required this.title,
    required this.subjectLabel,
    required this.dueLabel,
    required this.icon,
    required this.stripe,
    required this.iconBg,
    required this.iconColor,
    required this.badge,
    this.dueDateFullText,
    this.instructions,
    this.assignedBy,
    this.attachments = const [],
    this.pendingNote,
    this.completedNote,
    this.gradeNote,
  });

  bool get isCompleted => badge == AssignmentBadge.done;
}
