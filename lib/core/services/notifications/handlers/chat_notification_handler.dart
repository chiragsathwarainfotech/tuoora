import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/services/notifications/base_notification_handler.dart';
import 'package:tuoora/core/services/notifications/notification_payload.dart';
import 'package:tuoora/data/models/chat_model.dart';
import 'package:tuoora/presentation/institute/controllers/chat_controller.dart';

/// Handles `data.type == "chat"` taps.
///
/// Expected payload:
/// ```
/// {
///   "type": "chat",
///   "chat_id": "<backend chat id>",
///   "sender_id": "<other party user id>",
///   "sender_type": "Student" | "StudentParent" | "Staff" | "Institute"
/// }
/// ```
class ChatNotificationHandler extends BaseNotificationHandler {
  @override
  String get tag => 'ChatNotificationHandler';

  @override
  Future<void> onReady(NotificationPayload payload, String role) async {
    final senderId = payload.get('sender_id');
    final senderType = payload.get('sender_type');
    if (senderId == null || senderType == null) {
      log('bail: missing sender_id/sender_type');
      return;
    }

    final targetRoute = role == 'STUDENT'
        ? AppRoutes.studentChat
        : AppRoutes.instituteChatMessages;

    if (Get.currentRoute == targetRoute) {
      log('already on $targetRoute — nothing to do');
      return;
    }

    // Pre-seed selectedChat so the messages screen header shows the right
    // participant immediately. Skipped silently if controller isn't ready.
    _preseedSelectedChat(senderId: senderId, senderType: senderType);

    log('pushing $targetRoute (current=${Get.currentRoute})');
    // Fire-and-forget — never await Get.toNamed (its future resolves on
    // pop, not push). Never use offNamed to retry — it replaces the
    // dashboard underneath and breaks back navigation.
    Get.toNamed<dynamic>(targetRoute);
  }

  void _preseedSelectedChat({
    required String senderId,
    required String senderType,
  }) {
    if (!Get.isRegistered<ChatController>()) {
      log('pre-seed skipped — ChatController not registered yet');
      return;
    }
    try {
      final controller = Get.find<ChatController>();
      final composedId = '${senderType}_$senderId';
      final existing = controller.chatsList.firstWhereOrNull(
        (c) => c.id == composedId,
      );
      controller.selectedChat.value = existing ??
          Chat(
            id: composedId,
            participantName: 'Chat',
            participantId: senderId,
            lastMessage: '',
            lastMessageTime: '',
            participantRole: senderType,
          );
      controller.messages.clear();
      log('pre-seeded selectedChat id=$composedId');
    } catch (e) {
      log('pre-seed failed: $e');
    }
  }
}
