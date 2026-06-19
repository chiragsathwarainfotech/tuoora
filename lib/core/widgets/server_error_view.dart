import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';

class ServerErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const ServerErrorView({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.all24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBrandLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    size: 72,
                    color: AppColors.primaryBrand,
                  ),
                ),
                AppSpacing.v32,
                Text(
                  'Server Connection Issue',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v12,
                Text(
                  message ??
                      "We're having trouble reaching our servers right now. This is usually temporary — please try again in a moment.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.v32,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Try Again',
                    icon: Icons.refresh_rounded,
                    onPressed: onRetry,
                  ),
                ),
                AppSpacing.v16,
                Text(
                  'If the problem persists, contact support@tuoora.com',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
