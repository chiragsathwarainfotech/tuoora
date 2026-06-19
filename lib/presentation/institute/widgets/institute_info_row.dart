import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class InstituteInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const InstituteInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1.5, color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppColors.fieldLabel, size: 20),
          AppSpacing.h16,
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
