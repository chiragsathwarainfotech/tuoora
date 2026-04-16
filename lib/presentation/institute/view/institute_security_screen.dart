import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class InstituteSecurityScreen extends StatelessWidget {
  const InstituteSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Security', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBreadcrumbHeader(),
                    AppSpacing.v32,
                    _buildUpdatePasswordCard(),
                    AppSpacing.v32,
                    _buildActiveSessionsSection(),
                    AppSpacing.v32,
                    _buildTwoFactorAuthCard(),
                    AppSpacing.v32,
                    _buildSecurityTipsCard(),
                    AppSpacing.v32,
                    _buildFooterBanner(),
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

  Widget _buildBreadcrumbHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Account',
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.h8,
            const Icon(
              Icons.chevron_right_rounded,
              size: AppSpacing.s16,
              color: AppColors.textMuted,
            ),
            AppSpacing.h8,
            Text(
              'Security',
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF003082),
              ),
            ),
          ],
        ),
        AppSpacing.v12,
        Text(
          AppStrings.instAccountSecurityTitle,
          style: AppTextStyles.manrope(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v12,
        Text(
          AppStrings.instSecurityDesc,
          style: AppTextStyles.lexend(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatePasswordCard() {
    return Container(
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
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
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.restore_rounded,
                  color: Color(0xFF1E40AF),
                  size: AppSpacing.s20,
                ),
              ),
              AppSpacing.h16,
              Text(
                AppStrings.instUpdatePasswordLabel,
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          _buildPasswordField(
            AppStrings.instCurrentPasswordLabel,
            '••••••••',
            true,
          ),
          AppSpacing.v24,
          _buildPasswordField(
            AppStrings.instNewPasswordLabel,
            'Min. 8 characters',
            false,
          ),
          AppSpacing.v24,
          _buildPasswordField(
            AppStrings.instConfirmPasswordLabel,
            'Repeat password',
            false,
          ),
          AppSpacing.v32,
          Row(
            children: [
              Text(
                '${AppStrings.instLastChangedPrefix} 3\nmonths ago',
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ).copyWith(fontStyle: FontStyle.italic),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004CB3),
                  foregroundColor: Colors.white,
                  padding: AppSpacing.x28.add(AppSpacing.y18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.instUpdatePasswordBtn,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, String hint, bool isFilled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDarkGrey,
          ),
        ),
        AppSpacing.v12,
        Container(
          padding: AppSpacing.x16.add(AppSpacing.y18),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: AppTextStyles.lexend(
                    fontSize: 14,
                    color: isFilled
                        ? AppColors.textSecondary
                        : AppColors.textMuted,
                  ),
                ),
              ),
              if (label == AppStrings.instCurrentPasswordLabel)
                const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.textTertiary,
                  size: AppSpacing.s20,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSessionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.instActiveSessions,
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              AppStrings.instLogoutAllDevices,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E40AF),
              ),
            ),
          ],
        ),
        AppSpacing.v20,
        _buildSessionItem(
          icon: Icons.laptop_mac_rounded,
          title: 'MacOS • Chrome Browser',
          subtitle: 'Mumbai, India • Active now',
          isCurrent: true,
        ),
        AppSpacing.v12,
        _buildSessionItem(
          icon: Icons.phone_iphone_rounded,
          title: 'iPhone 14 Pro • iOS App',
          subtitle: 'Pune, India • 2 days ago',
          isCurrent: false,
        ),
      ],
    );
  }

  Widget _buildSessionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCurrent,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF003082), size: AppSpacing.s24),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: AppSpacing.x10.add(AppSpacing.y4),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'CURRENT',
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E40AF),
                  letterSpacing: 0.5,
                ),
              ),
            )
          else
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFEF4444),
              size: AppSpacing.s20,
            ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorAuthCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        color: const Color(0xFF003D99),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.all10,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: AppSpacing.s24,
                ),
              ),
              const Spacer(),
              Switch(
                value: true,
                onChanged: (_) {},
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF60A5FA),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            AppStrings.instTwoFactorAuth,
            style: AppTextStyles.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          AppSpacing.v12,
          Text(
            AppStrings.instTwoFactorDesc,
            style: AppTextStyles.lexend(
              fontSize: 14,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
          AppSpacing.v32,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF34D399),
                  size: AppSpacing.s16,
                ),
                AppSpacing.h8,
                Text(
                  AppStrings.instSmsActive,
                  style: AppTextStyles.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v24,
          Center(
            child: Text(
              AppStrings.instSetupAuthApp,
              style:
                  AppTextStyles.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTipsCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_rounded,
                color: Color(0xFF7C2D12),
                size: AppSpacing.s20,
              ),
              AppSpacing.h12,
              Text(
                AppStrings.instProSecurityTips,
                style: AppTextStyles.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7C2D12),
                ),
              ),
            ],
          ),
          AppSpacing.v20,
          _buildTipItem(
            'Avoid repetition',
            "Don't use the same password for FeeEasy as your personal email.",
          ),
          AppSpacing.v16,
          _buildTipItem(
            'Complexity',
            "Use a mix of symbols (@#\$), numbers, and mixed-case letters.",
          ),
          AppSpacing.v16,
          _buildTipItem(
            'Periodic resets',
            "We recommend changing your admin password every 90 days.",
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String boldText, String normalText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: AppSpacing.top4,
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: AppSpacing.s16,
            color: Color(0xFFC2410C),
          ),
        ),
        AppSpacing.h12,
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.lexend(
                fontSize: 13,
                height: 1.5,
                color: const Color(0xFF7C2D12),
              ),
              children: [
                TextSpan(
                  text: '$boldText: ',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: normalText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterBanner() {
    return Container(
      width: double.infinity,
      height: AppSpacing.s60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=800',
          ),
          fit: BoxFit.cover,
          opacity: 0.9,
        ),
      ),
      child: Center(
        child: Container(
          padding: AppSpacing.x20.add(AppSpacing.y8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            AppStrings.instSecureInfrastructure,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
