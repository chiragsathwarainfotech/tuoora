import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class HomeworkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subject;
  final String dueDate;
  final String? status;
  final VoidCallback? onTap;

  const HomeworkTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.s20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.s44,
              height: AppSpacing.s44,
              decoration: BoxDecoration(
                color: AppColors.reportBorder,
                borderRadius: BorderRadius.circular(AppSpacing.s12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryBrand,
                size: AppSpacing.s20,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    subject,
                    style: AppTextStyles.lexend(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dueDate,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (status != null) ...[
                  AppSpacing.v4,
                  Text(
                    status!,
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
