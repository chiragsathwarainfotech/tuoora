import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

/// Celebratory birthday popup shown on the student dashboard when a
/// `birthday_celebration` notification is tapped. Closeable via the cross icon
/// or the bottom button.
class BirthdayWishDialog extends StatelessWidget {
  final String name;
  final String? message;

  const BirthdayWishDialog({super.key, required this.name, this.message});

  /// Shows the dialog through GetX's overlay. Guards against stacking a second
  /// copy if one is already open.
  static void show({required String name, String? message}) {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      BirthdayWishDialog(name: name, message: message),
      barrierColor: Colors.black.withValues(alpha: 0.55),
    );
  }

  @override
  Widget build(BuildContext context) {
    final greetingName = name.trim().isEmpty ? 'there' : name.trim();
    final wish = (message != null && message!.trim().isNotEmpty)
        ? message!.trim()
        : 'Wishing you a day as wonderful as you are. The whole Tuoora family '
              'is celebrating you today!';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryBrand, AppColors.orangeTag],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cake_rounded,
                    color: AppColors.primaryBrand,
                    size: 46,
                  ),
                ),
                AppSpacing.v20,
                Text(
                  'Happy Birthday!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
                AppSpacing.v8,
                Text(
                  greetingName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                AppSpacing.v16,
                Text(
                  wish,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
                AppSpacing.v24,
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                    ),
                    child: Text(
                      'Thank You!',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: AppSpacing.all4,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
