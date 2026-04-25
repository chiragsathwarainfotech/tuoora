import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import 'package:fee_easy/presentation/institute/controllers/whatsapp_controller.dart';
import 'package:get/get.dart';

class InstituteWhatsAppScreen extends GetView<WhatsAppController> {
  const InstituteWhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'WhatsApp Integration', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.instWhatsAppIntegration,
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    AppSpacing.v12,
                    Text(
                      AppStrings.instWhatsAppConfigDesc,
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.v32,
                    _buildMetaConfigCard(),
                    AppSpacing.v24,
                    _buildHowToFindBox(),
                    AppSpacing.v48,
                    _buildAutomatedAlertsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaConfigCard() {
    return Container(
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.all10,
                decoration: BoxDecoration(
                  color: AppColors.indigoLight,
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
                child: const Icon(
                  Icons.settings_input_component_rounded,
                  color: Color(0xFF4338CA),
                  size: AppSpacing.s24,
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.instMetaApiConfig,
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppStrings.instLinkWhatsAppAccount,
                      style: AppTextStyles.lexend(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v32,
          _buildInputLabel(AppStrings.instAccessToken),
          AppSpacing.v12,
          _buildTextField(
            hint: '••••••••••••••••••••••••••••••••',
            controller: controller.accessTokenController,
          ),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instPhoneLabel),
          AppSpacing.v12,
          _buildTextField(
            hint: '1234567890',
            controller: controller.phoneNumberController,
          ),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instPhoneNumberId),
          AppSpacing.v12,
          _buildTextField(
            hint: '1059...',
            controller: controller.phoneNumberIdController,
          ),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instBusinessAccountId),
          AppSpacing.v12,
          _buildTextField(
            hint: '2941...',
            controller: controller.businessAccountIdController,
          ),
          AppSpacing.v32,
          ElevatedButton(
            onPressed: controller.verifyApi,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0055BB),
              foregroundColor: Colors.white,
              padding: AppSpacing.y20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.s12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user_rounded, size: AppSpacing.s18),
                AppSpacing.h8,
                Text(
                  AppStrings.instVerifyApiBtn,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.manrope(
        fontSize: AppSpacing.s12,
        fontWeight: FontWeight.w800,
        color: AppColors.textDarkGrey,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      padding: AppSpacing.x16.add(AppSpacing.y2),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.lexend(
          fontSize: AppSpacing.s14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.lexend(
            fontSize: AppSpacing.s14,
            color: AppColors.textMuted,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildHowToFindBox() {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(
          color: const Color(0xFFBFDBFE).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_rounded,
            color: AppColors.oceanBlue,
            size: AppSpacing.s20,
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.instHowToFindThese,
                  style: AppTextStyles.manrope(
                    fontSize: AppSpacing.s16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.oceanBlue,
                  ),
                ),
                AppSpacing.v8,
                Text(
                  AppStrings.instHowToFindDesc,
                  style: AppTextStyles.lexend(
                    fontSize: AppSpacing.s14,
                    height: 1.5,
                    color: AppColors.oceanBlue.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomatedAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.notification_add_rounded,
              color: AppColors.primaryBlue,
              size: AppSpacing.s24,
            ),
            AppSpacing.h12,
            Text(
              AppStrings.instAutomatedAlerts,
              style: AppTextStyles.manrope(
                fontSize: AppSpacing.s20,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        AppSpacing.v32,
        Container(
          padding: AppSpacing.y8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s24),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              Obx(
                () => _buildToggleItem(
                  Icons.account_balance_wallet_rounded,
                  const Color(0xFFFFE4E1),
                  const Color(0xFFB91C1C),
                  AppStrings.instFeesReminders,
                  AppStrings.instFeesRemindersDesc,
                  controller.feesReminders.value,
                  (v) => controller.feesReminders.value = v,
                ),
              ),
              Obx(
                () => _buildToggleItem(
                  Icons.person_outline_rounded,
                  AppColors.indigoLight,
                  const Color(0xFF4338CA),
                  AppStrings.instAttendanceAlerts,
                  AppStrings.instAttendanceAlertsDesc,
                  controller.attendanceAlerts.value,
                  (v) => controller.attendanceAlerts.value = v,
                ),
              ),
              Obx(
                () => _buildToggleItem(
                  Icons.auto_stories_rounded,
                  const Color(0xFFE0F2FE),
                  const Color(0xFF0369A1),
                  AppStrings.instHomeworkUpdates,
                  AppStrings.instHomeworkUpdatesDesc,
                  controller.homeworkUpdates.value,
                  (v) => controller.homeworkUpdates.value = v,
                  showDivider: true,
                ),
              ),
              Obx(
                () => _buildToggleItem(
                  Icons.campaign_rounded,
                  AppColors.divider,
                  AppColors.textSecondary,
                  AppStrings.instHolidayNotices,
                  AppStrings.instHolidayNoticesDesc,
                  controller.holidayNotices.value,
                  (v) => controller.holidayNotices.value = v,
                  showDivider: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(
    IconData icon,
    Color iconBg,
    Color iconColor,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: AppSpacing.all20,
          child: Row(
            children: [
              Container(
                padding: AppSpacing.all12,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s14),
                ),
                child: Icon(icon, color: iconColor, size: AppSpacing.s24),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.lexend(
                        fontSize: AppSpacing.s12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.oceanBlue,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.s2,
            indent: AppSpacing.s88,
            color: AppColors.divider,
          ),
      ],
    );
  }
}
