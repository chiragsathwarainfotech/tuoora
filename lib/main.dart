import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_pages.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/services/push_notification_service.dart';
import 'package:tuoora/firebase_options.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Get.put(ApiClient());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => PushNotificationService().init());

  runApp(const FeeEasyApp());
}

class FeeEasyApp extends StatelessWidget {
  const FeeEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tuoora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
