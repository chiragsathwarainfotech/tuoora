import 'package:tuoora/core/widgets/parent_bottom_nav.dart';
import 'package:tuoora/presentation/parent/controllers/parent_controller.dart';
import 'package:tuoora/presentation/parent/view/dashboard.dart';
import 'package:tuoora/presentation/parent/view/fees_screen.dart';
import 'package:tuoora/presentation/parent/view/reports_screen.dart';
import 'package:tuoora/presentation/shared/view/attendance_screen.dart' as shared;
import 'package:tuoora/presentation/shared/view/institute_screen.dart' as shared;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentMainScreen extends GetView<ParentController> {
  const ParentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe to avoid conflict with child scrolls
        children: const [
          ParentDashboard(showBottomNav: false),
          ReportsScreen(showBottomNav: false),
          ParentFeesScreen(showBottomNav: false),
          shared.AttendanceScreen(showBottomNav: false),
          shared.InstituteScreen(showBottomNav: false),
        ],
      ),
      bottomNavigationBar: Obx(
        () => ParentBottomNav(
          currentIndex: controller.currentIndex,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}

