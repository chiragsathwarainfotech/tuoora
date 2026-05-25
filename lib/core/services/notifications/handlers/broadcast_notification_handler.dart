import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';

/// Handles broadcast / diary-style notification taps:
///   - `announcement`
///   - `event`
///   - `holiday`
///   - `daily_update`
///
/// All four open the student's notifications list screen (`UpdatesScreen`
/// at [AppRoutes.studentNotifications]) — that's the single in-app surface
/// where these informational updates already render with full context
/// (reference_id, image, category), so deep-linking deeper isn't needed.
///
/// Student-only — these notifications target students.
class BroadcastNotificationHandler extends BaseNotificationHandler {
  @override
  String get tag => 'BroadcastNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'STUDENT') {
      log('bail: role=$role (broadcast taps are student-only)');
      return;
    }

    if (Get.currentRoute == AppRoutes.studentNotifications) {
      log('already on notifications screen — nothing to do');
      return;
    }

    log('pushing ${AppRoutes.studentNotifications}');
    Get.toNamed<dynamic>(AppRoutes.studentNotifications);
  }
}
