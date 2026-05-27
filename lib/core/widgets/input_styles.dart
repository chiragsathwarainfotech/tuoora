import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

/// Shared text-input design tokens + decoration factory.
///
/// Use this when you have a raw [TextField] / [TextFormField] in an
/// institute screen that can't easily be migrated to one of the
/// pre-built widgets (`AppInputField`, `AppSearchField`, etc.) — drop in
/// `decoration: InputStyles.filled(hintText: ...)` and the field
/// automatically picks up the design-system look: 4 dp corner radius,
/// tight 4 dp vertical / 12 dp horizontal padding, Outfit hint text,
/// pale-silver fill, no border.
///
/// The pre-built widgets above also read from [borderRadius] /
/// [contentPadding] so changing the spec in one place updates every
/// caller.
class InputStyles {
  InputStyles._();

  /// Institute design-system corner radius for text fields (4 dp).
  static const double borderRadius = 4;

  /// Institute design-system internal padding. The design-spec asked for
  /// 4 dp internal padding, but with prefix-icon decoration Material
  /// gives the icon a 48 dp tap target which makes the field tall — at
  /// 4 dp vertical padding the hint then floats to the top of that tall
  /// container regardless of `textAlignVertical`. 12 dp vertical gives
  /// the field a natural ~44 dp height where the icon, hint, and typed
  /// text all sit on the same baseline. Horizontal stays 12 dp so the
  /// caret/text doesn't kiss the rounded corners.
  static const EdgeInsetsGeometry contentPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  );

  /// Default Outfit text style used inside fields built from [filled].
  static TextStyle textStyle() => AppTextStyles.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  /// Default Outfit hint style.
  static TextStyle hintStyle() => AppTextStyles.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.blueSapphire,
      );

  /// Drop-in [InputDecoration] for any raw [TextField] / [TextFormField].
  /// All parameters are optional — passing none gives the canonical
  /// institute look (filled silver pill with no border).
  static InputDecoration filled({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
    String? errorText,
    bool isDense = false,
  }) {
    final OutlineInputBorder noBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    );
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    );
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: hintStyle(),
      filled: true,
      fillColor: fillColor ?? AppColors.paleSilver,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: contentPadding,
      isDense: isDense,
      errorText: errorText,
      border: noBorder,
      enabledBorder: noBorder,
      disabledBorder: noBorder,
      focusedBorder: noBorder,
      errorBorder: errorText == null ? noBorder : errorBorder,
      focusedErrorBorder: errorBorder,
    );
  }
}
