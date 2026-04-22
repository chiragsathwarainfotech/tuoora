import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
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
              if (controller.isLoading.value)
                const Center(child: CircularProgressIndicator()),
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
                          color: AppColors.instPrimaryBlue,
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
                    color: AppColors.instPrimaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.instPrimaryBlue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
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
            color: AppColors.instPrimaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: AppColors.instPrimaryBlue,
                size: 20,
              ),
              AppSpacing.h12,
              Text(
                'INSTITUTE INFORMATION',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.instPrimaryBlue,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          _buildInputField(
            label: AppStrings.instInstituteNameLabel,
            textController: controller.nameController,
            icon: Icons.school_outlined,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instOwnerNameLabel,
            textController: controller.ownerController,
            icon: Icons.person_outline_rounded,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instContactEmailLabel,
            textController: controller.emailController,
            icon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: AppStrings.instPhoneNumberLabel,
            textController: controller.phoneController,
            icon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.number,
          ),
          _buildInputField(
            label: 'Address Line 1',
            textController: controller.addressLine1Controller,
            icon: Icons.location_on_outlined,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: 'Address Line 2',
            textController: controller.addressLine2Controller,
            icon: Icons.location_on_outlined,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: 'City',
            textController: controller.cityController,
            icon: Icons.location_city_rounded,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: 'State',
            textController: controller.stateController,
            icon: Icons.map_rounded,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: 'Country',
            textController: controller.countryController,
            icon: Icons.public_rounded,
          ),
          AppSpacing.v20,
          _buildInputField(
            label: 'Pincode',
            textController: controller.pincodeController,
            icon: Icons.pin_drop_rounded,
            keyboardType: TextInputType.number,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController textController,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        AppSpacing.v8,
        Container(
          padding: AppSpacing.x16,
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderGrey.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.instPrimaryBlue, size: 20),
              AppSpacing.h16,
              Expanded(
                child: TextField(
                  controller: textController,
                  keyboardType: keyboardType,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: AppSpacing.s18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityNotice() {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCFCE7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF166534),
            size: 20,
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.instSecurityNote,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF166534),
                  ),
                ),
                AppSpacing.v4,
                Text(
                  AppStrings.instSecurityNoteDesc,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: const Color(0xFF15803D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.saveProfile(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
            decoration: BoxDecoration(
              color: AppColors.instDarkBtnBlue,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.instDarkBtnBlue.withValues(alpha: 0.2),
                  blurRadius: AppSpacing.s16,
                  offset: const Offset(0, AppSpacing.s8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Save Profile Changes',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
