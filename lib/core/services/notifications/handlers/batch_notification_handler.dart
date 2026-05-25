import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';
import 'package:tuoora/presentation/student/controllers/student_controller.dart';

/// Handles both `batch_assignment` and `batch_removal` taps. Student-only.
///
/// Expected payload (same shape for both):
/// ```
/// { "type": "batch_assignment" | "batch_removal", "batch_id": "3" }
/// ```
///
/// Both notification types land the student on the Assignments tab inside
/// the bottom-nav `StudentMainScreen` — the user almost certainly wants
/// to verify what work is (or no longer is) pinned to their batch.
///
/// Strategy mirrors [AttendanceNotificationHandler]: flip the tab via
/// [StudentController.changePage] when the controller is alive (the
/// normal case once the user has reached the main shell), and fall back
/// to `Get.toNamed` if not.
class BatchNotificationHandler extends BaseNotificationHandler {
  /// Assignments lives at index 1 in [StudentMainScreen]'s PageView:
  /// Dashboard(0) · Assignments(1) · Fees(2) · Attendance(3) · Profile(4).
  static const int _assignmentsTabIndex = 1;

  @override
  String get tag => 'BatchNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'STUDENT') {
      log('bail: role=$role (batch taps are student-only)');
      return;
    }

    if (Get.isRegistered<StudentController>()) {
      log(
        'switching bottom-nav to assignments tab (index=$_assignmentsTabIndex)',
      );
      Get.find<StudentController>().changePage(_assignmentsTabIndex);
      return;
    }

    log('pushing ${AppRoutes.studentHomework} (no StudentController)');
    Get.toNamed<dynamic>(AppRoutes.studentHomework);
  }
}
