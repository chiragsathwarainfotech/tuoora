import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/controllers/fees_controller.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/widgets/student_section_header.dart';

class StudentFeesScreen extends GetView<FeesController> {
  final bool showBottomNav;

  const StudentFeesScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StudentAppBar(
              title: AppStrings.studentFeesTitle,
              isRoot: true,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.statements.isEmpty) {
                  return const CommonLoading(color: AppColors.primaryBrand);
                }
                return RefreshIndicator(
                  color: AppColors.primaryBrand,
                  onRefresh: controller.loadFees,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppSpacing.screenPaddingTop,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SummaryCard(summary: controller.summary.value),
                        const SizedBox(height: AppSpacing.s12),
                        _PayNowButton(
                          pendingAmount:
                              controller.summary.value.pendingInRupees,
                          onTap: controller.summary.value.pendingInRupees > 0
                              ? controller.openPayFees
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.s24),
                        const StudentSectionHeader(
                          title: AppStrings.studentFeesStatementsTitle,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        if (controller.statements.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.s24,
                            ),
                            child: AppEmptyView(
                              icon: Icons.receipt_long_outlined,
                              title: 'No fee statements yet',
                              message:
                                  'Your statements will appear here once your institute generates them.',
                            ),
                          )
                        else
                          Column(
                            children: [
                              for (
                                var i = 0;
                                i < controller.statements.length;
                                i++
                              ) ...[
                                if (i > 0)
                                  const SizedBox(height: AppSpacing.s10),
                                _StatementRow(
                                  statement: controller.statements[i],
                                  onTap: () => controller.openReceipt(
                                    controller.statements[i],
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 2)
          : null,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final FeeSummary summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _PaidProgressRing(percent: summary.paidPercent),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${DateTime.now().year} LEDGER',
                      style: AppTextStyles.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_formatThousands(summary.totalInRupees)}',
                      style: AppTextStyles.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.studentFeesBilledAcross} '
                      '${summary.billedMonths} ${AppStrings.studentFeesMonths}',
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          _SplitProgressBar(
            paid: summary.paidInRupees,
            pending: summary.pendingInRupees,
          ),
          const SizedBox(height: AppSpacing.s10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _LegendDot(color: AppColors.successGreen),
              const SizedBox(width: 6),
              Text(
                '${AppStrings.studentFeesPaidPercent} '
                '₹${_formatThousands(summary.paidInRupees)}',
                style: AppTextStyles.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.h16,
              _LegendDot(color: AppColors.orangeTag),
              const SizedBox(width: 6),
              Text(
                '${AppStrings.studentFeesLegendPending} '
                '₹${_formatThousands(summary.pendingInRupees)}',
                style: AppTextStyles.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaidProgressRing extends StatelessWidget {
  final int percent;

  const _PaidProgressRing({required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _RingPainter(percent: percent),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Text(
                AppStrings.studentFeesPaidPercent,
                style: AppTextStyles.outfit(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final int percent;

  _RingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 5.0;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - stroke) / 2,
    );
    final track = Paint()
      ..color = AppColors.primaryBrandLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    if (percent <= 0) return;
    final progress = Paint()
      ..color = AppColors.primaryBrand
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final sweep = (percent.clamp(0, 100) / 100) * 2 * math.pi;
    canvas.drawArc(rect, -math.pi / 2, sweep, false, progress);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.percent != percent;
}

class _SplitProgressBar extends StatelessWidget {
  final int paid;
  final int pending;

  const _SplitProgressBar({required this.paid, required this.pending});

  @override
  Widget build(BuildContext context) {
    final paidFlex = paid;
    final pendingFlex = pending;
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 6,
        child: Row(
          children: [
            Expanded(
              flex: paidFlex == 0 ? 0 : paidFlex,
              child: const ColoredBox(color: AppColors.successGreen),
            ),
            Expanded(
              flex: pendingFlex == 0 ? 0 : pendingFlex,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBrand,
                      AppColors.primaryBrandLight,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _PayNowButton extends StatelessWidget {
  final int pendingAmount;
  final VoidCallback? onTap;

  const _PayNowButton({required this.pendingAmount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: disabled
          ? AppColors.primaryBrand.withValues(alpha: 0.4)
          : AppColors.primaryBrand,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s14,
            horizontal: AppSpacing.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.currency_rupee_rounded,
                size: 18,
                color: AppColors.white,
              ),
              AppSpacing.h8,
              Text(
                '${AppStrings.studentFeesPayNowPrefix}${_formatThousands(pendingAmount)} ${AppStrings.studentFeesPayNowSuffix}',
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatementRow extends StatelessWidget {
  final FeeStatement statement;
  final VoidCallback onTap;

  const _StatementRow({required this.statement, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          padding: AppSpacing.cardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _StatusDot(isPaid: statement.isPaid),
              AppSpacing.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: statement.periodLabel,
                            style: AppTextStyles.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: '  ${statement.id}',
                            style: AppTextStyles.outfit(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statement.dateLabel,
                      style: AppTextStyles.outfit(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppSpacing.h8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹${_formatThousands(statement.amountInRupees)}',
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _StatusPill(isPaid: statement.isPaid),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool isPaid;

  const _StatusDot({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? AppColors.successGreen : AppColors.orangeTag;
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: isPaid ? color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isPaid;

  const _StatusPill({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final bg = isPaid ? AppColors.successGreen : AppColors.bohoRed;
    final label = isPaid
        ? AppStrings.instStatusPaid
        : AppStrings.studentAssignmentsTabPending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }
}

String _formatThousands(int value) {
  if (value < 1000) return value.toString();
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}
