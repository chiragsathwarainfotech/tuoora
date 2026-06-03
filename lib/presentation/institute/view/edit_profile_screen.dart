import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/core/widgets/app_network_image.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class InstituteEditProfileScreen extends GetView<InstituteProfileController> {
  const InstituteEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              Column(
                children: [
                  const InstituteAppBar(
                    title: AppStrings.editInstituteProfile,
                    isRoot: false,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppSpacing.screenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLogoSection(),
                          AppSpacing.v24,
                          _buildFormSection(),
                          AppSpacing.v24,
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value) const CommonLoading(),
            ],
          ),
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
              final path = controller.profileImagePath.value;
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
                onTap: () => controller.pickImage(),
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
          AppStrings.instChangeLogo,
          style: AppTextStyles.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.business_rounded,
                color: AppColors.fieldLabel,
                size: 20,
              ),
              AppSpacing.h12,
              Text(
                AppStrings.instituteInformation,
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          Obx(
            () => AppInputField(
              label: AppStrings.instInstituteNameLabel,
              controller: controller.nameController,
              icon: Icons.school_outlined,
              errorText: controller.instituteNameError.value,
            ),
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: AppStrings.instOwnerNameLabel,
              controller: controller.ownerController,
              icon: Icons.person_outline_rounded,
              errorText: controller.ownerNameError.value,
            ),
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: AppStrings.instContactEmailLabel,
              controller: controller.emailController,
              icon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
              errorText: controller.emailError.value,
            ),
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: AppStrings.instPhoneLabel,
              controller: controller.phoneController,
              icon: Icons.phone_iphone_rounded,
              keyboardType: TextInputType.number,
              errorText: controller.phoneError.value,
            ),
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.labelAddressLine1,
            controller: controller.addressLine1Controller,
            icon: Icons.location_on_outlined,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.labelAddressLine2,
            controller: controller.addressLine2Controller,
            icon: Icons.location_on_outlined,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.labelCity,
            controller: controller.cityController,
            icon: Icons.location_city_rounded,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.labelState,
            controller: controller.stateController,
            icon: Icons.map_rounded,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.labelCountry,
            controller: controller.countryController,
            icon: Icons.public_rounded,
          ),
          AppSpacing.v20,
          Obx(
            () => AppInputField(
              label: AppStrings.labelPincode,
              controller: controller.pincodeController,
              icon: Icons.pin_drop_rounded,
              keyboardType: TextInputType.number,
              errorText: controller.pincodeError.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: AppButton(
        label: AppStrings.saveProfileChanges,
        icon: Icons.check_circle_outline_rounded,
        onPressed: () => controller.saveProfile(),
      ),
    );
  }
}
