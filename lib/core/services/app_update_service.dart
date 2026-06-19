import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';

class AppUpdateService extends GetxService {
  static AppUpdateService get to => Get.find<AppUpdateService>();

  bool _checking = false;

  Future<void> checkForUpdate() async {
    if (!Platform.isAndroid) return;
    if (_checking) return;
    _checking = true;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      final isCritical = info.updatePriority >= 4;
      if (isCritical && info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
        return;
      }
      if (info.flexibleUpdateAllowed) {
        final result = await InAppUpdate.startFlexibleUpdate();
        if (result == AppUpdateResult.success) {
          _showRestartPrompt();
        }
        return;
      }
      if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (_) {
    } finally {
      _checking = false;
    }
  }

  void _showRestartPrompt() {
    Get.snackbar(
      AppStrings.updateReadyTitle,
      AppStrings.updateReadyMessage,
      backgroundColor: AppColors.primaryBrand,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.system_update_rounded, color: AppColors.white),
      duration: const Duration(seconds: 8),
      mainButton: TextButton(
        onPressed: () async {
          try {
            await InAppUpdate.completeFlexibleUpdate();
          } catch (_) {}
        },
        child: const Text(
          AppStrings.updateRestartButton,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
