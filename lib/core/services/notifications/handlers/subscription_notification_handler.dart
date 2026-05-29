import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';

/// Handles `data.type == "subscription_alert"` taps — fired when an admin
/// approves an institute's subscription renewal.
///
/// Institute-only: opens the subscription screen so the institute can see the
/// reactivated plan.
class SubscriptionNotificationHandler extends BaseNotificationHandler {
  @override
  String get tag => 'SubscriptionNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'INSTITUTE') {
      log('bail: role=$role (subscription alerts are institute-only)');
      return;
    }

    if (Get.currentRoute == AppRoutes.instituteSubscription) {
      log('already on subscription screen — nothing to do');
      return;
    }

    log('pushing ${AppRoutes.instituteSubscription}');
    // Never await Get.toNamed — its future resolves on pop, not push.
    Get.toNamed<dynamic>(AppRoutes.instituteSubscription);
  }
}
