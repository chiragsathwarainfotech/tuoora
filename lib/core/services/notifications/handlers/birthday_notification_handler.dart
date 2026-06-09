import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';
import 'package:tuoora/presentation/student/widgets/birthday_wish_dialog.dart';

class BirthdayNotificationHandler extends BaseNotificationHandler {
  @override
  String get tag => 'BirthdayNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'STUDENT') {
      log('bail: role=$role (birthday taps are student-only)');
      return;
    }

    if (Get.currentRoute != AppRoutes.studentDashboard) {
      log('navigating to dashboard (current=${Get.currentRoute})');
      Get.offAllNamed<dynamic>(AppRoutes.studentDashboard);
      // Let the dashboard route settle before overlaying the dialog.
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final name = _studentFirstName();
    final message = payload.get('message') ?? payload.get('body');
    log('showing birthday dialog for "$name"');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BirthdayWishDialog.show(name: name, message: message);
    });
  }

  String _studentFirstName() {
    if (!Get.isRegistered<AuthService>()) return '';
    final raw = Get.find<AuthService>().currentUser?.name ?? '';
    return raw.trim().split(' ').first;
  }
}
