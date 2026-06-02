import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class InstituteBottomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? backgroundColor;

  final bool isLoading;

  const InstituteBottomButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // SafeArea so the button never sits under the system navigation bar on
    // devices that show one. Top inset is disabled because this button is
    // always rendered at the bottom of a Scaffold body / bottomNavigationBar.
    return SafeArea(
      top: false,
      child: Container(
        padding: AppSpacing.all16,
        child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryBrand,
          disabledBackgroundColor:
              backgroundColor?.withValues(alpha: 0.6) ??
              AppColors.primaryBrand.withValues(alpha: 0.6),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.white, size: 20),
                    AppSpacing.h12,
                  ],
                  Text(
                    label,
                    style: AppTextStyles.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
