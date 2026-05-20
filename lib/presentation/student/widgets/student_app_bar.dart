import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

class StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool isRoot;
  final bool hideLeading;
  final bool showDefaultActions;
  final VoidCallback? onBackTap;
  final List<Widget>? actions;

  const StudentAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.isRoot = false,
    this.hideLeading = false,
    this.showDefaultActions = true,
    this.onBackTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: Row(
        children: [
          if (!hideLeading && !isRoot) ...[_buildBackButton(), AppSpacing.h12],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (actions != null)
            ...actions!
          else if (showDefaultActions)
            ..._buildDefaultActions(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return _StudentHeaderIconButton(
      icon: Icons.arrow_back_ios_new_rounded,
      onTap: onBackTap ?? () => Get.back(),
    );
  }

  List<Widget> _buildDefaultActions() {
    return [
      _StudentHeaderIconButton(
        icon: Icons.chat_bubble_outline_rounded,
        onTap: () {
          // TODO: route to student chat screen once it exists.
        },
      ),
      AppSpacing.h8,
      _StudentHeaderIconButton(
        icon: Icons.notifications_none_rounded,
        hasBadge: true,
        onTap: () => Get.toNamed(AppRoutes.studentNotifications),
      ),
    ];
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _StudentHeaderIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;
  final VoidCallback onTap;

  const _StudentHeaderIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.s40,
        height: AppSpacing.s40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.s12),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: Icon(icon, size: 18, color: AppColors.textPrimary)),
            if (hasBadge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.bohoRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
