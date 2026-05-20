import 'dart:io';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
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
      backgroundColor: AppColors.loginBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(
              title: 'Setup Profile',
              isRoot: true,
              hideLeading: true,
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: controller.pickLogo,
                        child: Obx(
                          () => Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrandLight,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.brandAppBarColor,
                                    width: 2,
                                  ),
                                  image:
                                      controller.selectedLogoPath.value != null
                                      ? DecorationImage(
                                          image: FileImage(
                                            File(
                                              controller
                                                  .selectedLogoPath
                                                  .value!,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: controller.selectedLogoPath.value == null
                                    ? const Icon(
                                        Icons.add_a_photo_outlined,
                                        color: AppColors.brandAppBarColor,
                                        size: 32,
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryBrand,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: AppColors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.v32,
                    _buildSectionHeader('BASIC INFORMATION'),
                    AppSpacing.v16,
                    _buildTextField(
                      label: 'Institute Name',
                      controller: controller.instituteNameController,
                      prefixIcon: Icons.business_outlined,
                    ),
                    AppSpacing.v20,
                    _buildTextField(
                      label: 'Owner Name',
                      controller: controller.instituteOwnerNameController,
                      prefixIcon: Icons.person,
                    ),
                    AppSpacing.v20,
                    _buildTextField(
                      label: 'Email Address',
                      controller: controller.emailController,
                      prefixIcon: Icons.alternate_email,
                      enabled: false,
                    ),
                    AppSpacing.v20,
                    _buildTextField(
                      label: 'Phone Number',
                      controller: controller.phoneController,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    AppSpacing.v32,
                    _buildSectionHeader('LOCATION DETAILS'),
                    AppSpacing.v16,
                    _buildTextField(
                      label: 'Address Line 1',
                      controller: controller.addressLine1Controller,
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    AppSpacing.v20,
                    _buildTextField(
                      label: 'Address Line 2',
                      controller: controller.addressLine2Controller,
                      prefixIcon: Icons.add_location_outlined,
                    ),
                    AppSpacing.v20,
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'City',
                            controller: controller.cityController,
                            prefixIcon: Icons.location_city_outlined,
                          ),
                        ),
                        AppSpacing.h16,
                        Expanded(
                          child: _buildTextField(
                            label: 'State',
                            controller: controller.stateController,
                            prefixIcon: Icons.map_outlined,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v20,
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Country',
                            controller: controller.countryController,
                            prefixIcon: Icons.public_outlined,
                          ),
                        ),
                        AppSpacing.h16,
                        Expanded(
                          child: _buildTextField(
                            label: 'Pincode',
                            controller: controller.pincodeController,
                            prefixIcon: Icons.pin_drop_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v40,
                    Obx(
                      () => AppButton(
                        label: 'Complete Setup',
                        onPressed: controller.completeProfile,
                        isLoading: controller.isLoading.value,
                        backgroundColor: AppColors.primaryBrand,
                        foregroundColor: AppColors.white,
                        borderRadius: AppSpacing.s16,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s18,
                        ),
                        fontSize: 16,
                        fullWidth: true,
                      ),
                    ),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.brandAppBarColor,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.brandAppBarColor,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.paleSilver
                : AppColors.paleSilver.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            ),
            decoration: InputDecoration(
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
      ],
    );
  }
}
