import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/widgets/student_section_header.dart';

class StudentAssignmentDetailScreen extends GetView<AssignmentsController> {
  const StudentAssignmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const CommonLoading(color: AppColors.studentBrand);
          }
          final assignment = controller.selectedAssignment.value;
          if (assignment == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.s24),
                child: Text('No assignment selected'),
              ),
            );
          }
          return _DetailBody(assignment: assignment);
        }),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Assignment assignment;

  const _DetailBody({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudentAppBar(title: assignment.title, showDefaultActions: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s16,
              AppSpacing.s16,
              AppSpacing.s24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DueCard(assignment: assignment),
                const SizedBox(height: AppSpacing.s12),
                _InstructionsCard(assignment: assignment),
                if (assignment.attachments.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s20),
                  const StudentSectionHeader(
                    title: AppStrings.studentAssignmentDetailAttachments,
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  ..._interleave(
                    assignment.attachments.map(
                      (a) => _AttachmentTile(
                        attachment: a,
                        onTap: () =>
                            Get.find<AssignmentsController>().openAttachment(a),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s8),
                  ),
                ],
                const SizedBox(height: AppSpacing.s16),
                _StatusBanner(assignment: assignment),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static List<Widget> _interleave(Iterable<Widget> items, Widget separator) {
    final list = items.toList();
    if (list.length <= 1) return list;
    final out = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      if (i > 0) out.add(separator);
      out.add(list[i]);
    }
    return out;
  }
}

class _DueCard extends StatelessWidget {
  final Assignment assignment;

  const _DueCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final isCompleted = assignment.isCompleted;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.studentBrandSoft,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: AppColors.studentBrand,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.studentAssignmentDetailDueLabel,
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.orangeTag,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  assignment.dueDateFullText ?? assignment.dueLabel,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.h8,
          _StatusPill(isCompleted: isCompleted, badge: assignment.badge),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isCompleted;
  final AssignmentBadge badge;

  const _StatusPill({required this.isCompleted, required this.badge});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final String label;
    if (isCompleted) {
      bg = AppColors.studentPresentBg;
      fg = AppColors.studentPresentText;
      label = AppStrings.studentAssignmentDetailCompletedPill;
    } else if (badge == AssignmentBadge.tomorrow) {
      bg = AppColors.amberLight;
      fg = AppColors.studentTomorrowPillText;
      label = AppStrings.studentTomorrowPill;
    } else {
      bg = AppColors.studentBrandSoft;
      fg = AppColors.studentBrand;
      label = AppStrings.studentTodayPill;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Text(
        label,
        style: AppTextStyles.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── Instructions

class _InstructionsCard extends StatelessWidget {
  final Assignment assignment;

  const _InstructionsCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.studentAssignmentDetailInstructions,
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.orangeTag,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            assignment.instructions ?? '—',
            style: AppTextStyles.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (assignment.assignedBy != null) ...[
            const SizedBox(height: AppSpacing.s12),
            Divider(
              height: 1,
              color: AppColors.borderGrey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.s10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${AppStrings.studentAssignmentDetailAssignedBy} ',
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: assignment.assignedBy!,
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── Attachment tile

class _AttachmentTile extends StatelessWidget {
  final AssignmentAttachment attachment;
  final VoidCallback? onTap;

  const _AttachmentTile({required this.attachment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.s14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _AttachmentIcon(kind: attachment.kind),
              AppSpacing.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      attachment.name,
                      style: AppTextStyles.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_kindLabel(attachment.kind)} · ${attachment.sizeLabel}',
                      style: AppTextStyles.outfit(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _kindLabel(AssignmentAttachmentKind kind) {
    switch (kind) {
      case AssignmentAttachmentKind.document:
        return AppStrings.studentAssignmentAttachmentDocument;
      case AssignmentAttachmentKind.image:
        return AppStrings.studentAssignmentAttachmentImage;
      case AssignmentAttachmentKind.video:
        return AppStrings.studentAssignmentAttachmentVideo;
      case AssignmentAttachmentKind.audio:
        return AppStrings.studentAssignmentAttachmentAudio;
    }
  }
}

class _AttachmentIcon extends StatelessWidget {
  final AssignmentAttachmentKind kind;

  const _AttachmentIcon({required this.kind});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final IconData icon;
    switch (kind) {
      case AssignmentAttachmentKind.document:
        bg = AppColors.studentPresentBg;
        fg = AppColors.studentPresentText;
        icon = Icons.description_rounded;
        break;
      case AssignmentAttachmentKind.image:
        bg = AppColors.studentBrandSoft;
        fg = AppColors.orangeTag;
        icon = Icons.image_rounded;
        break;
      case AssignmentAttachmentKind.video:
        bg = AppColors.studentBrandSoft;
        fg = AppColors.orangeTag;
        icon = Icons.videocam_rounded;
        break;
      case AssignmentAttachmentKind.audio:
        bg = AppColors.studentBrandSoft;
        fg = AppColors.orangeTag;
        icon = Icons.audiotrack_rounded;
        break;
    }
    return Container(
      width: AppSpacing.s40,
      height: AppSpacing.s40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Icon(icon, color: fg, size: 20),
    );
  }
}

// ───────────────────────────────────────────────────────── Status banner

class _StatusBanner extends StatelessWidget {
  final Assignment assignment;

  const _StatusBanner({required this.assignment});

  @override
  Widget build(BuildContext context) {
    if (assignment.isCompleted) {
      return _CompletedBanner(assignment: assignment);
    }
    return _PendingBanner(assignment: assignment);
  }
}

class _PendingBanner extends StatelessWidget {
  final Assignment assignment;

  const _PendingBanner({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.amberLight,
        borderRadius: BorderRadius.circular(AppSpacing.s14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 20,
              color: AppColors.studentTomorrowPillText,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.studentAssignmentDetailPendingTitle,
                  style: AppTextStyles.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.studentTomorrowPillText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  assignment.pendingNote ?? '',
                  style: AppTextStyles.outfit(
                    fontSize: 12,
                    color: AppColors.studentTomorrowPillText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedBanner extends StatelessWidget {
  final Assignment assignment;

  const _CompletedBanner({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.studentPresentBg,
        borderRadius: BorderRadius.circular(AppSpacing.s14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_rounded,
              size: 20,
              color: AppColors.studentPresentText,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  assignment.completedNote ?? '',
                  style: AppTextStyles.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.studentPresentText,
                  ),
                ),
                if (assignment.gradeNote != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    assignment.gradeNote!,
                    style: AppTextStyles.outfit(
                      fontSize: 12,
                      color: AppColors.studentPresentText,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
