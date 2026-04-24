import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/view/dashboard.dart';
import 'package:fee_easy/presentation/institute/view/students_registry_screen.dart';
import 'package:fee_easy/presentation/institute/view/batches_screen.dart';
import 'package:fee_easy/presentation/institute/view/fees_screen.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_nav.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_drawer.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
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
              String title = AppStrings.appName;
              switch (controller.currentIndex) {
                case 0:
                  title = AppStrings.instNavDashboard;
                  break;
                case 1:
                  title = AppStrings.instNavStudents;
                  break;
                case 2:
                  title = AppStrings.instNavBatches;
                  break;
                case 3:
                  title = AppStrings.instFeesTitle;
                  break;
              }
              return InstituteAppBar(title: title, isRoot: true);
            }),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const InstituteDashboard(),
                  const StudentsRegistryScreen(),
                  const BatchesScreen(),
                  const InstituteFeesScreen(),
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
      floatingActionButton: Obx(() {
        if (controller.currentIndex == 1 || controller.currentIndex == 2 || controller.currentIndex == 3) {
          return FloatingActionButton(
            onPressed: () {
              if (controller.currentIndex == 1) {
                Get.toNamed(AppRoutes.instituteAddStudent);
              } else if (controller.currentIndex == 2) {
                Get.find<BatchController>().initAddMode();
                Get.toNamed(AppRoutes.instituteAddBatch);
              } else if (controller.currentIndex == 3) {
                Get.toNamed(AppRoutes.instituteRecordFee);
              }
            },
            backgroundColor: AppColors.instDarkBtnBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: AppSpacing.s28,
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
