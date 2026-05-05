import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonLoading extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth;

  final double? value;

  const CommonLoading({
    super.key,
    this.color,
    this.size = 24,
    this.strokeWidth = 2,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primaryBrand,
          strokeWidth: strokeWidth,
          value: value,
        ),
      ),
    );
  }

  /// Shows a full-screen non-dismissible loading dialog
  static void show() {
    if (Get.isDialogOpen ?? false) return;
    
    Get.dialog(
      const CommonLoading(color: Colors.white),
      barrierDismissible: false,
      name: 'loading_dialog',
    );
  }

  /// Dismisses the active loading dialog
  static void dismiss() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
