import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_subscription_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
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
            const InstituteAppBar(title: AppStrings.subscriptionPlans, isRoot: false),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const CommonLoading();
                }

                final data = controller.subscriptionData.value;
                if (data == null) {
                  return Center(
                    child: Text(
                      AppStrings.failedToLoadSubscriptionData,
                      style: AppTextStyles.outfit(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchSubscriptionData(),
                  color: AppColors.primaryBrand,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActivePlanCard(data.subscription, data.history),
                        AppSpacing.v24,
                        _buildHeroHeader(),
                        AppSpacing.v20,
                        _buildPlansRow(data.plans, data.subscription),
                        AppSpacing.v24,
                        _buildFeatureCards(),
                        AppSpacing.v24,
                        _buildRecentBillingTable(data.history),
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

  Widget _buildActivePlanCard(
    SubscriptionDetails sub,
    List<SubscriptionHistory> history,
  ) {
    final isActive = sub.status.toLowerCase() == 'active';
    final latestAmount = history.isNotEmpty
        ? _formatPrice(history.first.amount)
        : '₹0';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [AppColors.instBrandOrange, AppColors.primaryBrand]
              : [AppColors.textSecondary, AppColors.textTertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? AppColors.primaryBrand.withValues(alpha: 0.3)
                : AppColors.textTertiary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.successBg.withValues(alpha: 0.30)
                  : AppColors.errorBg.withValues(alpha: 0.30),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? AppColors.greenText : AppColors.error,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: isActive ? AppColors.successGreen : AppColors.error,
                  size: 10,
                ),
                AppSpacing.h8,
                Text(
                  isActive ? 'ACTIVE PLAN' : 'NO ACTIVE PLAN',
                  style: AppTextStyles.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v16,
          Text(
            sub.planName,
            style: AppTextStyles.outfit(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          if (isActive && sub.expiresAt != null) ...[
            AppSpacing.v4,
            Text(
              'Expires on ${DateFormat.yMMMd().format(sub.expiresAt!)}',
              style: AppTextStyles.outfit(fontSize: 14, color: Colors.white70),
            ),
          ],
          AppSpacing.v16,
          Divider(color: AppColors.white.withValues(alpha: 0.2), height: 1),
          AppSpacing.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.latestBilling,
                style: AppTextStyles.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                latestAmount,
                style: AppTextStyles.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppStrings.instChooseBestPlan,
          textAlign: TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v8,
        Text(
          AppStrings.instScalableSolutions,
          textAlign: TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 13,
            color: AppColors.textTertiary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPlansRow(List<SubscriptionPlan> plans, SubscriptionDetails sub) {
    if (plans.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: plans.length,
        separatorBuilder: (_, _) => AppSpacing.h10,
        itemBuilder: (_, i) => _buildPlanCard(plans[i], sub),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, SubscriptionDetails sub) {
    final isCurrent =
        plan.name.trim().toLowerCase() == sub.planName.trim().toLowerCase();
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrent ? AppColors.primaryBrand : AppColors.fieldBorder,
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            plan.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.fieldLabel,
              letterSpacing: 1.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _formatPrice(plan.price),
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Text(
              '/${plan.durationDays} DAYS',
              style: AppTextStyles.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.fieldLabel,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String raw) {
    final clean = raw.replaceAll(',', '').trim();
    final value = double.tryParse(clean);
    if (value == null) return '₹$raw';
    final intVal = value.truncate();
    final formatter = NumberFormat.decimalPattern('en_IN');
    return '₹${formatter.format(intVal)}';
  }

  Widget _buildFeatureCards() {
    const items = [
      _Feature(
        icon: Icons.receipt_long_rounded,
        title: AppStrings.instAutomatedBilling,
        desc: AppStrings.instAutoBillingDesc,
      ),
      _Feature(
        icon: Icons.support_agent_rounded,
        title: AppStrings.instPrioritySupport,
        desc: AppStrings.instPrioritySupportDesc,
      ),
      _Feature(
        icon: Icons.chat_bubble_outline_rounded,
        title: AppStrings.instWhatsAppIntegration,
        desc: AppStrings.instWhatsAppOptionDesc,
      ),
    ];
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) AppSpacing.v10,
          _buildFeatureCard(items[i]),
        ],
      ],
    );
  }

  Widget _buildFeatureCard(_Feature f) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(f.icon, color: AppColors.primaryBrand, size: 22),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.title,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v2,
                Text(
                  f.desc,
                  style: AppTextStyles.outfit(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBillingTable(List<SubscriptionHistory> history) {
    if (history.isEmpty) return const SizedBox.shrink();
    final rows = history.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.cardPadding,
            child: Text(
              AppStrings.instRecentBilling,
              style: AppTextStyles.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.fieldBg,
            child: Row(
              children: const [
                Expanded(flex: 3, child: _ColHeader('DATE')),
                Expanded(flex: 3, child: _ColHeader('PLAN')),
                Expanded(flex: 3, child: _ColHeader('AMOUNT')),
                Expanded(flex: 2, child: _ColHeader('STATUS', end: true)),
              ],
            ),
          ),
          for (int i = 0; i < rows.length; i++)
            _buildBillingRow(rows[i], isLast: i == rows.length - 1),
        ],
      ),
    );
  }

  Widget _buildBillingRow(SubscriptionHistory item, {required bool isLast}) {
    final dateStr = item.startDate != null
        ? DateFormat('dd/MM/yyyy').format(item.startDate!)
        : '—';
    final statusActive = item.status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : AppColors.fieldBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              dateStr,
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.planName,
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              _formatPrice(item.amount),
              style: AppTextStyles.outfit(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusActive ? AppColors.successBg : AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: statusActive
                        ? AppColors.greenText
                        : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String desc;
  const _Feature({required this.icon, required this.title, required this.desc});
}

class _ColHeader extends StatelessWidget {
  final String text;
  final bool end;
  const _ColHeader(this.text, {this.end = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: end ? TextAlign.end : TextAlign.start,
      style: AppTextStyles.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.fieldLabel,
        letterSpacing: 1.1,
      ),
    );
  }
}
