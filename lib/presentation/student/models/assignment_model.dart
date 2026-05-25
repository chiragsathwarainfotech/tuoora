import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/enums/app_enums.dart';

class AssignmentAttachment {
  final String id;
  final String name;
  final String sizeLabel;
  final AssignmentAttachmentKind kind;
  final String? url;
  final String? durationLabel;
  final int? pageCount;
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

  String get inferredExtension {
    if (extensionLabel != null) return extensionLabel!.toUpperCase();
    final dot = name.lastIndexOf('.');
    if (dot == -1 || dot == name.length - 1) return '';
    return name.substring(dot + 1).toUpperCase();
  }
}

class Assignment {
  final String id;
  final String title;
  final String subjectLabel;
  final String dueLabel;
  final IconData icon;
  final Color stripe;
  final Color iconBg;
  final Color iconColor;
  final AssignmentBadge badge;
  final String? dueDateFullText;
  final String? instructions;
  final String? assignedBy;
  final List<AssignmentAttachment> attachments;
  final String? pendingNote;
  final String? completedNote;
  final String? gradeNote;

  /// True when the assignment was due before today and the student hasn't
  /// submitted yet. The list UI uses this to dull the row and disable taps
  /// (the student can't act on it anymore).
  final bool isOverdue;

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
    this.isOverdue = false,
  });

  bool get isCompleted => badge == AssignmentBadge.done;

  factory Assignment.fromJson(
    Map<String, dynamic> json, {
    bool isCompleted = false,
  }) {
    final subject = json['subject']?.toString() ?? 'General';

    final palettes = <Map<String, Color>>[
      {'stripe': AppColors.studentProgressOrange, 'bg': AppColors.studentBrandSoft},
      {'stripe': AppColors.subjectPhysics, 'bg': AppColors.subjectPhysicsSoft},
      {'stripe': AppColors.studentPresentText, 'bg': AppColors.studentPresentBg},
      {'stripe': AppColors.studentProgressBlue, 'bg': AppColors.studentUpdateIconBg},
      {'stripe': AppColors.bohoRed, 'bg': AppColors.errorBg},
    ];

    final palette = palettes[Random().nextInt(palettes.length)];

    final stripe = palette['stripe'] as Color;
    final iconBg = palette['bg'] as Color;
    final iconColor = stripe;
    final icon = Icons.menu_book_rounded;

    final attachments = <AssignmentAttachment>[];
    if (json['attachment_url'] != null) {
      final url = json['attachment_url'].toString();
      final name = url.split('/').last;
      final ext = name.split('.').last.toLowerCase();
      var kind = AssignmentAttachmentKind.document;
      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        kind = AssignmentAttachmentKind.image;
      }
      if (['mp4', 'mov'].contains(ext)) kind = AssignmentAttachmentKind.video;

      attachments.add(
        AssignmentAttachment(
          id: url,
          name: name,
          sizeLabel: 'Attachment',
          kind: kind,
          url: url,
        ),
      );
    }

    final rawDue = json['due_date']?.toString();
    DateTime? parsedDue;
    if (rawDue != null && rawDue.isNotEmpty) {
      try {
        parsedDue = DateTime.parse(rawDue);
      } catch (_) {}
    }

    String dueLabelText = rawDue ?? '';
    int? dueDiffDays;
    if (parsedDue != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDay = DateTime(parsedDue.year, parsedDue.month, parsedDue.day);
      dueDiffDays = dueDay.difference(today).inDays;
      if (dueDiffDays == 0) {
        dueLabelText = 'Today';
      } else if (dueDiffDays == 1) {
        dueLabelText = 'Tomorrow';
      } else {
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        dueLabelText = '${parsedDue.day} ${months[parsedDue.month - 1]}';
      }
    }

    // Overdue: API flag wins, otherwise compute from the date diff.
    // Completed work is never "overdue" regardless of date.
    final bool overdue = !isCompleted &&
        (json['is_overdue'] == true ||
            (dueDiffDays != null && dueDiffDays < 0));

    AssignmentBadge badge = AssignmentBadge.today;
    if (isCompleted) {
      badge = AssignmentBadge.done;
    } else {
      if (json['is_overdue'] == true) {
        badge = AssignmentBadge.today;
      } else {
        badge = AssignmentBadge.tomorrow;
      }
    }

    String? completedNoteStr;
    String? gradeNoteStr;
    if (json['submission'] != null) {
      final sub = json['submission'];
      completedNoteStr = 'Status: ${sub['status'] ?? 'Submitted'}';
      if (sub['score'] != null) {
        gradeNoteStr = 'Score: ${sub['score']}';
      }
    }

    return Assignment(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subjectLabel: subject.toUpperCase(),
      dueLabel: dueLabelText,
      icon: icon,
      stripe: stripe,
      iconBg: iconBg,
      iconColor: iconColor,
      badge: badge,
      dueDateFullText: json['due_date'],
      instructions: json['description'],
      assignedBy: 'Batch: ${json['batch_name']}',
      attachments: attachments,
      pendingNote: overdue ? 'Overdue' : null,
      completedNote: completedNoteStr,
      gradeNote: gradeNoteStr,
      isOverdue: overdue,
    );
  }
}

class AssignmentSummary {
  final int total;
  final int pending;
  final int completed;
  final int overdue;

  const AssignmentSummary({
    required this.total,
    required this.pending,
    required this.completed,
    required this.overdue,
  });

  factory AssignmentSummary.fromJson(Map<String, dynamic> json) {
    return AssignmentSummary(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      completed: json['completed'] ?? 0,
      overdue: json['overdue'] ?? 0,
    );
  }
}
