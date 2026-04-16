import 'package:fee_easy/core/widgets/student_bottom_nav.dart';
import 'package:fee_easy/presentation/student/controllers/student_controller.dart';
import 'package:fee_easy/presentation/student/view/dashboard.dart';
import 'package:fee_easy/presentation/student/view/homework_center.dart';
import 'package:fee_easy/presentation/shared/view/attendance_screen.dart'
    as shared;
import 'package:fee_easy/presentation/shared/view/institute_screen.dart'
    as shared;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentMainScreen extends GetView<StudentController> {
  const StudentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          StudentDashboard(showBottomNav: false),
          shared.AttendanceScreen(showBottomNav: false),
          StudentHomeworkScreen(showBottomNav: false),
          shared.InstituteScreen(showBottomNav: false),
        ],
      ),
      bottomNavigationBar: Obx(
        () => StudentBottomNav(
          currentIndex: controller.currentIndex,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
