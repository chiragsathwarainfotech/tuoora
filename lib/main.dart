import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_pages.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';

void main() {
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
      initialRoute: AppRoutes.roleSelection,
      getPages: AppPages.pages,
    );
  }
}
