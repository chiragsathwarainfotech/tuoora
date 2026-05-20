import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';

/// Controller for the student-side Assignments tab + detail screen.
///
/// Owns the tab state (Pending vs Completed), the lists of assignments,
/// and the currently-selected assignment used by the detail screen.
/// Mock seeds match the design screenshots — swap [loadAssignments] for
/// a repository call once the API is wired.
class AssignmentsController extends GetxController {
  /// Active tab: 0 = Pending, 1 = Completed.
  final RxInt activeTab = 0.obs;

  final RxList<Assignment> pending = <Assignment>[].obs;
  final RxList<Assignment> completed = <Assignment>[].obs;

  /// Set when the user taps a card; read by the detail screen.
  final Rxn<Assignment> selectedAssignment = Rxn<Assignment>();

  /// Set when the user taps a file tile; read by the attachment-preview
  /// screen. Reset implicitly when the next attachment is opened.
  final Rxn<AssignmentAttachment> selectedAttachment =
      Rxn<AssignmentAttachment>();

  /// Weekly progress numbers shown in the header card.
  final RxInt weeklyRemaining = 2.obs;
  final RxInt weeklyTotal = 5.obs;
  final RxInt weeklyCompleted = 3.obs;
  final RxString teacherName = 'Mr. Verma'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  void loadAssignments() {
    pending.assignAll(_seedPending);
    completed.assignAll(_seedCompleted);
  }

  void selectTab(int index) {
    if (index < 0 || index > 1 || activeTab.value == index) return;
    activeTab.value = index;
  }

  /// Opens the detail screen for the given [assignment]. Stashing the
  /// model on the controller keeps the detail screen pure UI — it just
  /// reads `selectedAssignment` and rebuilds when it changes.
  void openAssignment(Assignment assignment) {
    selectedAssignment.value = assignment;
    Get.toNamed(AppRoutes.studentAssignmentDetail);
  }

  /// Opens the attachment preview screen. Same pattern as
  /// [openAssignment] — the preview screen reads `selectedAttachment`.
  void openAttachment(AssignmentAttachment attachment) {
    selectedAttachment.value = attachment;
    Get.toNamed(AppRoutes.studentAttachmentPreview);
  }

  List<Assignment> get activeItems =>
      activeTab.value == 0 ? pending : completed;

  // ────────────────────────────────────────────────────────── mock seeds

  static const _commonInstructions =
      'Solve questions 1 to 18 from Exercise 8.1, and questions 1 to 7 from '
      '8.2. Show working clearly. Submit handwritten copies in the next '
      'class.';

  static const _seedPending = <Assignment>[
    Assignment(
      id: 'a-1',
      title: 'Trigonometry — Ch. 8 exercises',
      subjectLabel: AppStrings.studentSubjectMathematics,
      dueLabel: AppStrings.studentDueToday,
      icon: Icons.functions_rounded,
      stripe: AppColors.subjectMath,
      iconBg: AppColors.subjectMathSoft,
      iconColor: AppColors.subjectMath,
      badge: AssignmentBadge.today,
      dueDateFullText: 'Today, 11:59 PM',
      instructions: _commonInstructions,
      assignedBy: 'Mr. R. Verma, 16 May 2026',
      attachments: [
        AssignmentAttachment(
          id: 'att-1',
          name: 'Exercise 8.1 questions.pdf',
          sizeLabel: '420 KB',
          kind: AssignmentAttachmentKind.document,
          pageCount: 4,
        ),
        AssignmentAttachment(
          id: 'att-2',
          name: 'Board worked example.jpg',
          sizeLabel: '1.2 MB',
          kind: AssignmentAttachmentKind.image,
        ),
      ],
      pendingNote:
          'Mr. Verma will mark this complete once reviewed in class.',
    ),
    Assignment(
      id: 'a-2',
      title: 'Light: Reflection notes',
      subjectLabel: AppStrings.studentSubjectPhysics,
      dueLabel: AppStrings.studentDueTomorrow,
      icon: Icons.brightness_5_rounded,
      stripe: AppColors.subjectPhysics,
      iconBg: AppColors.subjectPhysicsSoft,
      iconColor: AppColors.subjectPhysics,
      badge: AssignmentBadge.tomorrow,
      dueDateFullText: 'Tomorrow, 11:59 PM',
      instructions:
          'Read chapter 10 sections 1–3. Prepare a one-page summary of '
          'the laws of reflection with neat ray diagrams.',
      assignedBy: 'Mr. R. Verma, 16 May 2026',
      attachments: [
        AssignmentAttachment(
          id: 'att-3',
          name: 'Reflection laws handout.pdf',
          sizeLabel: '210 KB',
          kind: AssignmentAttachmentKind.document,
          pageCount: 3,
        ),
        AssignmentAttachment(
          id: 'att-3b',
          name: 'Plane mirror ray demo.mp4',
          sizeLabel: '14.8 MB',
          kind: AssignmentAttachmentKind.video,
          durationLabel: '2:34',
        ),
      ],
      pendingNote:
          'Submit your summary in class — Mr. Verma will review and mark.',
    ),
  ];

