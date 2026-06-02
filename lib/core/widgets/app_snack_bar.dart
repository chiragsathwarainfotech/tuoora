import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';

/// App-wide snackbar wrappers. Three flavours (success / error / warning)
/// each render with a brand-coloured background, white text, and a
/// matching leading icon — kept consistent so the user reads severity by
/// colour without parsing the text. Anchored to the BOTTOM of the screen
/// (closer to the user's thumb) with a short auto-dismiss so it never
/// blocks reading the underlying screen for long.
class AppSnackBar {
  // Tight durations: long enough to read a short line, short enough to
  // get out of the way fast. Error gets a touch longer since the user
  // usually wants to digest what went wrong.
  static const Duration _successDuration = Duration(milliseconds: 1500);
  static const Duration _warningDuration = Duration(milliseconds: 1500);
  static const Duration _errorDuration = Duration(milliseconds: 2000);

  static void success(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.successGreen,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: AppColors.white,
      ),
      duration: _successDuration,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.bohoRed,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline_rounded, color: AppColors.white),
      duration: _errorDuration,
    );
  }

  static void warning(String message, {String title = 'Warning'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warningAmber,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber_rounded, color: AppColors.white),
      duration: _warningDuration,
    );
  }
}
