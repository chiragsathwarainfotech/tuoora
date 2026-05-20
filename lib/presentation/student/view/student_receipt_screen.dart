import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/controllers/fees_controller.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentReceiptScreen extends GetView<FeesController> {
  const StudentReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final statement = controller.selectedStatement.value;
          if (statement == null) {
            return const Center(child: Text('No receipt selected'));
          }
          return _Body(
            statement: statement,
            profile: controller.billingProfile.value,
          );
        }),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final FeeStatement statement;
  final StudentBillingProfile profile;

  const _Body({required this.statement, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StudentAppBar(
          title: AppStrings.studentReceiptTitle,
          showDefaultActions: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s4,
              AppSpacing.s16,
              AppSpacing.s24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReceiptCard(statement: statement, profile: profile),
                const SizedBox(height: AppSpacing.s12),
                const _ActionRow(),
                const SizedBox(height: AppSpacing.s16),
                Center(
                  child: Text(
                    AppStrings.studentReceiptFooter,
                    style: AppTextStyles.lexend(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final FeeStatement statement;
  final StudentBillingProfile profile;

  const _ReceiptCard({required this.statement, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statement.monthHeader,
              style: AppTextStyles.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '₹${_formatThousands(statement.amountInRupees)}',
                    style: AppTextStyles.manrope(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                ),
                _StatusPill(isPaid: statement.isPaid),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            _DashedDivider(color: AppColors.borderGrey.withValues(alpha: 0.8)),
            _DetailRow(
              label: AppStrings.studentReceiptStudent,
              value: profile.studentName,
            ),
            _DetailRow(
              label: AppStrings.studentReceiptRollNo,
              value: profile.rollNumber,
            ),
            _DetailRow(
              label: AppStrings.studentReceiptInstitute,
              value: profile.instituteName,
            ),
            _DetailRow(
              label: AppStrings.studentReceiptInvoiceNo,
              value: statement.id,
            ),
            _DetailRow(
              label: AppStrings.studentReceiptPeriod,
              value: statement.periodLabel,
            ),
            _DetailRow(
              label: AppStrings.studentReceiptDueDate,
              value: statement.dueDateShort,
            ),
            if (statement.lateFeeLabel != null)
              _DetailRow(
                label: AppStrings.studentReceiptLateFee,
                value: statement.lateFeeLabel!,
                isLast: true,
                valueColor: AppColors.studentBrand,
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              AppSpacing.h8,
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: valueColor ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: AppColors.borderGrey.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            );
          }),
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isPaid;

  const _StatusPill({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final bg = isPaid
        ? AppColors.studentDonePillBg
        : AppColors.studentTodayPillBg;
    final fg = isPaid
        ? AppColors.studentDonePillText
        : AppColors.studentBrandAccent;
    final label = isPaid
        ? AppStrings.studentFeesPillPaid
        : AppStrings.studentFeesPillPending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: AppTextStyles.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────── Action row

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: AppStrings.studentReceiptDownload,
            icon: Icons.download_rounded,
            isPrimary: false,
            onTap: () => Get.snackbar(
              AppStrings.studentReceiptDownload,
              AppStrings.studentAttachmentDownloadStarted,
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
        ),
        AppSpacing.h12,
        Expanded(
          child: _ActionButton(
            label: AppStrings.studentReceiptContact,
            icon: Icons.call_rounded,
            isPrimary: true,
            onTap: () => Get.snackbar(
              AppStrings.studentReceiptContact,
              'Calling institute…',
              snackPosition: SnackPosition.BOTTOM,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPrimary ? AppColors.attachmentShareButton : AppColors.white;
    final fg = isPrimary ? AppColors.white : AppColors.textPrimary;
    final border = Border.all(
      color: isPrimary ? AppColors.attachmentShareButton : AppColors.borderGrey,
    );
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.s12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSpacing.s12),
            border: border,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s14,
            vertical: AppSpacing.s12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fg),
              AppSpacing.h8,
              Text(
                label,
                style: AppTextStyles.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ],
          ),
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
