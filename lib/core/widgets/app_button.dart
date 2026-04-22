import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final double elevation;
  final bool fullWidth;
  final bool isLoading;
  final IconData? icon;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.intenseBlue,
    this.foregroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
    this.borderRadius = 16.0,
    this.elevation = 0,
    this.fullWidth = false,
    this.isLoading = false,
    this.icon,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1)
              : BorderSide.none,
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: foregroundColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.manrope(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ],
            ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
