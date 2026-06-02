import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/input_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final Color? labelColor;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final double? labelLetterSpacing;
  final Color? fillColor;
  final Color? iconColor;
  final double? iconSize;
  final double? labelSpacing;
  final InputBorder? border;
  final BoxBorder? containerBorder;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool isDense;
  final String? errorText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const AppInputField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.labelColor,
    this.labelFontSize,
    this.labelFontWeight,
    this.labelLetterSpacing,
    this.fillColor,
    this.iconColor,
    this.iconSize,
    this.labelSpacing,
    this.border,
    this.containerBorder,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.isDense = false,
    this.errorText,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: labelFontSize ?? 14,
            fontWeight: labelFontWeight ?? FontWeight.w800,
            color: labelColor ?? AppColors.fieldLabel,
            letterSpacing: labelLetterSpacing,
          ),
        ),
        SizedBox(height: labelSpacing ?? 8.0),
        _buildField(),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildField() {
    final Color bgColor =
        fillColor ??
        (enabled
            ? AppColors.fieldBg
            : AppColors.fieldBg.withValues(alpha: 0.5));
    final BoxBorder effectiveBorder =
        containerBorder ??
        (errorText != null
            ? Border.all(color: Colors.redAccent, width: 1.5)
            : Border.all(color: AppColors.fieldBorder));
    final TextStyle effectiveTextStyle =
        textStyle ??
        AppTextStyles.outfit(
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        );
    final EdgeInsetsGeometry effectiveContentPadding =
        contentPadding ?? InputStyles.contentPadding;

    final Widget textField = TextFormField(
      controller: controller,
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
      maxLines: maxLines,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      textAlignVertical: maxLines == 1 ? TextAlignVertical.center : null,
      style: effectiveTextStyle,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            hintStyle ??
            AppTextStyles.outfit(fontSize: 14, color: AppColors.fieldLabel),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: const TextStyle(height: 0, color: Colors.transparent),
        isCollapsed: icon != null,
        contentPadding: icon != null
            ? EdgeInsets.symmetric(
                vertical: (effectiveContentPadding.vertical / 2)
                    .clamp(0, 32)
                    .toDouble(),
              )
            : effectiveContentPadding,
        isDense: isDense,
        counterText: '',
      ),
    );

    final EdgeInsets paddingInsets = effectiveContentPadding.resolve(
      TextDirection.ltr,
    );

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(InputStyles.borderRadius),
        border: effectiveBorder,
      ),
      child: icon != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingInsets.left),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? AppColors.fieldLabel,
                    size: iconSize ?? AppSpacing.s20,
                  ),
                  SizedBox(width: paddingInsets.left),
                  Expanded(child: textField),
                ],
              ),
            )
          : textField,
    );
  }
}
