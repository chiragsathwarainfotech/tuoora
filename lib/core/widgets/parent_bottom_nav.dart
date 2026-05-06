import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  const ParentBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.s24),
          topRight: Radius.circular(AppSpacing.s24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: AppSpacing.s16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.s24),
          topRight: Radius.circular(AppSpacing.s24),
        ),
        child: SafeArea(
          child: Container(
            height: AppSpacing.s72,
            padding: AppSpacing.x12.add(AppSpacing.y8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.grid_view_rounded,
                  'DASHBOARD',
                  AppRoutes.parentDashboard,
                ),
                _buildNavItem(
                  1,
                  Icons.bar_chart_rounded,
                  'REPORTS',
                  AppRoutes.parentReports,
                ),
                _buildCenterNavItem(
                  2,
                  Icons.account_balance_wallet_outlined,
                  AppRoutes.parentFees,
                ),
                _buildNavItem(
                  3,
                  Icons.calendar_today_outlined,
                  'ATTENDANCE',
                  AppRoutes.parentAttendance,
                ),
                _buildNavItem(
                  4,
                  Icons.business_rounded,
                  'INSTITUTE',
                  AppRoutes.parentInstitute,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, String route) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = isSelected
        ? AppColors.primaryBrand
        : AppColors.navyMuted;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onTap != null) {
            onTap!(index);
          } else if (currentIndex != index) {
            Get.offAllNamed(route);
          }
        },
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
                    fontSize: 8,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                    color: itemColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem(int index, IconData icon, String route) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = isSelected
        ? AppColors.primaryBrand
        : Color(0xFF475569);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!(index);
          } else if (currentIndex != index) {
            Get.offAllNamed(route);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: AppSpacing.all12,
          child: Icon(icon, color: itemColor, size: AppSpacing.s26),
        ),
      ),
    );
  }
}
