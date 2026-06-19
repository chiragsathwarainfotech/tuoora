import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

class BirthdayWishDialog extends StatefulWidget {
  final String studentName;
  final String? message;

  const BirthdayWishDialog({
    super.key,
    required this.studentName,
    this.message,
  });

  static void show({required String name, String? message}) {
    Get.dialog(
      BirthdayWishDialog(studentName: name, message: message),
      barrierDismissible: true,
    );
  }

  @override
  State<BirthdayWishDialog> createState() => _BirthdayWishDialogState();
}

class _BirthdayWishDialogState extends State<BirthdayWishDialog> {
  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    super.initState();
    _controllerTopCenter = ConfettiController(
      duration: const Duration(seconds: 4),
    );
    _controllerTopCenter.play();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cake_rounded,
                    color: AppColors.primaryBrand,
                    size: 72,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Happy Birthday,\n${widget.studentName}!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.message ??
                        'Wishing you a fantastic day filled with joy and success. Have a great year ahead!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrand,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadius,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      'Thank You!',
                      style: AppTextStyles.outfit(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.2,
              colors: const [
                AppColors.primaryBrand,
                AppColors.successGreen,
                AppColors.skyBlueLight,
                Colors.orange,
                Colors.purple,
                Colors.pink,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
