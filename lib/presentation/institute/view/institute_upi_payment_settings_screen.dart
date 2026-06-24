import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';

class InstituteUpiPaymentSettingsScreen
    extends GetView<InstituteProfileController> {
  const InstituteUpiPaymentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final upiIdField = TextEditingController(text: controller.upiId.value);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(
              title: AppStrings.upiPaymentSettingsTitle,
              isRoot: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntroBlock(),
                    AppSpacing.v16,
                    _buildConfigurationsCard(upiIdField),
                    AppSpacing.v16,
                    _buildQrSpecInfoBox(),
                    AppSpacing.v24,
                    Obx(
                      () => AppButton(
                        label: AppStrings.saveSettings,
                        icon: Icons.check_circle_outline_rounded,
                        isLoading: controller.isSavingPayment.value,
                        onPressed: controller.isSavingPayment.value
                            ? null
                            : () => controller.savePaymentSettings(
                                upiIdField.text,
                              ),
                      ),
                    ),
                    AppSpacing.v24,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroBlock() {
    return Text(
      AppStrings.upiPaymentSettingsSubtitle,
      style: AppTextStyles.outfit(
        fontSize: 13,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildConfigurationsCard(TextEditingController upiIdField) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSectionHeader(
            AppStrings.upiConfigurationsHeader,
            Icons.qr_code_2_rounded,
          ),
          AppSpacing.v4,
          _fieldLabel(AppStrings.upiIdLabel),
          AppSpacing.v8,
          Obx(() {
            return _upiIdInput(
              upiIdField,
              errorText: controller.upiIdError.value,
            );
          }),
          AppSpacing.v8,
          Text(
            AppStrings.upiIdHelper,
            style: AppTextStyles.outfit(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          AppSpacing.v20,
          _fieldLabel(AppStrings.upiQrCodeLabelRequired),
          AppSpacing.v4,
          Text(
            AppStrings.upiQrCodeRequiredHelper,
            style: AppTextStyles.outfit(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          AppSpacing.v8,
          Obx(() => _buildQrPicker()),
          Obx(() {
            final err = controller.upiQrError.value;
            if (err == null || err.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                err,
                style: AppTextStyles.outfit(
                  fontSize: 11,
                  color: AppColors.bohoRed,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _upiIdInput(TextEditingController upiIdField, {String? errorText}) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: AppSpacing.x16,
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError ? AppColors.bohoRed : AppColors.fieldBorder,
            ),
          ),
          child: TextField(
            controller: upiIdField,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              if (controller.upiIdError.value != null) {
                controller.upiIdError.value = null;
              }
            },
            style: AppTextStyles.outfit(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.upiIdHint,
              hintStyle: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.fieldLabel,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              isCollapsed: true,
            ),
          ),
        ),
        if (hasError) ...[
          AppSpacing.v4,
          Text(
            errorText,
            style: AppTextStyles.outfit(fontSize: 11, color: AppColors.bohoRed),
          ),
        ],
      ],
    );
  }

  // -------------------------------- QR image picker / preview block
  Widget _buildQrPicker() {
    final preview = controller.upiQrPreviewSource;
    final hasError = (controller.upiQrError.value ?? '').isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? AppColors.bohoRed : AppColors.fieldBorder,
          style: BorderStyle.solid,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          if (preview != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 180,
                height: 180,
                child: _qrImage(preview),
              ),
            )
          else
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryBrandLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: 32,
                color: AppColors.primaryBrand,
              ),
            ),
          AppSpacing.v12,
          Text(
            preview == null
                ? 'No QR code uploaded yet'
                : 'QR code ready — pick a new file to replace',
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.v12,
          OutlinedButton.icon(
            onPressed: _showImageSourceSheet,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBrand,
              side: const BorderSide(color: AppColors.primaryBrand),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            icon: const Icon(Icons.upload_rounded, size: 18),
            label: Text(
              AppStrings.chooseFile,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a widget that renders [src] — a freshly-picked local file
  /// path, or the server-hosted https URL once saved.
  Widget _qrImage(String src) {
    if (src.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.contain,
        placeholder: (_, _) => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, _, _) => const Icon(
          Icons.broken_image_rounded,
          color: AppColors.textMuted,
          size: 48,
        ),
      );
    }
    return Image.file(File(src), fit: BoxFit.contain);
  }

  void _showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all20,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sourceTile(
              icon: Icons.camera_alt_rounded,
              label: AppStrings.labelCamera,
              onTap: () {
                Get.back();
                controller.pickUpiQrImage(ImageSource.camera);
              },
            ),
            AppSpacing.v8,
            _sourceTile(
              icon: Icons.photo_library_rounded,
              label: AppStrings.labelGallery,
              onTap: () {
                Get.back();
                controller.pickUpiQrImage(ImageSource.gallery);
              },
            ),
            AppSpacing.v8,
          ],
        ),
      ),
    );
  }

  Widget _sourceTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: AppSpacing.all8,
        decoration: const BoxDecoration(
          color: AppColors.primaryBrandLight,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.image_rounded, color: AppColors.primaryBrand),
      ),
      title: Text(
        label,
        style: AppTextStyles.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Icon(icon, color: AppColors.primaryBrand),
    );
  }

  // ----------------------------------------- QR specifications info
  Widget _buildQrSpecInfoBox() {
    return _card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppSpacing.all8,
              decoration: BoxDecoration(
                color: AppColors.primaryBrandLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primaryBrand,
                size: 18,
              ),
            ),
            AppSpacing.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.upiQrCodeSpecHeader,
                    style: AppTextStyles.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    AppStrings.upiQrCodeSpec,
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------- helpers
  Widget _card({required Widget child}) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _cardSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBrand),
          AppSpacing.h8,
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: AppTextStyles.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.fieldLabel,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
