import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? body;
  final IconData? icon;

  /// Path to an SVG asset (e.g. [AppImages.icDelete]). Takes precedence
  /// over [icon] when supplied. Renders via [AppActionIcon] so the SVG
  /// adopts [iconColor] and the standard 32 dp dialog-icon size.
  final String? svgAsset;
  final Color iconColor;
  final Color iconBgColor;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final bool showButtons;

  const CommonDialog({
    super.key,
    required this.title,
    this.description,
    this.body,
    this.icon,
    this.svgAsset,
    this.iconColor = AppColors.bohoRed,
    this.iconBgColor = AppColors.errorBg,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
    this.showButtons = true,
  });

  static void show({
    required String title,
    String? description,
    Widget? body,
    IconData? icon,
    String? svgAsset,
    Color iconColor = AppColors.bohoRed,
    Color iconBgColor = AppColors.errorBg,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    Color? confirmButtonColor,
    bool showButtons = true,
  }) {
    Get.dialog(
      CommonDialog(
        title: title,
        description: description,
        body: body,
        icon: icon,
        svgAsset: svgAsset,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmButtonColor: confirmButtonColor,
        showButtons: showButtons,
      ),
    );
  }

  static void showDeleteConfirmation({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
  }) {
    show(
      title: title,
      description: description,
      svgAsset: AppImages.icDelete,
      iconColor: AppColors.primaryBrand,
      iconBgColor: AppColors.primaryBrandLight,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmButtonColor: AppColors.primaryBrand,
      onConfirm: onConfirm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: body != null
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.center,
          children: [
            if (icon != null || svgAsset != null) ...[
              Center(
                child: Container(
                  padding: AppSpacing.all16,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  // SVG asset takes precedence over IconData when both
                  // are provided. The colour filter on AppActionIcon
                  // tints the SVG paths to match [iconColor].
                  child: svgAsset != null
                      ? AppActionIcon(
                          asset: svgAsset!,
                          color: iconColor,
                          size: 32,
                        )
                      : Icon(icon, color: iconColor, size: 32),
                ),
              ),
              AppSpacing.v24,
            ],
            Text(
              title,
              textAlign: body != null ? TextAlign.left : TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            if (description != null) ...[
              AppSpacing.v12,
              Text(
                description!,
                textAlign: body != null ? TextAlign.left : TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
            if (body != null) ...[AppSpacing.v24, body!],
            if (showButtons) ...[
              AppSpacing.v32,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: AppSpacing.y16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        cancelText,
                        style: AppTextStyles.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (body == null) Get.back();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            confirmButtonColor ??
                            (icon != null ? iconColor : AppColors.primaryBrand),
                        padding: AppSpacing.y16,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: AppTextStyles.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
