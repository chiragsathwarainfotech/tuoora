import 'dart:io';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadService extends GetxService {
  Future<void> saveFile({
    required List<int> bytes,
    required String fileName,
    String? successMessage,
  }) async {
    try {
      String? filePath;

      if (Platform.isAndroid) {
        // Common download path for Android
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          filePath = '${directory.path}/$fileName';
        } else {
          // Fallback to app-specific external storage if the above doesn't exist
          // In a real app, we'd use path_provider here.
          filePath = '/storage/emulated/0/Android/data/com.example.fee_easy/files/$fileName';
        }
      } else if (Platform.isIOS) {
        // iOS handling is more restrictive, usually we'd use path_provider's getApplicationDocumentsDirectory
        // For now, we'll focus on the Android requirement mentioned by the user
        throw Exception('iOS download path requires path_provider package');
      }

      if (filePath == null) {
        throw Exception('Could not determine download directory');
      }

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      Get.snackbar(
        'Success',
        successMessage ?? 'File downloaded successfully to Downloads folder',
        backgroundColor: AppColors.darkGreen,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print('Download Error: $e');
      Get.snackbar(
        'Download Failed',
        'Could not save file: ${e.toString()}',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
