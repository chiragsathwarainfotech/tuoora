import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepBlue),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Student Profile',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.deepBlue,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.x24.add(AppSpacing.y32),
        child: Column(
          children: [
            _buildProfileHeroCard(),
            AppSpacing.v32,
            _buildAdministrativeLockNotice(),
            AppSpacing.v32,
            _buildAcademicDetails(),
            AppSpacing.v16,
            _buildPersonalDetails(),
            AppSpacing.v40,
            _buildSignOutSection(),
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeroCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0056D2), AppColors.primaryBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0056D2).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STUDENT IDENTIFICATION',
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1.0,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    'Student Profile',
                    style: AppTextStyles.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: AppSpacing.s14,
                    ),
                    AppSpacing.h6,
                    Text(
                      'VERIFIED',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Container(
                width: AppSpacing.s100,
                height: AppSpacing.s100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: AppSpacing.s4,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/julian_profile.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppSpacing.h20,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Julian Sterling',
                      style: AppTextStyles.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    AppSpacing.v4,
                    Text(
                      'Class of 2024',
                      style: AppTextStyles.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.qr_code_2,
                color: Colors.white,
                size: AppSpacing.s32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdministrativeLockNotice() {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.lightBlueBg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_person_outlined,
            color: Color(0xFF2563EB),
            size: AppSpacing.s20,
          ),
          AppSpacing.h12,
          Expanded(
            child: Text(
              'Profile details are managed by the administration. Contact the office for updates.',
              style: AppTextStyles.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.oceanBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Details',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v20,
        Container(
          padding: AppSpacing.all32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, AppSpacing.s4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoRow(
                'FULL LEGAL NAME',
                'Julian Alexander Sterling',
                icon: Icons.badge_outlined,
              ),
              const Divider(
                height: AppSpacing.s48,
                thickness: 1,
                color: AppColors.reportBorder,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildPersonalInfoRow(
                      'DATE OF BIRTH',
                      'March 14, 2007',
                    ),
                  ),
                  Expanded(
                    child: _buildPersonalInfoRow(
                      'NATIONALITY',
                      'United Kingdom',
                      alignment: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: AppSpacing.s48,
                thickness: 1,
                color: AppColors.reportBorder,
              ),
              _buildPersonalInfoRow(
                'RESIDENTIAL ADDRESS',
                '42 Kensington High Street,\nLondon, W8 4SG,\nUnited Kingdom',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Academic Details',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: AppSpacing.x12.add(AppSpacing.y6),
              decoration: BoxDecoration(
                color: AppColors.indigoLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'OFFICIAL RECORD',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: AppColors.intenseBlue,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.v20,
        _buildDetailCard(
          icon: Icons.school_outlined,
          label: 'CURRENT GRADE',
          value: 'Grade 11 - Honours',
        ),
        AppSpacing.v16,
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                label: 'SECTION',
                value: 'A-Alpha',
                small: true,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: _buildDetailCard(
                label: 'ENROLLMENT ID',
                value: '#AEON-2024-8821',
                small: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    IconData? icon,
    required String label,
    required String value,
    bool small = false,
  }) {
    return Container(
      padding: EdgeInsets.all(small ? AppSpacing.s20 : AppSpacing.s24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Row(
        children: [
          icon != null
              ? Container(
                  padding: AppSpacing.all12,
                  decoration: BoxDecoration(
                    color: AppColors.reportBorder,
                    borderRadius: BorderRadius.circular(AppSpacing.s16),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF475569),
                    size: AppSpacing.s24,
                  ),
                )
              : SizedBox.shrink(),
          AppSpacing.h20,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  value,
                  style: AppTextStyles.manrope(
                    fontSize: small ? 14 : 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkSlate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoRow(
    String label,
    String value, {
    IconData? icon,
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisAlignment: alignment == CrossAxisAlignment.start
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: AppTextStyles.manrope(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            if (icon != null) ...[
              AppSpacing.h8,
              Icon(icon, color: const Color(0xFFCBD5E1), size: AppSpacing.s16),
            ],
          ],
        ),
        AppSpacing.v8,
        Text(
          value,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.darkSlate,
            height: 1.4,
          ),
          textAlign: alignment == CrossAxisAlignment.start
              ? TextAlign.left
              : TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildSignOutSection() {
    return InkWell(
      onTap: () async {
        final authService = Get.find<AuthService>();
        await authService.clearSession();
        Get.offAllNamed(AppRoutes.roleSelection);
      },
      child: Container(
        padding: AppSpacing.all24,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(AppSpacing.s24),
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.all12,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.redDot,
                size: AppSpacing.s20,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign Out',
                    style: AppTextStyles.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.redDot,
                    ),
                  ),
                  Text(
                    'Securely terminate session',
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.errorRed.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
