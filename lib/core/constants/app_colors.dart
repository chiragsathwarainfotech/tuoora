import 'package:flutter/material.dart';

class AppColors {
  // --- Layout & Backgrounds ---
  static const Color scaffoldBg = Color(0xFFF8F9FB);
  static const Color loginBg = Color(0xFFF8F9FD);
  static const Color cardBg = Colors.white;
  static const Color inputBg = Color(0xFFF4F5F7);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // --- Brand & Primary Colors ---
  static const Color primaryBrand = Color(0xFFB45309);
  static const Color primaryBrandLight = Color(0xFFFEF4E8);
  static const Color darkSlate = Color(0xFF1E293B);

  // --- Typography ---
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDarkGrey = Color(0xFF374151);

  // --- Dividers & Borders ---
  static const Color divider = Color(0xFFF3F4F6);
  static const Color borderGrey = Color(0xFFE5E7EB);
  static const Color borderLightGray = Color(0xFFD1D5DB);
  static const Color reportBorder = Color(0xFFF1F5F9);

  // --- Status & Functional ---
  static const Color successGreen = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color redDot = Color(0xFF991B1B);
  static const Color greenText = Color(0xFF065F46);
  static const Color greenBg = Color(0xFFD1FAE5);
  static const Color darkGreen = Color(0xFF027A48);
  static const Color skyBlueLight = Color(0xFFB9EFFF);
  static const Color navyMuted = Color(0xFF8F9BB3);

  // --- Specific Module Highlights ---
  static const Color lightBlueBg = primaryBrandLight;
  static const Color orangeTag = Color(0xFFC2410C);
  static const Color orangeDue = Color(0xFFD97706);
  static const Color amberDark = Color(0xFFB45309);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color indigoDark = primaryBrand;
  static const Color brandLightBg = primaryBrandLight;

  // --- Semantic Aliases (Legacy/Compatibility) ---
  static const Color instPrimaryBlue = primaryBrand;
  static const Color instAccentBlue = primaryBrand;
  static const Color instSendBtnBlue = primaryBrand;
  static const Color instDarkBtnBlue = primaryBrand;
  static const Color instLightBlueBg = brandLightBg;

  static const Color instStatusOpenBg = successBg;
  static const Color instStatusOpenText = greenText;
  static const Color instBorderOpen = successGreen;

  static const Color instStatusHighCapacityBg = amberLight;
  static const Color instBorderHighCapacity = warningAmber;

  static const Color instStatusFullBg = errorBg;
  static const Color instBorderFull = errorRed;

  static const Color instFeesPaidBadgeBg = successBg;
  static const Color instFeesPaidText = greenText;
  static const Color instFeesDueBadgeBg = warningBg;
  static const Color instFeesDueText = amberDark;

  static const Color instFeesAvatarBg = brandLightBg;
  static const Color instBatchTagBg = brandLightBg;
  static const Color instBatchTagText = primaryBrand;

  static const Color inputSolidGrey = borderGrey;
  static const Color instFeesCollectedBg = successBg;
  static const Color instProfileTagBlueBg = brandLightBg;
  static const Color instNavActive = primaryBrand;
  static const Color instNavInactive = textMuted;
  static const Color iconBgLightBlue = brandLightBg;

  static const Color reportScaffoldBg = scaffoldBg;
  static const Color reportProgressBg = reportBorder;
  static const Color darkRedText = redDot;
  static const Color checkGreen = successGreen;
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Colors.white;
  static const Color brandAppBarColor = Color(0xFF663322);

  // --- Dashboard ---
  static const Color instDashboardIconBg = Color(0xFFFEF4E8);
  static const Color instDashboardIcon = Color(0xFFB45309);
  static const Color instBrandOrange = Color(0xFFFF6600);
  static const Color instBrandOrangeLight = Color(0xFFFF8800);
}
