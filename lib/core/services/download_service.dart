import 'dart:io';
import 'package:tuoora/core/constants/app_colors.dart';
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
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          filePath = '${directory.path}/$fileName';
        } else {
          filePath =
              '/storage/emulated/0/Android/data/com.app.tuoora/files/$fileName';
        }
      } else if (Platform.isIOS) {
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
        colorText: AppColors.white,
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
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

