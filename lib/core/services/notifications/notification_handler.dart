import 'package:tuoora/core/services/notifications/notification_payload.dart';

/// Contract for per-type notification handlers. Implementations should be
/// idempotent and tolerate being called when the app isn't yet ready to
/// navigate (terminated → cold-start case) — typically by awaiting an
/// "app ready" signal before pushing a route.
abstract class NotificationHandler {
  Future<void> handle(NotificationPayload payload);
}
