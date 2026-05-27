import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/constants/app_colors.dart';
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
              width: 100,
              height: 100,
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
              style: AppTextStyles.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
            AppSpacing.v8,
            Text(
              'Finance Simplified',
              style: AppTextStyles.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 100),
            const CommonLoading(color: AppColors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
