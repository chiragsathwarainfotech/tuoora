import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:tuoora/data/models/chat_model.dart';

/// Lightweight ack payload pushed by `MessageReceived` / `MessageRead`.
class MessageAck {
  final String messageId;
  final DateTime? timestamp;

  MessageAck({required this.messageId, this.timestamp});
}

/// Payload pushed by the `ChatDeleted` broadcast event. The synthetic chat
/// id matches what the chat list builder produces (`<type>_<id>`).
class ChatDeleted {
  final String? userId;
  final String? userType;

  ChatDeleted({this.userId, this.userType});

  String? get chatId {
    if (userId == null || userType == null) return null;
    return '${userType}_$userId';
  }
}

/// Single source of truth for the Pusher / laravel-websockets connection
/// settings. Edit this class if the deployment details change.
class ChatSocketConfig {
  ChatSocketConfig._();

  static const String appKey = 'feeeasykey2024';
  static const String host = 'tuoora.com';

  /// laravel-websockets is reverse-proxied through nginx on the standard
  /// HTTPS port — clients connect over `wss://tuoora.com/app/{key}`
  /// (nginx forwards to localhost:6001 internally).
  static const int port = 443;
  static const bool useTLS = true;

  static const String authEndpoint = 'https://tuoora.com/broadcasting/auth';

  static String channelFor(String myType, String myId) {
    return 'private-chat.$myType.$myId';
  }

  /// Pusher protocol URL. The query parameters are required by laravel-
  /// websockets for protocol version negotiation. Omits the port if it's
  /// the default for the scheme so the URL stays clean.
  static Uri buildUri() {
    final scheme = useTLS ? 'wss' : 'ws';
    final isDefaultPort = (useTLS && port == 443) || (!useTLS && port == 80);
    final authority = isDefaultPort ? host : '$host:$port';
    return Uri.parse(
      '$scheme://$authority/app/$appKey'
      '?protocol=7&client=tuoora-flutter&version=1.0.0&flash=false',
    );
  }

  /// Reconnect backoff. Capped exponential, max 30s between attempts.
  static const int maxReconnectAttempts = 10;
  static const Duration baseReconnectDelay = Duration(seconds: 1);
  static const Duration maxReconnectDelay = Duration(seconds: 30);
}

/// Manages the realtime chat socket over a raw WebSocket connection,
/// implementing the Pusher protocol by hand.
///
/// Lifecycle:
///   1. Caller invokes [connect] after login (with token + my id/type).
///   2. We open the WebSocket, await `pusher:connection_established`,
///      then POST to `/broadcasting/auth` and emit `pusher:subscribe`
///      with the returned signature.
///   3. The class keeps the connection alive with `pusher:ping` heartbeats
///      and automatically reconnects (capped exponential backoff) on drop.
///   4. Caller invokes [disconnect] on logout.
class ChatSocketService extends GetxService {
  static ChatSocketService get to => Get.find<ChatSocketService>();

  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  String? _myUserId;
  String? _myUserType;
  String? _authToken;
  String? _socketId;
  int _reconnectAttempts = 0;
  bool _intentionalDisconnect = false;
  Duration _activityTimeout = const Duration(seconds: 120);

  final RxBool _isConnected = false.obs;
  RxBool get isConnected => _isConnected;

  final _onMessageSent = StreamController<Message>.broadcast();
  final _onMessageReceived = StreamController<MessageAck>.broadcast();
  final _onMessageRead = StreamController<MessageAck>.broadcast();
  final _onChatDeleted = StreamController<ChatDeleted>.broadcast();

  Stream<Message> get onMessageSent => _onMessageSent.stream;
  Stream<MessageAck> get onMessageReceived => _onMessageReceived.stream;
  Stream<MessageAck> get onMessageRead => _onMessageRead.stream;
  Stream<ChatDeleted> get onChatDeleted => _onChatDeleted.stream;

