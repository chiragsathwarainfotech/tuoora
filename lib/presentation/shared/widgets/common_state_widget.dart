import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';

class CommonStateWidget extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final Widget child;

  const CommonStateWidget({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && isEmpty) {
      return const Center(child: CommonLoading());
    }

    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.all24,
              decoration: const BoxDecoration(
                color: AppColors.primaryBrandLight,
                shape: BoxShape.circle,
              ),
              child: Icon(emptyIcon, size: 64, color: AppColors.primaryBrand),
            ),
            AppSpacing.v24,
            Text(
              emptyTitle,
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.brandAppBarColor,
              ),
            ),
            AppSpacing.v8,
            Padding(
              padding: AppSpacing.x32,
              child: Text(
                emptySubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return child;
  }
}

