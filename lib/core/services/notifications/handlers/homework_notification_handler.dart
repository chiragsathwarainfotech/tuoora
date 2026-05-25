import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';

/// Handles `data.type == "homework"` taps. Student-only.
///
/// Expected payload:
/// ```
/// { "type": "homework", "homework_id": "24", "batch_id": "5" }
/// ```
///
/// Opens [StudentAssignmentDetailScreen] for the homework. Reuses
/// [AssignmentsController.openAssignmentById] which already navigates to
/// the detail route, shows a spinner via `isDetailLoading`, and hydrates
/// the assignment from `/student/homeworks/{id}`.
class HomeworkNotificationHandler extends BaseNotificationHandler {
  @override
  String get tag => 'HomeworkNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    if (role != 'STUDENT') {
      log('bail: role=$role (homework taps are student-only)');
      return;
    }

    final raw = payload.get('homework_id');
    final id = raw == null ? null : int.tryParse(raw);
    if (id == null) {
      log('bail: missing/invalid homework_id (raw=$raw)');
      return;
    }

    // Avoid double-pushing if the user is already on the detail screen.
    if (Get.currentRoute == AppRoutes.studentAssignmentDetail) {
      log('already on assignment detail — nothing to do');
      return;
    }

    // Ensure controller exists (lazyPut via StudentBinding — instantiate
    // on first find). If the student hasn't visited the Assignments tab
    // yet this session, the binding hasn't fired the factory.
    if (!Get.isRegistered<AssignmentsController>()) {
      log('AssignmentsController not registered — putting on demand');
      Get.put(AssignmentsController());
    }

    log('opening assignment id=$id');
    Get.find<AssignmentsController>().openAssignmentById(id);
  }
}
