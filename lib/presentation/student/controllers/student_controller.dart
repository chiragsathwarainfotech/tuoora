import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';

class StudentController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    _setInitialIndex();
    pageController = PageController(initialPage: _currentIndex.value);
  }

  void _setInitialIndex() {
    switch (Get.currentRoute) {
      case AppRoutes.studentHomework:
        _currentIndex.value = 1;
        break;
      case AppRoutes.studentFeeHistory:
        _currentIndex.value = 2;
        break;
      case AppRoutes.studentAttendance:
        _currentIndex.value = 3;
        break;
      case AppRoutes.studentSettings:
        _currentIndex.value = 4;
        break;
      default:
        _currentIndex.value = 0;
    }
  }

  void changePage(int index) {
    _currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setIndex(int index) {
    _currentIndex.value = index;
    if (pageController.hasClients) {
      pageController.jumpToPage(index);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
