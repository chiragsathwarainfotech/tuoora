import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String profileRoute;
  final String notificationsRoute;
  final String? avatarUrl;
  final Widget? notificationIcon;

  const PortalAppBar({
    super.key,
    required this.title,
    required this.profileRoute,
    required this.notificationsRoute,
    this.avatarUrl,
    this.notificationIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(profileRoute),
            child: CircleAvatar(
              radius: AppSpacing.s18,
              backgroundImage: NetworkImage(
                avatarUrl ?? 'https://i.pravatar.cc/150?img=11',
              ),
            ),
          ),
          AppSpacing.h12,
          Text(
            title,
            style: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(notificationsRoute),
          icon:
              notificationIcon ??
              const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.brandAppBarColor,
                size: AppSpacing.s26,
              ),
        ),
        AppSpacing.h8,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

