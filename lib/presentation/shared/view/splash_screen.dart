import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/shared/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBrand,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
                vertical: AppSpacing.s20,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                AppImages.logoWithName,
                height: AppSpacing.s56,
              ),
            ),
            AppSpacing.v24,
            Text(
              AppStrings.tagLine,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.9),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
