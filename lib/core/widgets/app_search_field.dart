import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/input_styles.dart';
import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final double borderRadius;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final Color? borderColor;

  const AppSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.onClear,
    this.borderRadius = InputStyles.borderRadius,
    this.backgroundColor = AppColors.fieldBg,
    this.iconColor = AppColors.fieldLabel,
    this.iconSize = AppSpacing.s24,
    this.contentPadding = InputStyles.contentPadding,
    this.hintStyle,
    this.textStyle,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? AppColors.fieldBorder),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style:
            textStyle ??
            AppTextStyles.outfit(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintStyle ?? AppTextStyles.outfit(fontSize: 14, color: iconColor),
          prefixIcon: Icon(Icons.search, color: iconColor, size: iconSize),
          suffixIcon: onClear != null
              ? IconButton(
                  icon: Icon(Icons.clear, color: iconColor, size: 20),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
