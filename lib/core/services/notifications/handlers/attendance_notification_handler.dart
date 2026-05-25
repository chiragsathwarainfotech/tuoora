import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';
import 'package:tuoora/presentation/student/controllers/student_controller.dart';

/// Handles `data.type == "attendance"` taps. Student-only.
///
/// Expected payload:
/// ```
/// { "type": "attendance", "date": "2026-05-25", "status": "present" }
/// ```
///
/// Strategy: the attendance screen lives as tab index 3 inside the bottom-
/// nav `StudentMainScreen`. If [StudentController] is already alive (user
/// is inside the main shell), we just flip to that tab — same pattern the
/// in-app navigation buttons use. Only fall back to `Get.toNamed` when the
/// controller isn't around (very rare in practice).
class AttendanceNotificationHandler extends BaseNotificationHandler {
  static const int _attendanceTabIndex = 3;

  @override
  String get tag => 'AttendanceNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'STUDENT') {
      log('bail: role=$role (attendance taps are student-only)');
      return;
    }

    if (Get.isRegistered<StudentController>()) {
      log('switching bottom-nav to attendance tab (index=$_attendanceTabIndex)');
      Get.find<StudentController>().changePage(_attendanceTabIndex);
      return;
    }

    log('pushing ${AppRoutes.studentAttendance} (no StudentController)');
    Get.toNamed<dynamic>(AppRoutes.studentAttendance);
  }
}