  static const _seedCompleted = <Assignment>[
    Assignment(
      id: 'a-3',
      title: 'Carbon compounds worksheet',
      subjectLabel: AppStrings.studentSubjectChemistry,
      dueLabel: 'DUE 22 MAY',
      icon: Icons.science_outlined,
      stripe: AppColors.subjectChemistry,
      iconBg: AppColors.subjectChemistrySoft,
      iconColor: AppColors.subjectChemistry,
      badge: AssignmentBadge.done,
      dueDateFullText: '22 May, 2026',
      instructions: _commonInstructions,
      assignedBy: 'Mr. R. Verma, 16 May 2026',
      attachments: [
        AssignmentAttachment(
          id: 'att-4',
          name: 'Worksheet.pdf',
          sizeLabel: '300 KB',
          kind: AssignmentAttachmentKind.document,
          pageCount: 5,
        ),
      ],
      completedNote: 'Marked complete by institute on 19 May',
      gradeNote: 'Graded: Excellent',
    ),
    Assignment(
      id: 'a-4',
      title: 'Linear equations practice set',
      subjectLabel: AppStrings.studentSubjectMathematics,
      dueLabel: 'DUE 20 MAY',
      icon: Icons.functions_rounded,
      stripe: AppColors.subjectMath,
      iconBg: AppColors.subjectMathSoft,
      iconColor: AppColors.subjectMath,
      badge: AssignmentBadge.done,
      dueDateFullText: '20 May, 2026',
      instructions:
          'Solve all questions from the linear-equations practice set. '
          'Submit handwritten copies in the next class.',
      assignedBy: 'Mr. R. Verma, 14 May 2026',
      attachments: [
        AssignmentAttachment(
          id: 'att-5',
          name: 'Linear equations.pdf',
          sizeLabel: '250 KB',
          kind: AssignmentAttachmentKind.document,
        ),
      ],
      completedNote: 'Marked complete by institute on 18 May',
      gradeNote: 'Graded: Very Good',
    ),
    Assignment(
      id: 'a-5',
      title: 'Acids & bases lab report',
      subjectLabel: AppStrings.studentSubjectChemistry,
      dueLabel: 'DUE 18 MAY',
      icon: Icons.science_outlined,
      stripe: AppColors.subjectChemistry,
      iconBg: AppColors.subjectChemistrySoft,
      iconColor: AppColors.subjectChemistry,
      badge: AssignmentBadge.done,
      dueDateFullText: '18 May, 2026',
      instructions:
          'Write a formal lab report covering objective, materials, '
          'observations and conclusion. Include the colour-change table.',
      assignedBy: 'Mr. R. Verma, 12 May 2026',
      attachments: [
        AssignmentAttachment(
          id: 'att-6',
          name: 'Lab report template.pdf',
          sizeLabel: '180 KB',
          kind: AssignmentAttachmentKind.document,
        ),
        AssignmentAttachment(
          id: 'att-7',
          name: 'Setup photo.jpg',
          sizeLabel: '900 KB',
          kind: AssignmentAttachmentKind.image,
        ),
      ],
      completedNote: 'Marked complete by institute on 17 May',
      gradeNote: 'Graded: Good',
    ),
  ];
}
