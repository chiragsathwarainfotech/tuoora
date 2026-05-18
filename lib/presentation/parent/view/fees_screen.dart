import 'package:tuoora/core/widgets/parent_bottom_nav.dart';
import 'package:tuoora/core/widgets/portal_app_bar.dart';
import 'package:tuoora/core/widgets/section_header.dart';
import 'package:tuoora/core/widgets/payment_item_tile.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:get/get.dart';

class ParentFeesScreen extends StatelessWidget {
  final bool showBottomNav;
  const ParentFeesScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOutstandingBalanceCard(),
          AppSpacing.v32,
          _buildFeeBreakdownSection(),
          AppSpacing.v32,
          _buildRecentPaymentsSection(),
          AppSpacing.v24,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PortalAppBar(
        title: AppStrings.appName,
        profileRoute: AppRoutes.parentStudentProfile,
        notificationsRoute: AppRoutes.parentUpdates,
        notificationIcon: SvgPicture.asset(
          AppImages.icBell,
          height: AppSpacing.s24,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryBrand,
            BlendMode.srcIn,
          ),
        ),
      ),
      body: content,
      bottomNavigationBar: showBottomNav
          ? const ParentBottomNav(currentIndex: 2)
          : null,
    );
  }

  Widget _buildOutstandingBalanceCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0056D2), AppColors.primaryBrand],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.s32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0056D2).withValues(alpha: 0.3),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'OUTSTANDING BALANCE',
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.white.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
          AppSpacing.v12,
          Text(
            '₹2,450.00',
            style: AppTextStyles.manrope(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          AppSpacing.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today,
                size: AppSpacing.s14,
                color: Colors.white70,
              ),
              AppSpacing.h8,
              Text(
                'Due: October 15, 2023',
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          AppSpacing.v32,
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.parentPaymentQR),
            borderRadius: BorderRadius.circular(AppSpacing.s20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.s20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pay Now',
                    style: AppTextStyles.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                  AppSpacing.h12,
                  const Icon(
                    Icons.arrow_forward,
                    size: AppSpacing.s20,
                    color: AppColors.primaryBrand,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeBreakdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fee Breakdown',
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v20,
        _buildBreakdownCard(
          icon: AppImages.icTuition,
          title: 'Tuition Fees',
          subtitle: 'Academic Year 2023-24',
          amount: '₹1,800',
          iconBgColor: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
        ),
        AppSpacing.v16,
        _buildBreakdownCard(
          icon: AppImages.icTransport,
          title: 'Transport',
          subtitle: 'Quarterly Route A2',
          amount: '₹450',
          iconBgColor: AppColors.reportBorder,
          iconColor: const Color(0xFF475569),
        ),
        AppSpacing.v16,
        _buildBreakdownCard(
          icon: AppImages.icLab,
          title: 'Lab Fees',
          subtitle: 'Science & Robotics',
          amount: '₹200',
          iconBgColor: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFDC2626),
        ),
      ],
    );
  }

  Widget _buildBreakdownCard({
    required String icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s56,
            height: AppSpacing.s56,
            padding: AppSpacing.all14,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppSpacing.s16),
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v6,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s10,
                  vertical: AppSpacing.s4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.reportBorder,
                  borderRadius: BorderRadius.circular(AppSpacing.s8),
                ),
                child: Text(
                  'PENDING',
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentsSection() {
    return Column(
      children: [
        SectionHeader(
          title: 'Recent Payments',
          actionLabel: 'View All',
          onActionPressed: () => Get.toNamed(AppRoutes.parentRecentPayments),
        ),
        AppSpacing.v12,
        const PaymentItemTile(
          title: 'Tuition - Term 1',
          date: 'Sept 02, 2023',
          ref: '#AE-9921',
          amount: '₹1,800.00',
          showShadow: false,
        ),
        AppSpacing.v16,
        const PaymentItemTile(
          title: 'Annual Sports Fee',
          date: 'Aug 15, 2023',
          ref: '#AE-8840',
          amount: '₹150.00',
          showShadow: false,
        ),
        AppSpacing.v16,
        const PaymentItemTile(
          title: 'Registration Charges',
          date: 'Aug 01, 2023',
          ref: '#AE-8120',
          amount: '₹300.00',
          showShadow: false,
        ),
      ],
    );
  }
}
