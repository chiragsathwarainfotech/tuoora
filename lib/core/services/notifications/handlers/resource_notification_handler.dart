import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';

/// Handles `data.type == "resource"` taps. Student-only.
///
/// Expected payload:
/// ```
/// {
///   "type": "resource",
///   "resource_id": "42",
///   "batch_id": "2",
///   "file_type": "document"
/// }
/// ```
///
/// Opens the study-material list screen. We don't deep-link directly into
/// the specific resource detail here — the list shows the freshly-added
/// item at the top with full context (title, file type, size, download
/// button), which is the right landing for a "new resource" tap. If we
/// later need per-resource deep links, switch to
/// `Get.toNamed(AppRoutes.studentStudyMaterialDetail, arguments: ...)`
/// after fetching the resource by id.
class ResourceNotificationHandler extends BaseNotificationHandler {
  @override
  String get tag => 'ResourceNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'STUDENT') {
      log('bail: role=$role (resource taps are student-only)');
      return;
    }

    if (Get.currentRoute == AppRoutes.studentStudyMaterial) {
      log('already on study-material screen — nothing to do');
      return;
    }

    log('pushing ${AppRoutes.studentStudyMaterial}');
    Get.toNamed<dynamic>(AppRoutes.studentStudyMaterial);
  }
}
