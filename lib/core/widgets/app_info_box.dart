import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppInfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;
  final double? titleFontSize;
  final double? descFontSize;

  const AppInfoBox({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.color,
    this.titleFontSize,
    this.descFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? AppColors.primaryBrand;

    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.primaryBrandLight,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: themeColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: themeColor, size: AppSpacing.s20),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.outfit(
                    fontSize: titleFontSize ?? 14,
                    fontWeight: FontWeight.w600,
                    color: themeColor,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  description,
                  style: AppTextStyles.outfit(
                    fontSize: descFontSize ?? 12,
                    height: 1.5,
                    color: themeColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
