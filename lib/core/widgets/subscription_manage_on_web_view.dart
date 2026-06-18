import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/utils/url_launcher_utils.dart';
import 'package:tuoora/core/widgets/app_button.dart';

class SubscriptionManageOnWebView extends StatelessWidget {
  const SubscriptionManageOnWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.all24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.open_in_browser_rounded,
                  size: 60,
                  color: AppColors.primaryBrand,
                ),
              ),
              AppSpacing.v24,
              Text(
                AppStrings.subscriptionManageOnWebTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v12,
              Text(
                AppStrings.subscriptionManageOnWebMessage,
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
                  label: AppStrings.subscriptionOpenWebButton,
                  icon: Icons.open_in_new_rounded,
                  onPressed: () => UrlLauncherUtils.openExternal(
                    AppStrings.urlInstituteSubscription,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
