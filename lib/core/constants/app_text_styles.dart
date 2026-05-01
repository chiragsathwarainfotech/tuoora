import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fee_easy/core/constants/app_colors.dart';

class AppTextStyles {
  // ============================================
  // BASE WRAPPERS (To replace direct GoogleFonts calls)
  // ============================================
  static TextStyle manrope({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.manrope(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle lexend({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.lexend(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontStyle: fontStyle,
    );
  }

  // ============================================
  // PREDESIGNED SEMANTIC STYLES
  // Use these to eliminate redundant size/weight mappings globally!
  // ============================================

  // Headers (H1, H2, etc.)
  static TextStyle get h1 => manrope(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle get h2 => manrope(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle get h3 => manrope(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle get h4 => manrope(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Overlines (Small spaced headers like 'PARENT DASHBOARD')
  static TextStyle get overlineLabel => manrope(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: AppColors.primaryBrand,
  );

  static TextStyle get overlineMuted => manrope(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
    color: AppColors.textSecondary,
  );

  // Body Texts
  static TextStyle get bodyMuted => lexend(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    height: 1.5,
  );

  static TextStyle get bodySmall => lexend(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Special UI elements
  static TextStyle get largeAmount => manrope(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.0,
  );

  static TextStyle get tinyBadge => manrope(
    fontSize: 8,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.textTertiary,
  );

  // ============================================
  // LEGACY THEME STYLES (Merged from core/theme/)
  // ============================================
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
