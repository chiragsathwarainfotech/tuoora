import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';

class StudentAttachmentTile extends StatelessWidget {
  final AssignmentAttachment attachment;
  final VoidCallback? onTap;

  const StudentAttachmentTile({
    super.key,
    required this.attachment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.s14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s14),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s14),
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
              StudentAttachmentIcon(kind: attachment.kind),
              AppSpacing.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      attachment.name,
                      style: AppTextStyles.manrope(
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
                      style: AppTextStyles.lexend(
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

class StudentAttachmentIcon extends StatelessWidget {
  final AssignmentAttachmentKind kind;

  const StudentAttachmentIcon({super.key, required this.kind});

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
