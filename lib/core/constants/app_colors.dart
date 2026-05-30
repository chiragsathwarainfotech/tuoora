import 'package:flutter/material.dart';

class AppColors {
  // --- Layout & Backgrounds ---
  /// Scaffold background — transparent on purpose so the global dotted
  /// background painted by [DottedBackground] (wired into GetMaterialApp's
  /// builder) shows through every screen. Use [surfaceBg] when you need the
  /// pale fill colour for cards, tiles, or borders.
  static const Color scaffoldBg = Colors.transparent;
  static const Color surfaceBg = Color(0xFFF8F9FB);
  static const Color white = Colors.white;
  static const Color background = Color(0xFFF5F5F5);
  static const Color primaryBrand = Color(0xFFF97316);
  static const Color fieldLabel = Color(0xFFA1A8B3);
  static const Color fieldBg = Color(0xFFF1F5F9);
  static const Color fieldBorder = Color(0xFFE2E8F0);
  static const Color primaryBrandLight = Color(0xFFFEF4E8);
  static const Color darkSlate = Color(0xFF1E293B);
  static const Color instBrandOrangeLight = Color(0xFFFF8800);
  static const Color brandAppBarColor = Color(0xFF663322);
  static const Color activeTracker = Color(0xFF9b3f00);
  static const Color inActiveTracker = Color(0xFFd9dcde);

  static const Color instBrandOrange = Color(0xFFFF6600);
  static const Color successGreen = Color(0xFF10B981);
  static const Color orangeTag = Color(0xFFC2410C);
  static const Color orangeDue = Color(0xFFD97706);
  static const Color subjectPhysics = Color(0xFF06B6D4);
  static const Color greenLight = Color(0xFF14B8A6);

  // --- Typography ---
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDarkGrey = Color(0xFF374151);

  // --- Dividers & Borders ---
  static const Color borderGrey = Color(0xFFE5E7EB);
  static const Color borderLightGray = Color(0xFFD1D5DB);

  // --- Status & Functional ---
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color bohoRed = Color(0xFFD92D20);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color greenText = Color(0xFF065F46);
  static const Color greenBg = Color(0xFFD1FAE5);
  static const Color darkGreen = Color(0xFF027A48);
  static const Color skyBlueLight = Color(0xFFB9EFFF);
  static const Color navyMuted = Color(0xFF8F9BB3);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFB00020);
  static const Color blueSapphire = Color(0xFF917B6B);
  static const Color paleSilver = Color(0xFFF1F5F9);

  // --- Student App Theme ---
  static const Color studentBrand = Color(0xFF7B2D1A);
  static const Color studentBrandSoft = Color(0xFFFCE9DF);
  static const Color studentTomorrowPillText = Color(0xFF92400E);
  static const Color studentPresentBg = Color(0xFFDCFCE7);
  static const Color studentPresentText = Color(0xFF15803D);
  static const Color studentUpdateIconBg = Color(0xFFDBEAFE);
  static const Color studentUpdateIconColor = Color(0xFF1D4ED8);
  static const Color studentProgressOrange = Color(0xFFE07A2A);
  static const Color studentProgressBlue = Color(0xFF3B82F6);
  static const Color subjectPhysicsSoft = Color(0xFFCFFAFE);
  static const Color attachmentShareButton = Color(0xFF111111);
  static const Color studentTabInactiveBg = Color(0xFFF1EFEC);
  static const Color turquoiseBlue = Color(0xFF5EEAD4);
  static const Color surfieGreen = Color(0xFF0F766E);
}