  Future<void> connect({
    required String myUserId,
    required String myUserType,
    required String authToken,
  }) async {
    if (myUserId.isEmpty || authToken.isEmpty) {
      _logDebug('connect skipped — missing user id or token');
      return;
    }
    if (_channel != null &&
        _myUserId == myUserId &&
        _myUserType == myUserType) {
      return;
    }
    if (_channel != null) await disconnect();

    _myUserId = myUserId;
    _myUserType = myUserType;
    _authToken = authToken;
    _intentionalDisconnect = false;
    _reconnectAttempts = 0;

    await _openConnection();
  }

  Future<void> disconnect() async {
    _intentionalDisconnect = true;
    _pingTimer?.cancel();
    _pingTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _wsSubscription?.cancel();
    _wsSubscription = null;
    try {
      await _channel?.sink.close(ws_status.normalClosure);
    } catch (e) {
      _logDebug('close error: $e');
    }
    _channel = null;
    _socketId = null;
    _myUserId = null;
    _myUserType = null;
    _authToken = null;
    _isConnected.value = false;
    _reconnectAttempts = 0;
  }

  Future<void> _openConnection() async {
    if (_intentionalDisconnect) return;
    final uri = ChatSocketConfig.buildUri();
    _logDebug('connecting → $uri');
    try {
      final channel = WebSocketChannel.connect(uri);
      _channel = channel;

      // Wait for the WebSocket handshake to actually finish so we can
      // surface connection failures (wrong port, TLS mismatch, firewall)
      // instead of hanging silently waiting for the first frame.
      try {
        await channel.ready.timeout(const Duration(seconds: 10));
        _logDebug('ws handshake done — awaiting pusher:connection_established');
      } on TimeoutException {
        _logDebug(
          '⚠ ws handshake timed out after 10s. The Flutter app could not '
          'open a WebSocket to ${uri.host}:${uri.port}. Common fixes: '
          '(a) if laravel-websockets is behind nginx on port 443, change '
          'port to 443 in ChatSocketConfig; (b) if it runs plain HTTP on '
          '6001 without TLS, set useTLS=false.',
        );
        try {
          await channel.sink.close();
        } catch (_) {}
        _channel = null;
        _scheduleReconnect();
        return;
      } catch (e) {
        _logDebug(
          '⚠ ws handshake failed: $e. Likely TLS/cert mismatch on '
          '${uri.host}:${uri.port}, or the server isn\'t serving '
          'WebSockets at this path.',
        );
        _channel = null;
        _scheduleReconnect();
        return;
      }

      _wsSubscription = channel.stream.listen(
        _onWsMessage,
        onError: _onWsError,
        onDone: _onWsDone,
        cancelOnError: false,
      );
    } catch (e) {
      _logDebug('open failed: $e');
      _scheduleReconnect();
    }
  }

