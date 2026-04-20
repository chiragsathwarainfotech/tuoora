import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isRoot;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;

  const InstituteAppBar({
    super.key,
    required this.title,
    this.isRoot = false,
    this.onBackTap,
    this.onMenuTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.x24.add(
        const EdgeInsets.only(top: AppSpacing.s16, bottom: AppSpacing.s8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                _buildLeadingButton(context),
                AppSpacing.h16,
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.instAccentBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (actions != null) Row(children: actions!),
          if (isRoot && actions == null) _buildDefaultRootActions(),
        ],
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context) {
    return GestureDetector(
      onTap: isRoot
          ? (onMenuTap ?? () => Scaffold.of(context).openDrawer())
          : (onBackTap ?? () => Get.back()),
      child: Container(
        width: AppSpacing.s40,
        height: AppSpacing.s40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Center(
          child: Icon(
            isRoot ? Icons.menu_rounded : Icons.arrow_back_ios_new_rounded,
            color: AppColors.instAccentBlue,
            size: isRoot ? AppSpacing.s22 : AppSpacing.s18,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultRootActions() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.instituteNotifications),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.instAccentBlue,
            size: AppSpacing.s26,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
