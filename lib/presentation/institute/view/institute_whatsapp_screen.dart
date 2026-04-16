import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class InstituteWhatsAppScreen extends StatefulWidget {
  const InstituteWhatsAppScreen({super.key});

  @override
  State<InstituteWhatsAppScreen> createState() =>
      _InstituteWhatsAppScreenState();
}

class _InstituteWhatsAppScreenState extends State<InstituteWhatsAppScreen> {
  bool feesReminders = true;
  bool attendanceAlerts = true;
  bool homeworkUpdates = false;
  bool holidayNotices = false;

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
                        color: const Color(0xFF003082),
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
                    AppSpacing.v48,
                    _buildImpactBanner(),
                    AppSpacing.v40,
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
                  color: const Color(0xFFE0E7FF),
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
          _buildTextField('••••••••••••••••••••••••••••••••', true),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instPhoneNumberId),
          AppSpacing.v12,
          _buildTextField('1059...', false),
          AppSpacing.v24,
          _buildInputLabel(AppStrings.instBusinessAccountId),
          AppSpacing.v12,
          _buildTextField('2941...', false),
          AppSpacing.v32,
          ElevatedButton(
            onPressed: () {},
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

  Widget _buildTextField(String hint, bool isPassword) {
    return Container(
      padding: AppSpacing.x16.add(AppSpacing.y18),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Text(
        hint,
        style: AppTextStyles.lexend(
          fontSize: AppSpacing.s14,
          color: AppColors.textSecondary,
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
            color: Color(0xFF1E40AF),
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
                    color: const Color(0xFF1E40AF),
                  ),
                ),
                AppSpacing.v8,
                Text(
                  AppStrings.instHowToFindDesc,
                  style: AppTextStyles.lexend(
                    fontSize: AppSpacing.s14,
                    height: 1.5,
                    color: const Color(0xFF1E40AF).withValues(alpha: 0.8),
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
              color: Color(0xFF003082),
              size: AppSpacing.s24,
            ),
            AppSpacing.h12,
            Text(
              AppStrings.instAutomatedAlerts,
              style: AppTextStyles.manrope(
                fontSize: AppSpacing.s20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF003082),
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
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Column(
            children: [
              _buildToggleItem(
                Icons.account_balance_wallet_rounded,
                const Color(0xFFFFE4E1),
                const Color(0xFFB91C1C),
                AppStrings.instFeesReminders,
                AppStrings.instFeesRemindersDesc,
                feesReminders,
                (v) => setState(() => feesReminders = v),
              ),
              _buildToggleItem(
                Icons.person_outline_rounded,
                const Color(0xFFE0E7FF),
                const Color(0xFF4338CA),
                AppStrings.instAttendanceAlerts,
                AppStrings.instAttendanceAlertsDesc,
                attendanceAlerts,
                (v) => setState(() => attendanceAlerts = v),
              ),
              _buildToggleItem(
                Icons.auto_stories_rounded,
                const Color(0xFFE0F2FE),
                const Color(0xFF0369A1),
                AppStrings.instHomeworkUpdates,
                AppStrings.instHomeworkUpdatesDesc,
                homeworkUpdates,
                (v) => setState(() => homeworkUpdates = v),
                showDivider: true,
              ),
              _buildToggleItem(
                Icons.campaign_rounded,
                const Color(0xFFF3F4F6),
                const Color(0xFF4B5563),
                AppStrings.instHolidayNotices,
                AppStrings.instHolidayNoticesDesc,
                holidayNotices,
                (v) => setState(() => holidayNotices = v),
                showDivider: false,
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
                activeTrackColor: const Color(0xFF1E40AF),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.s2,
            indent: AppSpacing.s88,
            color: Color(0xFFF3F4F6),
          ),
      ],
    );
  }

  Widget _buildImpactBanner() {
    return Column(
      children: [
        Text(
          AppStrings.instImpactQuote,
          textAlign: TextAlign.center,
          style: AppTextStyles.lexend(
            fontSize: AppSpacing.s14,
            height: 1.5,
            color: AppColors.textTertiary,
          ).copyWith(fontStyle: FontStyle.italic),
        ),
        AppSpacing.v24,
        Container(
          width: double.infinity,
          height: AppSpacing.s160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.s20),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&q=80&w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.s20),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
