import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

/// Institute-only banner shown on top of the dashboard based on the cached
/// subscription status:
///   active  -> nothing
///   expired -> "subscription expired" with a Renew action
///   pending -> "renewal request pending review" (message only)
class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Obx(() {
      final subscription = authService.subscription;
      if (subscription == null || subscription.isActive) {
        return const SizedBox.shrink();
      }

      if (subscription.isPending) {
        return _buildBanner(
          icon: Icons.hourglass_top_rounded,
          accent: AppColors.warningAmber,
          background: AppColors.warningBg,
          title: AppStrings.renewalRequestPendingReview,
          message:
              'We have received your payment proof and transaction reference. Our billing team will verify it shortly.',
        );
      }

      // expired (or any non-active, non-pending status)
      return _buildBanner(
        icon: Icons.error_outline_rounded,
        accent: AppColors.errorRed,
        background: AppColors.errorBg,
        title: AppStrings.yourSubscriptionHasBeenExpired,
        message:
            'Primary academic and data management operations are restricted. Renew now to restore full access.',
        action: 'Renew',
        onAction: () => Get.toNamed(AppRoutes.instituteSubscriptionRenew),
      );
    });
  }

  Widget _buildBanner({
    required IconData icon,
    required Color accent,
    required Color background,
    required String title,
    required String message,
    String? action,
    VoidCallback? onAction,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        0,
      ),
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSpacing.all8,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.s8),
            ),
            child: Icon(icon, color: accent, size: AppSpacing.s20),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  message,
                  style: AppTextStyles.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                    height: 1.4,
                  ),
                ),
                if (action != null && onAction != null) ...[
                  AppSpacing.v12,
                  GestureDetector(
                    onTap: onAction,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s10,
                      ),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(AppSpacing.s8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            color: AppColors.white,
                            size: AppSpacing.s16,
                          ),
                          AppSpacing.h8,
                          Text(
                            action,
                            style: AppTextStyles.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
