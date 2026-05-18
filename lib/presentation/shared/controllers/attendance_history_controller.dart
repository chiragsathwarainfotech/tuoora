import 'package:tuoora/config/app_routes.dart';
import 'package:get/get.dart';

class AttendanceHistoryController extends GetxController {
  final viewDate = DateTime(2024, 9).obs;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void prevMonth() {
    viewDate.value = DateTime(viewDate.value.year, viewDate.value.month - 1);
  }

  void nextMonth() {
    viewDate.value = DateTime(viewDate.value.year, viewDate.value.month + 1);
  }

  String get profileRoute => Get.currentRoute.contains('/parent')
      ? AppRoutes.parentStudentProfile
      : AppRoutes.studentSettings;

  String get updatesRoute => Get.currentRoute.contains('/parent')
      ? AppRoutes.parentUpdates
      : AppRoutes.studentNotifications;

  bool get isParent => Get.currentRoute.contains('/parent');
  
  String get currentMonthName => months[viewDate.value.month - 1];
  String get currentYear => viewDate.value.year.toString();
}

