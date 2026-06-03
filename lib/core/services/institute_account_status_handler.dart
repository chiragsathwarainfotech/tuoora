import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

class AccountStatus {
  AccountStatus._();
  static const blocked = 'blocked';
}

class AccountStatusException implements Exception {
  final String status;
  final String message;
  AccountStatusException(this.status, this.message);

  @override
  String toString() => message;
}

class InstituteAccountStatusHandler extends GetxService {
  static InstituteAccountStatusHandler get to =>
      Get.find<InstituteAccountStatusHandler>();

  bool _dialogShowing = false;

  void handleForbidden({required String status, required String message}) {
    final authService = Get.find<AuthService>();
    if (authService.currentUser?.role != 'INSTITUTE') return;

    if (status == AccountStatus.blocked) {
      _showBlockedDialog(message);
    }
  }

  void _showBlockedDialog(String message) {
    if (_dialogShowing) return;
    _dialogShowing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        _BlockedAccountDialog(
          message: message,
          onLogout: () async {
            _dialogShowing = false;
            await _clearAndGoToLogin();
          },
        ),
        barrierDismissible: false,
      ).whenComplete(() => _dialogShowing = false);
    });
  }

  Future<void> _clearAndGoToLogin() async {
    try {
      await Get.find<AuthService>().clearSession();
    } catch (_) {}
    if (Get.isDialogOpen ?? false) Get.back();
    Get.offAllNamed(AppRoutes.login, arguments: 'INSTITUTE');
  }
}

class _BlockedAccountDialog extends StatelessWidget {
  final String message;
  final Future<void> Function() onLogout;

  const _BlockedAccountDialog({required this.message, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final blockedIndex = message.toUpperCase().indexOf('BLOCKED');

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warningAmber,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.instituteAccountBlocked,
                textAlign: TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              if (blockedIndex >= 0)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: message.substring(0, blockedIndex)),
                      TextSpan(
                        text: 'BLOCKED',
                        style: AppTextStyles.outfit(
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBrand,
                        ),
                      ),
                      TextSpan(
                        text: message.substring(
                          blockedIndex + 'BLOCKED'.length,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                  label: Text(
                    AppStrings.logout,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bohoRed,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
