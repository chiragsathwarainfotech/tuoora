import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';

class InstituteBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  const InstituteBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: SafeArea(
          child: Container(
            height: AppSpacing.s72,
            padding: AppSpacing.x12.add(AppSpacing.y8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.grid_view_rounded, AppStrings.instNavDashboard),
                _buildNavItem(1, Icons.people_alt_outlined, AppStrings.instNavStudents),
                _buildNavItem(2, Icons.groups_outlined, AppStrings.instNavBatches),
                _buildNavItem(3, Icons.account_balance_wallet_outlined, AppStrings.instNavFees),
                _buildNavItem(4, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = isSelected
        ? AppColors.instAccentBlue
        : AppColors.instNavInactive;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleRouteTap(index),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: AppSpacing.x16.add(AppSpacing.y8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.instNavActive : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: itemColor, size: AppSpacing.s22),
                AppSpacing.v4,
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: itemColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRouteTap(int index) {
    if (index == currentIndex) return;

    if (onTap != null) {
      onTap!(index);
      return;
    }

    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.instituteDashboard);
        break;
      case 1:
        Get.offAllNamed(AppRoutes.instituteStudents);
        break;
      case 2:
        Get.offAllNamed(AppRoutes.instituteBatches);
        break;
      case 3:
        Get.offAllNamed(AppRoutes.instituteFees);
        break;
      case 4:
        Get.offAllNamed(AppRoutes.instituteProfile);
        break;
    }
  }
}
