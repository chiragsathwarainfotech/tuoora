import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

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
      backgroundColor: Colors.white,
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
            style: AppTextStyles.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(notificationsRoute),
          icon: notificationIcon ??
              const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF111827),
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
