import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/data/models/institute_profile_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/utils/url_launcher_utils.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/core/widgets/app_version_label.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tuoora/core/services/auth_service.dart';

class InstituteProfileViewScreen extends StatelessWidget {
  const InstituteProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InstituteProfileController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.instituteProfile,
              isRoot: false,
              actions: [
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.instituteEditProfile),
                  icon: const AppActionIcon(asset: AppImages.icEdit),
                ),
                AppSpacing.h8,
              ],
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.profile.value == null) {
                  return const CommonLoading();
                }

                final p = controller.profile.value;
                if (p == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                        AppSpacing.v16,
                        const Text(AppStrings.errFailedLoadProfile),
                        AppSpacing.v16,
                        ElevatedButton(
                          onPressed: () => controller.fetchProfile(),
                          child: const Text(AppStrings.labelRetry),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchProfile(),
                  color: AppColors.primaryBrand,
                  child: SingleChildScrollView(
                    padding: AppSpacing.all16,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeaderCard(p),
                        AppSpacing.v16,
                        _buildContactCard(p),
                        AppSpacing.v16,
                        _buildLocationCard(p),
                        AppSpacing.v16,
                        _buildUpiPaymentCard(controller),
                        AppSpacing.v16,
                        _buildAccountCard(context),
                        AppSpacing.v16,
                        _buildSupportCard(),
                        AppSpacing.v16,
                        _buildActivePlanCard(),
                        AppSpacing.v16,
                        _buildLogoutCard(context, controller),
                        AppSpacing.v24,
                        const AppVersionLabel(),
                        AppSpacing.v24,
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
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
      child: child,
    );
  }

  Widget _buildHeaderCard(InstituteProfile p) {
    return _card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBrandLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: p.logoUrl != null && p.logoUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: p.logoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildInitialsPlaceholder(p),
                        errorWidget: (context, url, error) =>
                            _buildInitialsPlaceholder(p),
                      )
                    : _buildInitialsPlaceholder(p),
              ),
            ),
            AppSpacing.v16,
            Text(
              p.instituteName ?? p.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v4,
            Text(
              'Owner: ${p.name}',
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.v4,
            Text(
              'Institute Code: ${p.instituteCode}',
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialsPlaceholder(InstituteProfile p) {
    String name = p.instituteName ?? p.name;
    String initials = 'IN';
    if (name.isNotEmpty) {
      List<String> parts = name.trim().split(RegExp(r'\s+'));
      if (parts.length > 1) {
        initials = '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      } else {
        initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
      }
    }
    return Center(
      child: Text(
        initials,
        style: AppTextStyles.outfit(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBrand,
        ),
      ),
    );
  }

  Widget _buildContactCard(dynamic p) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSectionHeader('Contact Information', Icons.contact_page_rounded),
          _buildInfoRow(Icons.email_outlined, 'Email', p.email),
          _buildInfoRow(Icons.phone_outlined, 'Phone', p.phone),
          if (p.website != null)
            _buildInfoRow(Icons.language_rounded, 'Website', p.website!),
        ],
      ),
    );
  }

  Widget _buildLocationCard(dynamic p) {
    final address = [
      p.address,
      p.addressLine2,
      p.city,
      p.state,
      p.pincode,
    ].where((e) => e != null && e.toString().isNotEmpty).join(', ');

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSectionHeader('Location Information', Icons.location_on_rounded),
          _buildInfoRow(
            Icons.map_outlined,
            'Address',
            address.isEmpty ? 'Not Provided' : address,
          ),
        ],
      ),
    );
  }

  Widget _buildUpiPaymentCard(InstituteProfileController controller) {
    return _card(
      child: Obx(() {
        final hasUpi = controller.hasUpiPayment;
        final qrUrl = controller.upiQrCodeUrl.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    size: 18,
                    color: AppColors.primaryBrand,
                  ),
                  AppSpacing.h8,
                  Expanded(
                    child: Text(
                      AppStrings.upiPaymentDetailsCardTitle,
                      style: AppTextStyles.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  if (hasUpi)
                    InkWell(
                      onTap: () =>
                          Get.toNamed(AppRoutes.instituteUpiPaymentSettings),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: AppColors.primaryBrand,
                            ),
                            AppSpacing.h4,
                            Text(
                              AppStrings.editSettings,
                              style: AppTextStyles.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBrand,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!hasUpi)
              _buildUpiEmptyState()
            else
              _buildUpiDetailsBody(controller.upiId.value, qrUrl),
          ],
        );
      }),
    );
  }

  Widget _buildUpiDetailsBody(String upiId, String? qrUrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.alternate_email_rounded, 'UPI ID', upiId),
          if (qrUrl != null && qrUrl.isNotEmpty) ...[
            AppSpacing.v12,
            Center(
              child: Container(
                padding: AppSpacing.all8,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.fieldBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: qrUrl,
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const SizedBox(
                      width: 160,
                      height: 160,
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => const SizedBox(
                      width: 160,
                      height: 160,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.v8,
            Center(
              child: Text(
                AppStrings.upiPaymentScanHint,
                style: AppTextStyles.outfit(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpiEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: AppColors.primaryBrand,
              size: 28,
            ),
          ),
          AppSpacing.v12,
          Text(
            AppStrings.upiPaymentEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          Text(
            AppStrings.upiPaymentEmptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.v12,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.toNamed(AppRoutes.instituteUpiPaymentSettings),
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
                color: AppColors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrand,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              label: Text(
                AppStrings.addPaymentDetails,
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSectionHeader('Account Information', Icons.settings_rounded),
          _buildSettingsItem(
            icon: Icons.lock_outline_rounded,
            title: AppStrings.labelChangePassword,
            subtitle: AppStrings.updateYourLoginCredentials,
            onTap: () => Get.toNamed(AppRoutes.instituteChangePassword),
          ),
          _buildSettingsItem(
            icon: Icons.workspace_premium_outlined,
            title: AppStrings.subscription,
            subtitle: AppStrings.manageYourActivePlan,
            onTap: () => Get.toNamed(AppRoutes.instituteSubscription),
          ),
          _buildSettingsItem(
            icon: Icons.chat_bubble_outline_rounded,
            title: AppStrings.instWhatsAppIntegration,
            subtitle: AppStrings.automateAlertsViaMetaApi,
            isComingSoon: true,
            onTap: () => _showWhatsAppComingSoonDialog(context),
          ),
          _buildSettingsItem(
            icon: Icons.qr_code_2_rounded,
            title: AppStrings.upiPaymentManageTile,
            subtitle: AppStrings.upiPaymentManageSubtitle,
            onTap: () => Get.toNamed(AppRoutes.instituteUpiPaymentSettings),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardSectionHeader('Support & Legal', Icons.info_outline_rounded),
          _buildSettingsItem(
            icon: Icons.description_outlined,
            title: AppStrings.termsConditions,
            subtitle: AppStrings.readOurTermsOfService,
            onTap: () =>
                UrlLauncherUtils.openExternal(AppStrings.urlTermsConditions),
          ),
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: AppStrings.privacyPolicy,
            subtitle: AppStrings.learnHowWeProtectYourData,
            onTap: () =>
                UrlLauncherUtils.openExternal(AppStrings.urlPrivacyPolicy),
          ),
          _buildSettingsItem(
            icon: Icons.help_center_outlined,
            title: AppStrings.helpCenter,
            subtitle: AppStrings.getAssistanceAndFaqs,
            onTap: () => AppSnackBar.warning(AppStrings.comingSoon),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(
    BuildContext context,
    InstituteProfileController controller,
  ) {
    return _card(
      child: _buildSettingsItem(
        icon: Icons.logout_rounded,
        title: AppStrings.logout,
        subtitle: AppStrings.signOutOfYourAccount,
        iconColor: AppColors.bohoRed,
        onTap: () => _showLogoutDialog(context, controller),
        isLast: true,
      ),
    );
  }

  // ------------------------------------------------------------- shared
  Widget _cardSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBrand),
          AppSpacing.h8,
          Text(
            title,
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                AppSpacing.v2,
                Text(
                  value,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    bool isLast = false,
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: EdgeInsets.fromLTRB(4, 8, 4, isLast ? 8 : 12),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.all8,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primaryBrand).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: iconColor ?? AppColors.primaryBrand,
              ),
            ),
            AppSpacing.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: iconColor ?? AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.outfit(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isComingSoon) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'COMING SOON',
                  style: AppTextStyles.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBrand,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.h8,
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    InstituteProfileController controller,
  ) {
    Get.dialog(
      AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        title: Text(
          AppStrings.logout,
          style: AppTextStyles.outfit(fontWeight: FontWeight.w600),
        ),
        content: Text(
          AppStrings.instituteProfileAreYouSureYouWantTo,
          style: AppTextStyles.outfit(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.labelCancel,
              style: AppTextStyles.outfit(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBrand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
            ),
            child: Text(
              AppStrings.logout,
              style: AppTextStyles.outfit(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePlanCard() {
    return Obx(() {
      final authService = Get.find<AuthService>();
      final sub = authService.subscription;
      if (sub == null) return const SizedBox.shrink();

      final int daysLeft = sub.daysLeft;
      final bool isExpiringSoon = sub.isExpireSoon;
      final dateFormat = DateFormat('dd MMM yyyy');

      Color statusColor = AppColors.successGreen;
      IconData statusIcon = Icons.verified_rounded;

      if (sub.isPending) {
        statusColor = AppColors.warningAmber;
        statusIcon = Icons.autorenew_rounded;
      } else if (sub.isReject || sub.isCancel || sub.isExpired) {
        statusColor = AppColors.errorRed;
        statusIcon = Icons.error_outline_rounded;
      }

      return _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Active Plan',
                  style: AppTextStyles.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
              ],
            ),
            AppSpacing.v8,
            Text(
              sub.planName.toUpperCase(),
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
            AppSpacing.v16,
            if (sub.endDate != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrandLight,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.cardRadius,
                        ),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
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
                            'REMAINING',
                            style: AppTextStyles.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          AppSpacing.v4,
                          Text(
                            '$daysLeft days remaining — expires ${dateFormat.format(sub.endDate!)}',
                            style: AppTextStyles.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isExpiringSoon) ...[
                AppSpacing.v12,
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    border: Border.all(
                      color: AppColors.warningAmber.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrandLight,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.cardRadius,
                          ),
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
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
                              'EXPIRING SOON',
                              style: AppTextStyles.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBrand,
                                letterSpacing: 0.8,
                              ),
                            ),
                            AppSpacing.v4,
                            Text(
                              'Expires in $daysLeft days — Renew now to avoid interruption',
                              style: AppTextStyles.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBrand,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      );
    });
  }

  void _showWhatsAppComingSoonDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        child: Container(
          padding: AppSpacing.all24,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              AppSpacing.v12,
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadius,
                      ),
                    ),
                  ),
                  SvgPicture.asset(AppImages.icWhatsapp, width: 48, height: 48),
                ],
              ),
              AppSpacing.v20,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: Text(
                  'COMING SOON',
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              AppSpacing.v20,
              Text(
                'WhatsApp Integration',
                style: AppTextStyles.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v16,
              Text(
                'We\'re building a direct integration with the Meta WhatsApp Cloud API. Soon you\'ll be able to send fee reminders, receipts, and daily updates straight to parents\' phones.',
                textAlign: TextAlign.center,
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
              AppSpacing.v32,
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkSlate,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                ),
                child: Text(
                  'GOT IT',
                  style: AppTextStyles.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
