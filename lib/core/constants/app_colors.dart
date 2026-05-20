import 'package:flutter/material.dart';

class AppColors {
  // --- Layout & Backgrounds ---
  static const Color scaffoldBg = Color(0xFFF8F9FB);
  static const Color loginBg = Color(0xFFF8F9FD);
  static const Color white = Colors.white;
  static const Color inputBg = Color(0xFFF4F5F7);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);

  // --- Brand & Primary Colors ---
  static const Color primaryBrand = Color(0xFFB45309);
  static const Color primaryBrandLight = Color(0xFFFEF4E8);
  static const Color darkSlate = Color(0xFF1E293B);
  static const Color instBrandOrange = Color(0xFFFF6600);
  static const Color instBrandOrangeLight = Color(0xFFFF8800);
  static const Color brandAppBarColor = Color(0xFF663322);

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
  static const Color bohoRed = Color(0xFFD92D20);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color greenText = Color(0xFF065F46);
  static const Color greenBg = Color(0xFFD1FAE5);
  static const Color darkGreen = Color(0xFF027A48);
  static const Color skyBlueLight = Color(0xFFB9EFFF);
  static const Color navyMuted = Color(0xFF8F9BB3);
  static const Color orangeTag = Color(0xFFC2410C);
  static const Color orangeDue = Color(0xFFD97706);
  static const Color amberLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFB00020);
  static const Color blueSapphire = Color(0xFF917B6B);
  static const Color paleSilver = Color(0xFFEBEBEB);

  // --- Student App Theme ---
  // Aligned with `scaffoldBg` so student screens feel like part of the
  // same app surface as institute screens. The brand accents below stay
  // warm — only the page background is neutralised.
  static const Color studentBg = Color(0xFFF8F9FB);
  static const Color studentBrand = Color(0xFF7B2D1A);
  static const Color studentBrandSoft = Color(0xFFFCE9DF);
  static const Color studentBrandAccent = Color(0xFFC2410C);
  static const Color studentTodayPillBg = Color(0xFFFCE9DF);
  static const Color studentTodayPillText = Color(0xFF7B2D1A);
  static const Color studentTomorrowPillBg = Color(0xFFFEF3C7);
  static const Color studentTomorrowPillText = Color(0xFF92400E);
  static const Color studentPresentBg = Color(0xFFDCFCE7);
  static const Color studentPresentText = Color(0xFF15803D);
  static const Color studentUpdateIconBg = Color(0xFFDBEAFE);
  static const Color studentUpdateIconColor = Color(0xFF1D4ED8);

  // Student — assignments progress bar (3 colored segments).
  static const Color studentProgressOrange = Color(0xFFE07A2A);
  static const Color studentProgressBlue = Color(0xFF3B82F6);
  static const Color studentProgressGreen = Color(0xFF10B981);

  // Student — subject accents (left stripe + icon container).
  static const Color subjectMath = Color(0xFFE07A2A);
  static const Color subjectMathSoft = Color(0xFFFCE9DF);
  static const Color subjectPhysics = Color(0xFF06B6D4);
  static const Color subjectPhysicsSoft = Color(0xFFCFFAFE);
  static const Color subjectChemistry = Color(0xFF15803D);
  static const Color subjectChemistrySoft = Color(0xFFDCFCE7);

  // Student — "Done" pill on completed assignment cards.
  static const Color studentDonePillBg = Color(0xFFDCFCE7);
  static const Color studentDonePillText = Color(0xFF15803D);
  // Muted text for struck-through completed titles.
  static const Color studentCompletedTitle = Color(0xFF9CA3AF);

  // Student — assignment detail: status banner at the bottom of the page.
  static const Color studentPendingBannerBg = Color(0xFFFEF3C7);
  static const Color studentPendingBannerText = Color(0xFF92400E);
  static const Color studentCompletedBannerBg = Color(0xFFDCFCE7);
  static const Color studentCompletedBannerText = Color(0xFF15803D);

  // Student — attachment file tiles.
  static const Color attachmentDocumentBg = Color(0xFFDCFCE7);
  static const Color attachmentDocumentColor = Color(0xFF15803D);
  static const Color attachmentImageBg = Color(0xFFFCE9DF);
  static const Color attachmentImageColor = Color(0xFFC2410C);

  // Student — attachment preview screen.
  static const Color attachmentPreviewBg = Color(0xFFF5F5F5);
  static const Color attachmentSkeletonBar = Color(0xFFE5E7EB);
  static const Color attachmentVideoSurface = Color(0xFF111111);
  static const Color attachmentShareButton = Color(0xFF111111);

  // Student — fees screen (status dot on statement rows + progress track).
  static const Color feesPaidDot = Color(0xFF15803D);
  static const Color feesPendingDot = Color(0xFFC2410C);
  static const Color feesProgressTrack = Color(0xFFFCE9DF);

  // Student — segmented tab switcher (Pending / Completed).
  static const Color studentTabActiveBg = Color(0xFFFFFFFF);
  static const Color studentTabInactiveBg = Color(0xFFF1EFEC);
  static const Color studentTabInactiveText = Color(0xFF6B7280);
}

