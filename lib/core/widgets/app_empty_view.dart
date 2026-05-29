import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

/// App-wide empty / no-data placeholder. Deliberately minimal — a normal
/// sized simple icon, a title, and an optional one-line description — so
/// every "nothing here yet" state looks consistent across the app.
///
/// Callers pass an icon + title that fit the context (e.g. no students, no
/// batches, no notifications). Keep icons simple Material icons.
class AppEmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;

  const AppEmptyView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.all24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: AppColors.primaryBrand),
            AppSpacing.v16,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              AppSpacing.v8,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
