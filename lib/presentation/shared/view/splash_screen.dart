import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/shared/controllers/splash_controller.dart';

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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.school_rounded,
                  color: AppColors.primaryBrand,
                  size: 60,
                ),
              ),
            ),
            AppSpacing.v24,
            Text(
              AppStrings.appName,
              style: AppTextStyles.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            AppSpacing.v8,
            Text(
              'Finance Simplified',
              style: AppTextStyles.lexend(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 100),
            const CommonLoading(color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
