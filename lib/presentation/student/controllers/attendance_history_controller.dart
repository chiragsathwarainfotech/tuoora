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

  String get profileRoute => AppRoutes.studentSettings;

  String get updatesRoute => AppRoutes.studentNotifications;

  String get currentMonthName => months[viewDate.value.month - 1];
  String get currentYear => viewDate.value.year.toString();

  void goToToday() {
    final now = DateTime.now();
    viewDate.value = DateTime(now.year, now.month);
  }

  // Returns dummy stats for the currently viewed month.
  // In a real app, this would calculate based on actual attendance records.
  Map<String, int> get currentMonthStats {
    final now = DateTime.now();
    final isCurrentMonth = viewDate.value.year == now.year && viewDate.value.month == now.month;
    
    int daysInMonth = DateTime(viewDate.value.year, viewDate.value.month + 1, 0).day;
    int present = 0;
    int absent = 0;
    int holiday = 0;
    
    // Simulate data to match the UI mock
    for (int day = 1; day <= daysInMonth; day++) {
      int currentWeekday = DateTime(viewDate.value.year, viewDate.value.month, day).weekday;
      
      if (currentWeekday == 6 || currentWeekday == 7) {
        // weekends (skip or count as no class)
      } else if (isCurrentMonth) {
        if (day > now.day) {
          // future
        } else {
          if (day % 7 == 0) absent++;
          else if (day % 13 == 0) holiday++;
          else present++;
        }
      } else if (viewDate.value.isAfter(now)) {
        // entirely in the future
      } else {
        if (day % 8 == 0) absent++;
        else if (day % 15 == 0) holiday++;
        else present++;
      }
    }
    
    // Hardcode for April to match screenshot if needed, but dynamic is better
    return {
      'present': present,
      'absent': absent,
      'holiday': holiday,
      'total': present + absent + holiday,
    };
  }
}

