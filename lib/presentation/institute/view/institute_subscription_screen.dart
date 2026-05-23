import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InstituteSubscriptionScreen
    extends GetView<InstituteSubscriptionController> {
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBrand,
                    ),
                  );
                }

                final data = controller.subscriptionData.value;
                if (data == null) {
                  return Center(
                    child: Text(
                      'Failed to load subscription data.',
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: AppSpacing.all24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildActivePlanCard(data.subscription, data.history),
                      AppSpacing.v24,
                      _buildChoosePlanSection(data.plans),
                      AppSpacing.v24,
                      _buildRecentBilling(data.history),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard(
    SubscriptionDetails sub,
    List<SubscriptionHistory> history,
  ) {
    final isActive = sub.status.toLowerCase() == 'active';
    final String amount;
    if (isActive && history.isNotEmpty) {
      amount = sub.studentLimit.toString();
    } else {
      amount = '0';
    }
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [AppColors.brandAppBarColor, AppColors.primaryBrand]
              : [AppColors.textSecondary, AppColors.textTertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.primaryBrand.withValues(alpha: 0.3)
                : AppColors.textTertiary.withValues(alpha: 0.3),
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
                  color: isActive
                      ? AppColors.successBg.withValues(alpha: 0.30)
                      : AppColors.errorBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s20),
                  border: Border.all(
                    color: isActive ? AppColors.darkGreen : AppColors.error,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: isActive
                          ? AppColors.successGreen
                          : AppColors.error,
                      size: AppSpacing.s10,
                    ),
                    AppSpacing.h8,
                    Text(
                      isActive ? 'ACTIVE PLAN' : 'NO ACTIVE PLAN',
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          Text(
            sub.planName,
            style: AppTextStyles.manrope(
              fontSize: AppSpacing.s32,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          if (isActive && sub.expiresAt != null)
            Text(
              'Expires on ${DateFormat.yMMMd().format(sub.expiresAt!)}',
              style: AppTextStyles.lexend(
                fontSize: AppSpacing.s14,
                color: Colors.white70,
              ),
            ),
          AppSpacing.v12,
          const Divider(color: Colors.white10),
          AppSpacing.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LATEST BILLING',
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: amount,
                      style: AppTextStyles.manrope(
                        fontSize: AppSpacing.s24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
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

  Widget _buildChoosePlanSection(List<SubscriptionPlan> plans) {
    if (plans.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Plans',
          style: AppTextStyles.manrope(
            fontSize: AppSpacing.s20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
        AppSpacing.v24,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: plans.map((plan) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _buildPlanCard(plan),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    return Container(
      width: AppSpacing.s260,
      padding: AppSpacing.all28,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.name,
            style: AppTextStyles.manrope(
              fontSize: AppSpacing.s22,
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.v4,
          Text(
            'Days: ${plan.durationDays}',
            style: AppTextStyles.lexend(
              fontSize: AppSpacing.s14,
              color: AppColors.blueSapphire,
            ),
          ),
          AppSpacing.v12,
          Text(
            plan.price,
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
            ),
          ),
          AppSpacing.v12,
          if (plan.trialDays > 0)
            Padding(
              padding: AppSpacing.bottom16,
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primaryBrand,
                    size: AppSpacing.s18,
                  ),
                  AppSpacing.h12,
                  Text(
                    'Trial Days: ${plan.trialDays}',
                    style: AppTextStyles.lexend(
                      fontSize: AppSpacing.s14,
                      color: AppColors.blueSapphire,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: AppSpacing.bottom16,
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryBrand,
                  size: AppSpacing.s18,
                ),
                AppSpacing.h12,
                Text(
                  plan.status == 1 ? 'Active Plan' : 'Inactive Plan',
                  style: AppTextStyles.lexend(
                    fontSize: AppSpacing.s14,
                    color: AppColors.blueSapphire,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBilling(List<SubscriptionHistory> history) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instRecentBilling,
          style: AppTextStyles.manrope(
            fontSize: AppSpacing.s18,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
        AppSpacing.v24,
        ...history.take(3).map((item) {
          return Padding(
            padding: AppSpacing.bottom12,
            child: _buildBillingItem(item),
          );
        }),
      ],
    );
  }

  Widget _buildBillingItem(SubscriptionHistory item) {
    final dateStr = item.startDate != null
        ? DateFormat('MMM d, y').format(item.startDate!).toUpperCase()
        : 'UNKNOWN DATE';

    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.all10,
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
              borderRadius: BorderRadius.circular(AppSpacing.s10),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: AppColors.primaryBrand,
              size: AppSpacing.s20,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.planName,
                  style: AppTextStyles.manrope(
                    fontSize: AppSpacing.s14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brandAppBarColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateStr,
                  style: AppTextStyles.lexend(
                    fontSize: AppSpacing.s12,
                    color: AppColors.blueSapphire,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: AppTextStyles.manrope(
                  fontSize: AppSpacing.s14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandAppBarColor,
                ),
              ),
              Container(
                padding: AppSpacing.x6.add(AppSpacing.y2),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppSpacing.s4),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: AppTextStyles.manrope(
                    fontSize: AppSpacing.s10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.successGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
