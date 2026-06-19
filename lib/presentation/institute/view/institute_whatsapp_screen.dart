import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/widgets/toggle_switch.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_info_box.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';

import 'package:tuoora/presentation/institute/controllers/whatsapp_controller.dart';
import 'package:get/get.dart';

class InstituteWhatsAppScreen extends GetView<WhatsAppController> {
  const InstituteWhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const InstituteAppBar(
                  title: AppStrings.instWhatsAppIntegration,
                  isRoot: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPaddingTop,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.instWhatsAppIntegration,
                          style: AppTextStyles.outfit(
                            fontSize: AppSpacing.s28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        AppSpacing.v12,
                        Text(
                          AppStrings.instWhatsAppConfigDesc,
                          style: AppTextStyles.outfit(
                            fontSize: 14,
                            height: 1.6,
                            color: AppColors.blueSapphire,
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
            Obx(
              () => controller.isLoading.value
                  ? Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const CommonLoading(color: AppColors.white),
                    )
                  : const SizedBox.shrink(),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
                child: const Icon(
                  Icons.settings_input_component_rounded,
                  color: AppColors.primaryBrand,
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
                      style: AppTextStyles.outfit(
                        fontSize: AppSpacing.s18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppStrings.instLinkWhatsAppAccount,
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        color: AppColors.blueSapphire,
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
            hint: AppStrings.label,
            controller: controller.accessTokenController,
          ),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instPhoneLabel),
          AppSpacing.v12,
          _buildTextField(
            hint: AppStrings.k1234567890,
            controller: controller.phoneNumberController,
            keyboardType: TextInputType.phone,
          ),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instPhoneNumberId),
          AppSpacing.v12,
          _buildTextField(
            hint: AppStrings.k1059,
            controller: controller.phoneNumberIdController,
            keyboardType: TextInputType.number,
          ),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instBusinessAccountId),
          AppSpacing.v12,
          _buildTextField(
            hint: AppStrings.k2941,
            controller: controller.businessAccountIdController,
            keyboardType: TextInputType.number,
          ),
          AppSpacing.v32,
          Obx(
            () => AppButton(
              label: controller.currentSettings.value != null
                  ? 'Update Settings'
                  : AppStrings.instVerifyApiBtn,
              icon: Icons.verified_user_rounded,
              onPressed: () => controller.saveSettings(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.outfit(
        fontSize: AppSpacing.s12,
        fontWeight: FontWeight.w600,
        color: AppColors.fieldLabel,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: AppSpacing.x16.add(AppSpacing.y2),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTextStyles.outfit(
          fontSize: AppSpacing.s14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.outfit(
            fontSize: AppSpacing.s14,
            color: AppColors.fieldLabel,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildHowToFindBox() {
    return const AppInfoBox(
      icon: Icons.info_rounded,
      title: AppStrings.instHowToFindThese,
      description: AppStrings.instHowToFindDesc,
      titleFontSize: AppSpacing.s16,
      descFontSize: AppSpacing.s14,
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
              color: AppColors.primaryBrand,
              size: AppSpacing.s24,
            ),
            AppSpacing.h12,
            Text(
              AppStrings.instAutomatedAlerts,
              style: AppTextStyles.outfit(
                fontSize: AppSpacing.s20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        AppSpacing.v32,
        Container(
          padding: AppSpacing.y8,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s24),
            border: Border.all(color: AppColors.background),
          ),
          child: Column(
            children: [
              Obx(
                () => _buildToggleItem(
                  Icons.account_balance_wallet_rounded,
                  AppStrings.instFeesReminders,
                  AppStrings.instFeesRemindersDesc,
                  controller.feesReminders.value,
                  (v) => controller.feesReminders.value = v,
                ),
              ),
              Obx(
                () => _buildToggleItem(
                  Icons.person_outline_rounded,
                  AppStrings.instAttendanceAlerts,
                  AppStrings.instAttendanceAlertsDesc,
                  controller.attendanceAlerts.value,
                  (v) => controller.attendanceAlerts.value = v,
                ),
              ),
              Obx(
                () => _buildToggleItem(
                  Icons.auto_stories_rounded,
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
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(AppSpacing.s14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBrand,
                  size: AppSpacing.s24,
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.outfit(
                        fontSize: AppSpacing.s16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.outfit(
                        fontSize: AppSpacing.s12,
                        color: AppColors.blueSapphire,
                      ),
                    ),
                  ],
                ),
              ),
              ToggleSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.s2,
            indent: AppSpacing.s88,
            color: AppColors.background,
          ),
      ],
    );
  }
}
