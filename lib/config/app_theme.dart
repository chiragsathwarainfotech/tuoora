import 'package:tuoora/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Design system colors (Academic Atelier)
  static const Color primary = Color(0xFF003F87);
  static const Color primaryContainer = Color(0xFF0056B3);
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FC);
  static const Color background = Color(0xFFFFFFFF);
  static const Color onPrimary = AppColors.white;
  static const Color onSurface = Color(0xFF1A1C1E);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      primaryContainer: primaryContainer,
      surface: surface,
      onPrimary: onPrimary,
      onSurface: onSurface,
    ),
    scaffoldBackgroundColor: background,
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.lexend(fontSize: 16, color: onSurface),
      bodyMedium: GoogleFonts.lexend(fontSize: 14, color: onSurface),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

