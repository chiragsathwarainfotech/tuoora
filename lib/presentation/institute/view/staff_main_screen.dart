import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/view/staff_list_screen.dart';
import 'package:fee_easy/presentation/institute/view/attendance_history_screen.dart';
import 'package:fee_easy/presentation/institute/view/salary_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffMainScreen extends GetView<StaffController> {
  const StaffMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Obx(() {
        switch (controller.currentTabIndex.value) {
          case 0:
            return const StaffListScreen();
          case 1:
            return const AttendanceHistoryScreen();
          case 2:
            return const SalaryManagementScreen();
          default:
            return const StaffListScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentTabIndex.value,
            onTap: controller.changeTab,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primaryBrand,
            unselectedItemColor: AppColors.textTertiary,
            selectedLabelStyle: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people_alt_rounded),
                ),
                label: 'Staff',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_month_rounded),
                ),
                label: 'Attendance',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.payments_rounded),
                ),
                label: 'Salary',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
