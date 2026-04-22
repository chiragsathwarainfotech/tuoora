import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/shared/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
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
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader('BASIC INFORMATION'),
                    AppSpacing.v16,
                    _buildTextField(
                      label: 'Institute Name',
                      controller: controller.instituteNameController,
                      prefixIcon: Icons.business_outlined,
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
                      label: 'Address Line 2 (Optional)',
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
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
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

  Widget _buildAppBar() {
    return Container(
      padding: AppSpacing.all24,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
              AppSpacing.h12,
              Text(
                'Setup Profile',
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.v8,
          Text(
            'Complete your institute profile to get started with FeeEasy.',
            style: AppTextStyles.lexend(
              fontSize: 14,
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.primaryBlue,
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
            color: AppColors.textSecondary,
          ),
        ),
        AppSpacing.v8,
        Container(
          decoration: BoxDecoration(
            color: enabled ? AppColors.inputBg : AppColors.inputBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1,
            ),
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
              prefixIcon: Icon(prefixIcon, color: AppColors.textMuted, size: 20),
              border: InputBorder.none,
              contentPadding: AppSpacing.all16,
            ),
          ),
        ),
      ],
    );
  }
}
