import 'dart:io';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_network_image.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class InstituteProfileSetupScreen extends GetView<SignupController> {
  const InstituteProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(
              title: AppStrings.completeSetup,
              isRoot: true,
              hideLeading: true,
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPaddingTop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogoSection(),
                    AppSpacing.v32,
                    _buildSectionHeader('Finalize Profile'),
                    AppSpacing.v16,
                    Obx(
                      () => _buildTextField(
                        label: AppStrings.instInstituteNameLabel,
                        controller: controller.instituteNameController,
                        prefixIcon: Icons.business_outlined,
                        errorText: controller.instituteNameError.value,
                        onChanged: (_) {
                          if (controller.instituteNameError.value != null) {
                            controller.instituteNameError.value = null;
                          }
                        },
                      ),
                    ),
                    AppSpacing.v20,
                    Obx(
                      () => _buildTextField(
                        label: AppStrings.instOwnerNameLabel,
                        controller: controller.instituteOwnerNameController,
                        prefixIcon: Icons.person,
                        errorText: controller.ownerNameError.value,
                        onChanged: (_) {
                          if (controller.ownerNameError.value != null) {
                            controller.ownerNameError.value = null;
                          }
                        },
                      ),
                    ),
                    AppSpacing.v20,
                    _buildTextField(
                      label: AppStrings.instEmailAddressLabel,
                      controller: controller.emailController,
                      prefixIcon: Icons.mail,
                      enabled: false,
                    ),
                    AppSpacing.v20,
                    Obx(
                      () => _buildTextField(
                        label: AppStrings.instPhoneLabel,
                        controller: controller.phoneController,
                        hint: AppStrings.instPhoneHint,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        errorText: controller.phoneError.value,
                        onChanged: (_) {
                          if (controller.phoneError.value != null) {
                            controller.phoneError.value = null;
                          }
                        },
                      ),
                    ),
                    AppSpacing.v32,
                    _buildSectionHeader('LOCATION DETAILS'),
                    AppSpacing.v16,
                    Obx(
                      () => _buildTextField(
                        label: AppStrings.labelAddressLine1,
                        controller: controller.addressLine1Controller,
                        hint: AppStrings.enterAddressLine1,
                        prefixIcon: Icons.location_on_outlined,
                        errorText: controller.addressLine1Error.value,
                        onChanged: (_) {
                          if (controller.addressLine1Error.value != null) {
                            controller.addressLine1Error.value = null;
                          }
                        },
                      ),
                    ),
                    AppSpacing.v20,
                    _buildTextField(
                      label: AppStrings.labelAddressLine2,
                      controller: controller.addressLine2Controller,
                      hint: AppStrings.enterAddressLine2,
                      prefixIcon: Icons.add_location_outlined,
                    ),
                    AppSpacing.v20,
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => _buildTextField(
                              label: AppStrings.labelCity,
                              controller: controller.cityController,
                              hint: AppStrings.enterCity,
                              prefixIcon: Icons.location_city_outlined,
                              errorText: controller.cityError.value,
                              onChanged: (_) {
                                if (controller.cityError.value != null) {
                                  controller.cityError.value = null;
                                }
                              },
                            ),
                          ),
                        ),
                        AppSpacing.h16,
                        Expanded(
                          child: Obx(
                            () => _buildTextField(
                              label: AppStrings.labelState,
                              controller: controller.stateController,
                              hint: AppStrings.enterState,
                              prefixIcon: Icons.map_outlined,
                              errorText: controller.stateError.value,
                              onChanged: (_) {
                                if (controller.stateError.value != null) {
                                  controller.stateError.value = null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v20,
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => _buildTextField(
                              label: AppStrings.labelCountry,
                              controller: controller.countryController,
                              hint: AppStrings.enterCountry,
                              prefixIcon: Icons.public_outlined,
                              errorText: controller.countryError.value,
                              onChanged: (_) {
                                if (controller.countryError.value != null) {
                                  controller.countryError.value = null;
                                }
                              },
                            ),
                          ),
                        ),
                        AppSpacing.h16,
                        Expanded(
                          child: Obx(
                            () => _buildTextField(
                              label: AppStrings.labelPincode,
                              controller: controller.pincodeController,
                              hint: AppStrings.enterPincode,
                              prefixIcon: Icons.pin_drop_outlined,
                              keyboardType: TextInputType.number,
                              errorText: controller.pincodeError.value,
                              onChanged: (_) {
                                if (controller.pincodeError.value != null) {
                                  controller.pincodeError.value = null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v40,
                    SafeArea(
                      top: false,
                      minimum: const EdgeInsets.only(bottom: 16),
                      child: Obx(
                        () => AppButton(
                          label: AppStrings.finish,
                          onPressed: controller.completeProfile,
                          isLoading: controller.isLoading.value,
                          backgroundColor: AppColors.primaryBrand,
                          foregroundColor: AppColors.white,
                          borderRadius: AppSpacing.cardRadius,
                          fontSize: 16,
                          fullWidth: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() {
              final path = controller.selectedLogoPath.value;
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: path == null
                    ? const Center(
                        child: Icon(
                          Icons.school_rounded,
                          size: 56,
                          color: AppColors.primaryBrand,
                        ),
                      )
                    : (path.startsWith('http') || !path.contains('/')
                          ? AppNetworkImage(
                              url: path,
                              fit: BoxFit.cover,
                              errorWidget: const Icon(Icons.error),
                            )
                          : Image.file(File(path), fit: BoxFit.cover)),
              );
            }),
            Positioned(
              bottom: -6,
              right: -6,
              child: GestureDetector(
                onTap: controller.pickLogo,
                child: Container(
                  padding: AppSpacing.all10,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrand,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBrand.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        AppSpacing.v16,
        Text(
          AppStrings.instLogo,
          style: AppTextStyles.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    required IconData prefixIcon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.fieldBg
                : AppColors.fieldBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: hasError
                ? Border.all(color: Colors.redAccent, width: 1.5)
                : null,
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: AppTextStyles.outfit(
              fontSize: 14,
              color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.fieldLabel,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.textMuted,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: AppSpacing.all16,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText,
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
