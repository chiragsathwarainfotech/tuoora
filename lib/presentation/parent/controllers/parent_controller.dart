import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentController extends GetxController {
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
    final route = Get.currentRoute;
    if (route == AppRoutes.parentReports) {
      _currentIndex.value = 1;
    } else if (route == AppRoutes.parentFees) {
      _currentIndex.value = 2;
    } else if (route == AppRoutes.parentAttendance) {
      _currentIndex.value = 3;
    } else if (route == AppRoutes.parentInstitute) {
      _currentIndex.value = 4;
    } else {
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

