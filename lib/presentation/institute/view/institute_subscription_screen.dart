import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_routes.dart';

class InstituteSubscriptionScreen extends StatelessWidget {
  const InstituteSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Subscription', isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActivePlanCard(),
                    AppSpacing.v32,
                    _buildUsageCapacity(),
                    AppSpacing.v40,
                    _buildChoosePlanSection(),
                    AppSpacing.v48,
                    _buildIncludedBenefits(),
                    AppSpacing.v48,
                    _buildRecentBilling(),
                    AppSpacing.v40,
                    _buildFooterButton(),
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

  Widget _buildActivePlanCard() {
    return Container(
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: const Color(0xFF004494),
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003D99).withValues(alpha: 0.2),
            blurRadius: AppSpacing.s20,
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
              Container(
                padding: AppSpacing.x14.add(AppSpacing.y8),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.s20),
                  border: Border.all(
                    color: const Color(0xFF4ADE80).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Color(0xFF4ADE80),
                      size: AppSpacing.s10,
                    ),
                    AppSpacing.h8,
                    Text(
                      'ACTIVE PLAN',
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: AppSpacing.s2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          Text(
            AppStrings.instCurrentPremium,
            style: AppTextStyles.manrope(
              fontSize: AppSpacing.s32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            'Renews on Oct 24, 2024',
            style: AppTextStyles.lexend(
              fontSize: AppSpacing.s14,
              color: Colors.white70,
            ),
          ),
          AppSpacing.v32,
          const Divider(color: Colors.white10),
          AppSpacing.v20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ANNUAL BILLING',
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white60,
                  letterSpacing: 0.5,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$4,990',
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: '/yr',
                      style: AppTextStyles.lexend(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCapacity() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.instUsageCapacity,
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '84%',
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
          AppSpacing.v20,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.s10),
            child: const LinearProgressIndicator(
              value: 0.84,
              minHeight: AppSpacing.s12,
              backgroundColor: Color(0xFFF3F4F6),
              color: Color(0xFF1E40AF),
            ),
          ),
          AppSpacing.v20,
          Row(
            children: [
              const Icon(
                Icons.group_rounded,
                size: AppSpacing.s18,
                color: AppColors.textTertiary,
              ),
              AppSpacing.h8,
              Text(
                '8,400 of 10,000 students enrolled',
                style: AppTextStyles.lexend(
                  fontSize: AppSpacing.s14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoosePlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instChooseYourPlan,
          style: AppTextStyles.manrope(
            fontSize: AppSpacing.s20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v24,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPlanCard(
                title: 'Basic',
                desc: 'For small coaching centers',
                price: '99',
                features: ['Up to 500 students', 'Basic SMS alerts'],
                isPremium: false,
              ),
              AppSpacing.h20,
              _buildPlanCard(
                title: 'Pro',
                desc: 'Growing institutes',
                price: '249',
                features: [
                  'Up to 2,000 students',
                  'Advanced reports',
                  'Custom Branding',
                ],
                isPremium: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String desc,
    required String price,
    required List<String> features,
    required bool isPremium,
  }) {
    return Container(
      width: AppSpacing.s260,
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.manrope(
              fontSize: AppSpacing.s22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          Text(
            desc,
            style: AppTextStyles.lexend(
              fontSize: AppSpacing.s14,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.v24,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '\$$price',
                  style: AppTextStyles.manrope(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: ' /mo',
                  style: AppTextStyles.lexend(
                    fontSize: AppSpacing.s14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v32,
          ...features.map(
            (f) => Padding(
              padding: AppSpacing.bottom16,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF003082),
                    size: AppSpacing.s18,
                  ),
                  AppSpacing.h12,
                  Text(
                    f,
                    style: AppTextStyles.lexend(
                      fontSize: AppSpacing.s14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.v24,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: isPremium
                    ? const Color(0xFF004494)
                    : Colors.transparent,
                side: const BorderSide(color: Color(0xFF004494)),
                padding: AppSpacing.y14,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
              ),
              child: Text(
                isPremium ? 'Upgrade to Pro' : 'Switch to Basic',
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s14,
                  fontWeight: FontWeight.w800,
                  color: isPremium ? Colors.white : const Color(0xFF004494),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instIncludedBenefits,
          style: AppTextStyles.manrope(
            fontSize: AppSpacing.s18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v24,
        _buildBenefitItem(
          Icons.bolt_rounded,
          AppStrings.instAutomatedBilling,
          AppStrings.instAutoBillingDesc,
        ),
        AppSpacing.v12,
        _buildBenefitItem(
          Icons.headset_mic_rounded,
          AppStrings.instPrioritySupport,
          AppStrings.instPrioritySupportDesc,
        ),
        AppSpacing.v12,
        _buildBenefitItem(
          Icons.chat_bubble_rounded,
          AppStrings.instWhatsAppOption,
          AppStrings.instWhatsAppOptionDesc,
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F9FF),
              borderRadius: BorderRadius.circular(AppSpacing.s10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E40AF),
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
        ],
      ),
    );
  }

  Widget _buildRecentBilling() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.instRecentBilling,
              style: AppTextStyles.manrope(
                fontSize: AppSpacing.s18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.instituteBillingHistory),
              child: Text(
                'VIEW ALL',
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s12,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E40AF),
                  letterSpacing: AppSpacing.s2,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.v24,
        _buildBillingItem('INV-98231', 'SEP 24, 2023', '499.00'),
        AppSpacing.v12,
        _buildBillingItem('INV-97420', 'AUG 24, 2023', '499.00'),
      ],
    );
  }

  Widget _buildBillingItem(String id, String date, String amount) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(AppSpacing.s10),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: AppColors.textTertiary,
              size: AppSpacing.s20,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: AppTextStyles.manrope(
                    fontSize: AppSpacing.s14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  date,
                  style: AppTextStyles.lexend(
                    fontSize: AppSpacing.s12,
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
                '\$$amount',
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: AppSpacing.x6.add(AppSpacing.y2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(AppSpacing.s4),
                ),
                child: Text(
                  'PAID',
                  style: AppTextStyles.manrope(
                    fontSize: AppSpacing.s10,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: const Color(0xFF003D99),
        borderRadius: BorderRadius.circular(AppSpacing.s16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.upgrade_rounded,
            color: Colors.white,
            size: AppSpacing.s20,
          ),
          AppSpacing.h8,
          Text(
            AppStrings.instRenewUpgradeBtn,
            style: AppTextStyles.manrope(
              fontSize: AppSpacing.s16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
