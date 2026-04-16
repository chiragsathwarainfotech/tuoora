import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/view/dashboard.dart';
import 'package:fee_easy/presentation/institute/view/students_registry_screen.dart';
import 'package:fee_easy/presentation/institute/view/batches_screen.dart';
import 'package:fee_easy/presentation/institute/view/fees_screen.dart';
import 'package:fee_easy/presentation/institute/view/institute_profile_view_screen.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_drawer.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteMainScreen extends GetView<InstituteController> {
  const InstituteMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const InstituteDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              String title = 'Fee Easy';
              switch (controller.currentIndex) {
                case 0:
                  title = 'Dashboard';
                  break;
                case 1:
                  title = 'Students';
                  break;
                case 2:
                  title = 'Batches';
                  break;
                case 3:
                  title = 'Fees';
                  break;
                case 4:
                  title = 'Profile';
                  break;
              }
              return InstituteAppBar(
                title: title,
                isRoot: true,
              );
            }),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                   InstituteDashboard(showShell: false),
                   StudentsRegistryScreen(showShell: false),
                   BatchesScreen(showShell: false),
                   InstituteFeesScreen(showShell: false),
                   InstituteProfileViewScreen(showShell: false),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => InstituteBottomNav(
          currentIndex: controller.currentIndex,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
