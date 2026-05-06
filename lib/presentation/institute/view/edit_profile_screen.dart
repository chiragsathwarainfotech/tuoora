import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/enums/app_enums.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/core/widgets/app_info_box.dart';
import 'package:fee_easy/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:io';
import '../controllers/institute_profile_controller.dart';

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
                    title: 'Edit Institute Profile',
                    isRoot: false,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppSpacing.all24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLogoSection(),
                          AppSpacing.v32,
                          _buildFormSection(),
                          AppSpacing.v24,
                          _buildSecurityNotice(),
                          AppSpacing.v40,
                          _buildActionButtons(),
                          AppSpacing.v40,
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
          children: [
            Obx(
              () => SizedBox(
                width: 140,
                height: 140,
                child: controller.profileImagePath.value == null
                    ? const Center(
                        child: Icon(
                          Icons.school_rounded,
                          size: 64,
                          color: AppColors.primaryBrand,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child:
                            controller.profileImagePath.value!.startsWith(
                                  'http',
                                ) ||
                                !controller.profileImagePath.value!.contains(
                                  '/',
                                )
                            ? Image.network(
                                controller.profileImagePath.value!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              )
                            : Image.file(
                                File(controller.profileImagePath.value!),
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
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
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
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
                color: AppColors.primaryBrand,
                size: 20,
              ),
              AppSpacing.h12,
              Text(
                'INSTITUTE INFORMATION',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBrand,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          AppInputField(
            label: AppStrings.instInstituteNameLabel,
            controller: controller.nameController,
            icon: Icons.school_outlined,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.instOwnerNameLabel,
            controller: controller.ownerController,
            icon: Icons.person_outline_rounded,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.instContactEmailLabel,
            controller: controller.emailController,
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            enabled: false,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: AppStrings.instPhoneNumberLabel,
            controller: controller.phoneController,
            icon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.number,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'Address Line 1',
            controller: controller.addressLine1Controller,
            icon: Icons.location_on_outlined,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'Address Line 2',
            controller: controller.addressLine2Controller,
            icon: Icons.location_on_outlined,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'City',
            controller: controller.cityController,
            icon: Icons.location_city_rounded,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'State',
            controller: controller.stateController,
            icon: Icons.map_rounded,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'Country',
            controller: controller.countryController,
            icon: Icons.public_rounded,
            variant: AppInputFieldVariant.profile,
          ),
          AppSpacing.v20,
          AppInputField(
            label: 'Pincode',
            controller: controller.pincodeController,
            icon: Icons.pin_drop_rounded,
            keyboardType: TextInputType.number,
            variant: AppInputFieldVariant.profile,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice() {
    return const AppInfoBox(
      icon: Icons.verified_user_rounded,
      title: AppStrings.instSecurityNote,
      description: AppStrings.instSecurityNoteDesc,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        AppButton(
          label: 'Save Profile Changes',
          icon: Icons.check_circle_outline_rounded,
          onPressed: () => controller.saveProfile(),
        ),
        AppSpacing.v16,
        GestureDetector(
          onTap: () => controller.discardChanges(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
              border: Border.all(color: AppColors.borderGrey, width: 1.5),
            ),
            child: Center(
              child: Text(
                'Discard Changes',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
