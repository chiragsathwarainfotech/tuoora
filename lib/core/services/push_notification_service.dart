import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/core/services/auth_service.dart';

/// Top-level background message handler.
/// Required by FCM — must be a top-level (or static) function so the OS can
/// spawn an isolated Dart isolate when the app is killed.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase.initializeApp() is already called in main.dart and is safe to
  // re-call here for the background isolate. Importing firebase_core and
  // calling initializeApp() inside this isolate is the standard pattern, but
  // since the background isolate auto-inherits the default app on Android,
  // we just log and return.
  if (kDebugMode) {
    print('[FCM-bg] ${message.messageId} data=${message.data}');
  }
}

class PushNotificationService extends GetxService {
  static PushNotificationService get to => Get.find<PushNotificationService>();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final GetStorage _storage = GetStorage();

  static const String _tokenStorageKey = 'fcm_token';
  static const String _syncedTokenStorageKey = 'fcm_token_synced';
  static const String _androidChannelId = 'tuoora_default_channel';
  static const String _androidChannelName = 'Tuoora Notifications';
  static const String _androidChannelDesc =
      'Default channel for Tuoora push notifications';

  final RxnString _fcmToken = RxnString();
  String? get fcmToken => _fcmToken.value;

  /// Emits every incoming message (foreground, background-tap, terminated-tap).
  /// Subscribe from your controllers/screens to react (navigate, refresh, etc).
  final RxnString _lastMessageJson = RxnString();
  RxnString get onMessage => _lastMessageJson;

  Future<PushNotificationService> init() async {
    await _setupLocalNotifications();
    await _requestPermissions();
    await _configureForegroundPresentation();
    await _registerListeners();
    await _refreshToken();
    await _checkInitialMessage();
    return this;
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('ic_notification');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          _lastMessageJson.value = response.payload;
        }
      },
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDesc,
        importance: Importance.high,
      );
      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (kDebugMode) {
      print('[FCM] permission status: ${settings.authorizationStatus}');
    }
  }

  Future<void> _configureForegroundPresentation() async {
    // iOS: show the OS banner even when the app is in the foreground.
    // We still mirror via flutter_local_notifications on Android because FCM
    // does NOT show a system notification for foreground messages.
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _registerListeners() async {
    // Token refresh — happens when the OS rotates the token.
    _fcm.onTokenRefresh.listen((newToken) {
      _fcmToken.value = newToken;
      _storage.write(_tokenStorageKey, newToken);
      if (kDebugMode) print('[FCM] token refreshed: $newToken');
      _sendTokenToServer(newToken);
    });

    // Foreground messages.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // User tapped a notification while app was in background (not terminated).
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
  }

  Future<void> _refreshToken() async {
    try {
      // On iOS we must wait for the APNs token before requesting the FCM token.
      if (Platform.isIOS) {
        final apnsToken = await _fcm.getAPNSToken();
        if (apnsToken == null) {
          if (kDebugMode) print('[FCM] APNs token not available yet');
        }
      }
      final token = await _fcm.getToken();
      _fcmToken.value = token;
      if (token != null) {
        await _storage.write(_tokenStorageKey, token);
        await _sendTokenToServer(token);
      }
      if (kDebugMode) print('[FCM] token: $token');
    } catch (e) {
      if (kDebugMode) print('[FCM] getToken failed: $e');
    }
  }

  /// POSTs the FCM token to the backend so push messages can be targeted at
  /// this device. No-op when the user isn't authenticated or when the token
  /// matches the last value successfully synced.
  Future<void> _sendTokenToServer(String token) async {
    if (token.isEmpty) return;

    final auth = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    if (auth == null || !auth.isAuthenticated) {
      if (kDebugMode) print('[FCM] skip sync — not authenticated');
      return;
    }

    final lastSynced = _storage.read<String>(_syncedTokenStorageKey);
    if (lastSynced == token) {
      if (kDebugMode) print('[FCM] token already synced');
      return;
    }

    try {
      final api = Get.find<ApiClient>();
      final response = await api.post(
        ApiConstants.fcmToken,
        {'fcm_token': token},
      );
      if (response.status.hasError) {
        if (kDebugMode) {
          print('[FCM] sync failed: ${response.statusCode} ${response.body}');
        }
        return;
      }
      await _storage.write(_syncedTokenStorageKey, token);
      if (kDebugMode) print('[FCM] token synced to server');
    } catch (e) {
      if (kDebugMode) print('[FCM] sync error: $e');
    }
  }

  /// Push the cached FCM token to the backend now. Call this right after a
  /// successful login so the server can target this device.
  Future<void> syncToken() async {
    final token = _fcmToken.value ?? await _fcm.getToken();
    if (token == null) return;
    _fcmToken.value = token;
    await _sendTokenToServer(token);
  }

  Future<void> _checkInitialMessage() async {
    // If the app was launched by tapping a notification (terminated state).
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _onMessageOpened(initial);
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('[FCM-fg] ${message.messageId} data=${message.data}');
    }
    _lastMessageJson.value = jsonEncode(message.data);

    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && (Platform.isAndroid || Platform.isIOS)) {
      _local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannelId,
            _androidChannelName,
            channelDescription: _androidChannelDesc,
            icon: android?.smallIcon ?? 'ic_notification',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _onMessageOpened(RemoteMessage message) {
    if (kDebugMode) {
      print('[FCM-tap] ${message.messageId} data=${message.data}');
    }
    _lastMessageJson.value = jsonEncode(message.data);
    // TODO: route based on payload, e.g.:
    // final type = message.data['type'];
    // if (type == 'lead') Get.toNamed(AppRoutes.leadDetail, arguments: ...);
  }

  /// Subscribe to a topic (broadcast channel) — server sends to topic name.
  Future<void> subscribeToTopic(String topic) => _fcm.subscribeToTopic(topic);

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) =>
      _fcm.unsubscribeFromTopic(topic);

  /// Force a fresh token (e.g. on login). Returns the new token.
  Future<String?> refreshToken() async {
    await _refreshToken();
    return fcmToken;
  }

  /// Delete the FCM registration (e.g. on logout). The next getToken() will
  /// issue a new one.
  Future<void> deleteToken() async {
    await _fcm.deleteToken();
    _fcmToken.value = null;
    await _storage.remove(_tokenStorageKey);
    await _storage.remove(_syncedTokenStorageKey);
  }
}
