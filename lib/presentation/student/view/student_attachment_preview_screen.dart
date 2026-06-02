import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/presentation/student/controllers/attachment_preview_controller.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentAttachmentPreviewScreen
    extends GetView<AttachmentPreviewController> {
  const StudentAttachmentPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final attachment = controller.selectedAttachment.value;
          if (attachment == null) {
            return const Center(
              child: Text(AppStrings.studentAttachmentNoneSelected),
            );
          }
          if (controller.isAttachmentLoading.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StudentAppBar(
                  title: attachment.name,
                  showDefaultActions: false,
                ),
                const Expanded(
                  child: CommonLoading(color: AppColors.primaryBrand),
                ),
              ],
            );
          }
          return _Body(attachment: attachment);
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _Body({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudentAppBar(title: attachment.name, showDefaultActions: false),
        Padding(
          padding: AppSpacing.screenPaddingTop,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PreviewSurface(attachment: attachment),
              const SizedBox(height: AppSpacing.s12),
              _FileInfoCard(attachment: attachment),
              const SizedBox(height: AppSpacing.s12),
              const _ActionRow(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewSurface extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _PreviewSurface({required this.attachment});

  @override
  Widget build(BuildContext context) {
    switch (attachment.kind) {
      case AssignmentAttachmentKind.image:
        return _ImagePreview(attachment: attachment);
      case AssignmentAttachmentKind.video:
        return _VideoPreview(attachment: attachment);
      case AssignmentAttachmentKind.document:
        return _DocumentPreview(attachment: attachment);
      case AssignmentAttachmentKind.audio:
        return _AudioPreview(attachment: attachment);
    }
  }
}

class _ImagePreview extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _ImagePreview({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final url = attachment.url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        color: AppColors.background,
        constraints: const BoxConstraints(minHeight: 240),
        child: url != null && url.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, _) => const _LoadingPlaceholder(),
                errorWidget: (_, _, _) =>
                    const _ErrorPlaceholder(icon: Icons.broken_image_outlined),
              )
            : const _ErrorPlaceholder(icon: Icons.image_outlined),
      ),
    );
  }
}

class _VideoPreview extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _VideoPreview({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final duration = attachment.durationLabel ?? '0:00';
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: Container(
        height: 220,
        color: AppColors.textPrimary,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.textPrimary,
                  size: 36,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0:00',
                        style: AppTextStyles.outfit(
                          fontSize: 10,
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        duration,
                        style: AppTextStyles.outfit(
                          fontSize: 10,
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentPreview extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _DocumentPreview({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final ext = attachment.inferredExtension;
    final pages = attachment.pageCount ?? 1;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _docHeadline(attachment.name),
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s12),
                ...List.generate(7, (i) {
                  final widthFactor = (i == 6) ? 0.55 : (0.7 + (i % 3) * 0.1);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: widthFactor.clamp(0.4, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.borderGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PAGE 1 OF $pages',
                style: AppTextStyles.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${ext.isEmpty ? 'FILE' : ext} · ${attachment.sizeLabel}',
                style: AppTextStyles.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _docHeadline(String filename) {
    final dot = filename.lastIndexOf('.');
    return dot == -1 ? filename : filename.substring(0, dot);
  }
}

class _AudioPreview extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _AudioPreview({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final duration = attachment.durationLabel ?? '0:00';
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.primaryBrandLight,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.orangeTag,
              size: 36,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            duration,
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.orangeTag,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: CommonLoading(color: AppColors.primaryBrand),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final IconData icon;

  const _ErrorPlaceholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Center(child: Icon(icon, size: 48, color: AppColors.textTertiary)),
    );
  }
}

class _FileInfoCard extends StatelessWidget {
  final AssignmentAttachment attachment;

  const _FileInfoCard({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
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
          _InfoIcon(kind: attachment.kind),
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _metaLine(attachment),
                  style: AppTextStyles.outfit(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _metaLine(AssignmentAttachment a) {
    final parts = <String>[_kindLabel(a.kind), a.sizeLabel];
    if (a.durationLabel != null) parts.add(a.durationLabel!);
    return parts.join(' · ');
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

class _InfoIcon extends StatelessWidget {
  final AssignmentAttachmentKind kind;

  const _InfoIcon({required this.kind});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final IconData icon;
    switch (kind) {
      case AssignmentAttachmentKind.document:
        bg = AppColors.successBg;
        fg = AppColors.successGreen;
        icon = Icons.description_rounded;
        break;
      case AssignmentAttachmentKind.image:
        bg = AppColors.primaryBrandLight;
        fg = AppColors.orangeTag;
        icon = Icons.image_rounded;
        break;
      case AssignmentAttachmentKind.video:
        bg = AppColors.primaryBrandLight;
        fg = AppColors.orangeTag;
        icon = Icons.smart_display_rounded;
        break;
      case AssignmentAttachmentKind.audio:
        bg = AppColors.primaryBrandLight;
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

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      label: AppStrings.studentAttachmentDownload,
      icon: Icons.download_rounded,
      isPrimary: true,
      onTap: () {
        Get.find<AttachmentPreviewController>().downloadAttachment();
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPrimary ? AppColors.primaryBrand : AppColors.white;
    final fg = isPrimary ? AppColors.white : AppColors.textPrimary;
    final border = isPrimary
        ? Border.all(color: AppColors.primaryBrand)
        : Border.all(color: AppColors.borderGrey);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: border,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isPrimary) ...[
                Icon(icon, size: 18, color: fg),
                AppSpacing.h8,
              ],
              Text(
                label,
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (isPrimary) ...[
                AppSpacing.h8,
                Icon(icon, size: 18, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
