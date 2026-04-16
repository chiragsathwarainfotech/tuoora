import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  const StudentBottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_rounded,
                  'Home',
                  AppRoutes.studentDashboard,
                ),
                _buildNavItem(
                  1,
                  Icons.calendar_today_rounded,
                  'Attendance',
                  AppRoutes.studentAttendance,
                ),
                _buildNavItem(
                  2,
                  Icons.menu_book_rounded,
                  'Homework',
                  AppRoutes.studentHomework,
                ),
                _buildNavItem(
                  3,
                  Icons.business_rounded,
                  'Institute',
                  AppRoutes.studentInstitute,
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

    final Color activeBgColor = const Color(0xFFB9EFFF);
    final Color itemColor = isSelected
        ? const Color(0xFF003781)
        : const Color(0xFF8F9BB3);

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
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? activeBgColor : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.s20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: itemColor, size: AppSpacing.s22),
                const SizedBox(height: AppSpacing.s4),
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
}
