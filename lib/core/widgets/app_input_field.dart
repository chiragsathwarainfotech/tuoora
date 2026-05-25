import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
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
  final AppInputFieldVariant variant;
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
    this.variant = AppInputFieldVariant.standard,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isProfile = variant == AppInputFieldVariant.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: labelFontSize ?? (isProfile ? 12 : 14),
            fontWeight: labelFontWeight ?? FontWeight.w800,
            color: labelColor ?? AppColors.brandAppBarColor,
            letterSpacing: labelLetterSpacing ?? (isProfile ? 0.5 : null),
          ),
        ),
        SizedBox(height: labelSpacing ?? 8.0),
        Container(
          decoration: BoxDecoration(
            color:
                fillColor ??
                (isProfile
                    ? (enabled
                          ? AppColors.background
                          : AppColors.background.withValues(alpha: 0.5))
                    : (enabled
                          ? AppColors.paleSilver
                          : AppColors.paleSilver.withValues(alpha: 0.5))),
            borderRadius: BorderRadius.circular(12),
            border:
                containerBorder ??
                (errorText != null
                    ? Border.all(color: Colors.redAccent, width: 1.5)
                    : isProfile
                    ? Border.all(
                        color: AppColors.borderGrey.withValues(alpha: 0.5),
                      )
                    : null),
          ),
          child: TextFormField(
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
            style:
                textStyle ??
                (isProfile
                    ? AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )
                    : AppTextStyles.lexend(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      )),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  hintStyle ??
                  AppTextStyles.lexend(
                    fontSize: 14,
                    color: AppColors.blueSapphire,
                  ),
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Icon(
                        icon,
                        color:
                            iconColor ??
                            (isProfile
                                ? AppColors.primaryBrand
                                : AppColors.blueSapphire),
                        size: iconSize ?? AppSpacing.s20,
                      ),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: const TextStyle(height: 0, color: Colors.transparent),
              contentPadding:
                  contentPadding ??
                  (isProfile
                      ? const EdgeInsets.symmetric(vertical: AppSpacing.s18)
                      : AppSpacing.all16),
              isDense: isProfile || isDense,
              counterText: '',
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTextStyles.manrope(
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
}
