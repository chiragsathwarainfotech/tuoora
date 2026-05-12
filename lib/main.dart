import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_pages.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(ApiClient());
  await Get.putAsync(() => AuthService().init());

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

