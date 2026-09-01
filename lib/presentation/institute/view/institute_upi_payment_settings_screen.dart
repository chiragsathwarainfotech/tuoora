import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';

class InstituteUpiPaymentSettingsScreen extends StatefulWidget {
  const InstituteUpiPaymentSettingsScreen({super.key});

  @override
  State<InstituteUpiPaymentSettingsScreen> createState() => _InstituteUpiPaymentSettingsScreenState();
}

class _InstituteUpiPaymentSettingsScreenState extends State<InstituteUpiPaymentSettingsScreen> {
  late final InstituteProfileController controller;
  late final TextEditingController _upiIdController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<InstituteProfileController>();
    _upiIdController = TextEditingController(text: controller.upiId.value);
    controller.upiIdError.value = null;
    controller.upiQrError.value = null;
    controller.upiQrLocalPath.value = null;
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.upiPaymentSettingsTitle,
                      style: AppTextStyles.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.fieldBorder),
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.upiPaymentSettingsSubtitle,
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.v16,
                    
                    // UPI ID
                    _fieldLabel(AppStrings.upiIdLabel),
                    AppSpacing.v8,
                    Obx(() {
                      final errorText = controller.upiIdError.value;
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
                              controller: _upiIdController,
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
                    
                    // QR Code required section
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
                    AppSpacing.v16,
                    
                    // QR Specifications Info Box
                    _buildQrSpecInfoBox(),
                  ],
                ),
              ),
            ),
            
            const Divider(height: 1, color: AppColors.fieldBorder),
            
            // Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(
                () {
                  final isLoading = controller.isSavingPayment.value;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => controller.savePaymentSettings(_upiIdController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrand,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading) ...[
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                            ),
                          ),
                          AppSpacing.h12,
                        ] else ...[
                          const Icon(Icons.check_circle_outline_rounded, size: 18),
                          AppSpacing.h8,
                        ],
                        Text(
                          AppStrings.saveSettings,
                          style: AppTextStyles.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  Widget _buildQrPicker() {
    final preview = controller.upiQrPreviewSource;
    final hasError = (controller.upiQrError.value ?? '').isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
                width: 150,
                height: 150,
                child: _qrImage(preview),
              ),
            )
          else
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.primaryBrandLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                size: 28,
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
              fontSize: 11,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(Icons.upload_rounded, size: 16),
            label: Text(
              AppStrings.chooseFile,
              style: AppTextStyles.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qrImage(String src) {
    if (src.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.contain,
        placeholder: (_, _) => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, _, _) => const Icon(
          Icons.broken_image_rounded,
          color: AppColors.textMuted,
          size: 40,
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

  Widget _buildQrSpecInfoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryBrand,
              size: 16,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  AppStrings.upiQrCodeSpec,
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
