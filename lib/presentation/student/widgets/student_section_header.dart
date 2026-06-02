import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

class StudentSectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Color? actionColor;

  const StudentSectionHeader({
    super.key,
    required this.title,
    this.showSeeAll = false,
    this.actionLabel,
    this.onActionTap,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final label = actionLabel ?? (showSeeAll ? 'See all' : null);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
            letterSpacing: 1.2,
          ),
        ),
        if (label != null)
          GestureDetector(
            onTap: onActionTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: actionColor ?? AppColors.orangeTag,
              ),
            ),
          ),
      ],
    );
  }
}
