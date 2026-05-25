/// Typed wrapper around the raw `data` map that arrives with every FCM
/// `RemoteMessage`. Centralises the "always treat values as strings"
/// quirk of FCM data payloads (everything is a string over the wire even
/// if the backend sent an int).
class NotificationPayload {
  /// Discriminator that tells the router which handler to dispatch to.
  /// Sourced from `data.type` — empty when the field is missing.
  final String type;

  /// Original `RemoteMessage.data` map. Handlers reach in for type-specific
  /// fields via [get].
  final Map<String, dynamic> data;

  const NotificationPayload({required this.type, required this.data});

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      type: map['type']?.toString() ?? '',
      data: map,
    );
  }

  /// Reads [key] as a string. Returns `null` when missing or empty —
  /// callers should treat both as "field not provided".
  String? get(String key) {
    final v = data[key];
    if (v == null) return null;
    final s = v.toString();
    return s.isEmpty ? null : s;
  }

  @override
  String toString() => 'NotificationPayload(type: $type, data: $data)';
}