  void _onWsMessage(dynamic raw) {
    if (raw is! String) return;

    // Surface the raw frame for debugging — easiest way to see whether
    // events are arriving at all and what their event/channel names look
    // like on the wire. Truncated to keep logs readable.
    if (kDebugMode) {
      final preview = raw.length > 600 ? '${raw.substring(0, 600)}…' : raw;
      debugPrint('[ChatSocket] ← $preview');
    }

    Map<String, dynamic> envelope;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        _logDebug('unexpected envelope: $raw');
        return;
      }
      envelope = Map<String, dynamic>.from(decoded);
    } catch (e) {
      _logDebug('parse envelope failed: $e — raw=$raw');
      return;
    }

    final event = envelope['event']?.toString();
    final channel = envelope['channel']?.toString();
    final data = envelope['data'];

    if (event == null) return;

    switch (event) {
      case 'pusher:connection_established':
        _onConnectionEstablished(_unwrapData(data));
        break;
      case 'pusher:ping':
        _send({'event': 'pusher:pong', 'data': {}});
        break;
      case 'pusher:pong':
        // server acked our ping — nothing to do
        break;
      case 'pusher:error':
        final err = _unwrapData(data);
        _logDebug(
          '⚠ pusher:error → code=${err?['code']} '
          'message="${err?['message']}". '
          'Common causes: wrong appKey, wrong host/port, TLS mismatch.',
        );
        break;
      case 'pusher:subscription_error':
        _logDebug(
          '⚠ subscription_error on $channel → ${_unwrapData(data)}. '
          'Causes: /broadcasting/auth returned non-200, the auth signature '
          'mismatch (wrong PUSHER_APP_SECRET on Laravel), or '
          'routes/channels.php denies this user.',
        );
        break;
      case 'pusher_internal:subscription_succeeded':
        _logDebug('✓ subscribed to $channel');
        break;
      default:
        _onBroadcastEvent(event, data);
    }
  }

  void _onConnectionEstablished(Map<String, dynamic>? data) {
    _socketId = data?['socket_id']?.toString();
    final timeout = (data?['activity_timeout'] as num?)?.toInt();
    if (timeout != null && timeout > 5) {
      _activityTimeout = Duration(seconds: timeout);
    }
    _isConnected.value = true;
    _reconnectAttempts = 0;
    _logDebug(
      'connection established — socketId=$_socketId '
      'activity_timeout=${_activityTimeout.inSeconds}s',
    );
    _startHeartbeat();
    _subscribePrivate();
  }

  void _startHeartbeat() {
    _pingTimer?.cancel();
    // Send a ping a few seconds before the server's activity timeout fires.
    final interval = Duration(
      seconds: math.max(15, _activityTimeout.inSeconds - 10),
    );
    _pingTimer = Timer.periodic(interval, (_) {
      _send({'event': 'pusher:ping', 'data': {}});
    });
  }

  Future<void> _subscribePrivate() async {
    final myId = _myUserId;
    final myType = _myUserType;
    final socketId = _socketId;
    if (myId == null || myType == null || socketId == null) return;
    final channelName = ChatSocketConfig.channelFor(myType, myId);

    final auth = await _fetchChannelAuth(channelName, socketId);
    if (auth == null) {
      _logDebug('subscribe aborted — auth failed for $channelName');
      return;
    }

    _send({
      'event': 'pusher:subscribe',
      'data': {'channel': channelName, 'auth': auth},
    });
  }

  /// POST `socket_id` + `channel_name` to Laravel's `/broadcasting/auth`
  /// with the user's Bearer token. Returns `key:signature` string.
  Future<String?> _fetchChannelAuth(String channelName, String socketId) async {
    final token = _authToken;
    if (token == null || token.isEmpty) return null;

    final client = io.HttpClient();
    try {
      final request = await client.postUrl(
        Uri.parse(ChatSocketConfig.authEndpoint),
      );
      request.headers.set(io.HttpHeaders.authorizationHeader, 'Bearer $token');
      request.headers.set(io.HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(
        io.HttpHeaders.contentTypeHeader,
        'application/x-www-form-urlencoded',
      );
      request.write(
        'socket_id=${Uri.encodeQueryComponent(socketId)}'
        '&channel_name=${Uri.encodeQueryComponent(channelName)}',
      );
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        _logDebug(
          'auth ${response.statusCode}: $body — check Sanctum middleware '
          'on POST /broadcasting/auth and that routes/channels.php '
          'authorises this user for "$channelName".',
        );
        return null;
      }
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['auth'] is String) {
        return decoded['auth'] as String;
      }
      _logDebug('auth response missing "auth" key: $body');
      return null;
    } catch (e) {
      _logDebug('auth request error: $e');
      return null;
    } finally {
      client.close(force: true);
    }
  }

  static const _sentEvents = [
    'MessageSent',
    '.MessageSent',
    'App\\Events\\MessageSent',
  ];
  static const _receivedEvents = [
    'MessageReceived',
    '.MessageReceived',
    'App\\Events\\MessageReceived',
  ];
  static const _readEvents = [
    'MessageRead',
    '.MessageRead',
    'App\\Events\\MessageRead',
  ];
  static const _chatDeletedEvents = [
    'ChatDeleted',
    '.ChatDeleted',
    'App\\Events\\ChatDeleted',
  ];

  void _onBroadcastEvent(String name, dynamic rawData) {
    final data = _unwrapData(rawData);
    if (data == null) {
      _logDebug('event $name had unparseable payload: $rawData');
      return;
    }
    if (_sentEvents.contains(name)) {
      _logDebug('→ MessageSent dispatched (id=${data['id']})');
      _emitMessageSent(data);
    } else if (_receivedEvents.contains(name)) {
      _logDebug(
        '→ MessageReceived dispatched (id=${data['id'] ?? data['message_id']})',
      );
      _emitAck(_onMessageReceived, data, 'received_at');
    } else if (_readEvents.contains(name)) {
      _logDebug(
        '→ MessageRead dispatched (id=${data['id'] ?? data['message_id']})',
      );
      _emitAck(_onMessageRead, data, 'read_at');
    } else if (_chatDeletedEvents.contains(name)) {
      final userId =
          (data['user_id'] ?? data['deleted_with_id'] ?? data['other_user_id'])
              ?.toString();
      final userType =
          (data['user_type'] ??
                  data['deleted_with_type'] ??
                  data['other_user_type'])
              ?.toString();
      _logDebug('→ ChatDeleted dispatched (user=${userType}_$userId)');
      _onChatDeleted.add(ChatDeleted(userId: userId, userType: userType));
    } else {
      _logDebug(
        'unhandled event: "$name". If this should be MessageSent/'
        'MessageReceived/MessageRead, the backend\'s broadcastAs() name '
        'doesn\'t match the variants we listen for. Add the actual name '
        'to _sentEvents/_receivedEvents/_readEvents.',
      );
    }
  }

  void _emitMessageSent(Map<String, dynamic> json) {
    final myId = _myUserId;
    final myType = _myUserType;
    if (myId == null || myType == null) return;
    try {
      final source = json.containsKey('id')
          ? json
          : (json['message'] is Map
                ? Map<String, dynamic>.from(json['message'] as Map)
                : json);
      final msg = Message.fromJson(source, myUserId: myId, myUserType: myType);
      _onMessageSent.add(msg);
    } catch (e) {
      _logDebug('parse MessageSent failed: $e — payload=$json');
    }
  }

  void _emitAck(
    StreamController<MessageAck> stream,
    Map<String, dynamic> json,
    String tsKey,
  ) {
    final id = (json['id'] ?? json['message_id'])?.toString();
    if (id == null) return;
    final raw = json[tsKey]?.toString();
    stream.add(
      MessageAck(
        messageId: id,
        timestamp: raw == null ? null : DateTime.tryParse(raw)?.toLocal(),
      ),
    );
  }

  /// Pusher wraps event payloads inside a `data` field whose value is a
  /// JSON-encoded string. Sometimes it's already a Map (depending on the
  /// server build). Normalise both.
  Map<String, dynamic>? _unwrapData(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        /* fall through */
      }
    }
    return null;
  }

  // ---------------------------------------------------------- low-level

  void _send(Map<String, dynamic> payload) {
    final c = _channel;
    if (c == null) return;
    try {
      c.sink.add(jsonEncode(payload));
    } catch (e) {
      _logDebug('send error: $e');
    }
  }

  void _onWsError(Object error) {
    _logDebug('ws error: $error');
  }

  void _onWsDone() {
    _logDebug(
      'ws closed (code=${_channel?.closeCode}, reason=${_channel?.closeReason})',
    );
    _isConnected.value = false;
    _pingTimer?.cancel();
    _pingTimer = null;
    _channel = null;
    _wsSubscription = null;
    _socketId = null;
    if (!_intentionalDisconnect) _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_intentionalDisconnect) return;
    _reconnectAttempts++;
    if (_reconnectAttempts > ChatSocketConfig.maxReconnectAttempts) {
      _logDebug('giving up after ${_reconnectAttempts - 1} reconnect attempts');
      return;
    }
    final backoff = math.min(
      ChatSocketConfig.maxReconnectDelay.inMilliseconds,
      ChatSocketConfig.baseReconnectDelay.inMilliseconds *
          (1 << (_reconnectAttempts - 1)),
    );
    final delay = Duration(milliseconds: backoff);
    _logDebug(
      'reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)',
    );
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, _openConnection);
  }

  void _logDebug(String msg) {
    if (kDebugMode) debugPrint('[ChatSocket] $msg');
  }

  @override
  void onClose() {
    disconnect();
    _onMessageSent.close();
    _onMessageReceived.close();
    _onMessageRead.close();
    _onChatDeleted.close();
    super.onClose();
  }
}
