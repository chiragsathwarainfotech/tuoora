import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/controllers/fees_controller.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

/// Student → Fees → Pay fees.
///
/// Shows the outstanding amount, the institute's UPI QR + handle, and
/// quick-launch buttons for Google Pay / PhonePe / Paytm. The "Open in
/// Google Pay" CTA + the three app buttons currently snackbar — wire
/// `url_launcher` with the right UPI intent URL once you have a payee
/// merchant code.
class StudentPayFeesScreen extends GetView<FeesController> {
  const StudentPayFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final summary = controller.summary.value;
          final profile = controller.billingProfile.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StudentAppBar(
                title: AppStrings.studentPayFeesTitle,
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
                      _OutstandingCard(summary: summary),
                      const SizedBox(height: AppSpacing.s12),
                      _UpiCard(
                        profile: profile,
                        onCopy: controller.copyUpiHandle,
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      _OpenInGooglePayButton(
                        onTap: () => Get.snackbar(
                          AppStrings.studentPayFeesOpenInGooglePay,
                          profile.instituteUpiHandle,
                          snackPosition: SnackPosition.BOTTOM,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      _PaymentAppRow(profile: profile),
                      const SizedBox(height: AppSpacing.s16),
                      _HowItWorksCard(profile: profile, summary: summary),
                      const SizedBox(height: AppSpacing.s12),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s8,
                        ),
                        child: Text(
                          AppStrings.studentPayFeesDisclaimer,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.lexend(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────── Outstanding

class _OutstandingCard extends StatelessWidget {
  final FeeSummary summary;

  const _OutstandingCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.studentBrand,
        borderRadius: BorderRadius.circular(AppSpacing.s14),
      ),
      child: Stack(
        children: [
          // ₹ watermark on the right side.
          Positioned(
            right: -8,
            top: 8,
            bottom: 8,
            child: Opacity(
              opacity: 0.15,
              child: Text(
                '₹',
                style: AppTextStyles.manrope(
                  fontSize: 120,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  height: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.studentPayFeesOutstanding,
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${_formatThousands(summary.pendingInRupees)}',
                  style: AppTextStyles.manrope(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary.pendingMonthsLabel,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── UPI / QR card

class _UpiCard extends StatelessWidget {
  final StudentBillingProfile profile;
  final VoidCallback onCopy;

  const _UpiCard({required this.profile, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppStrings.studentPayFeesScanWith,
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          _QrPlaceholder(seed: profile.instituteUpiHandle),
          const SizedBox(height: AppSpacing.s12),
          Text(
            profile.instituteName,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onCopy,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.instituteUpiHandle,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.copy_rounded,
                    size: 12,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  final String seed;

  const _QrPlaceholder({required this.seed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderGrey, width: 1.5),
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: SizedBox(
        width: 180,
        height: 180,
        child: CustomPaint(
          painter: _QrLikePainter(seed: seed),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  'T',
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.studentBrand,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Renders a QR-code-looking grid of black squares + 3 finder rectangles.
/// This is purely visual — it does NOT encode the UPI handle. Plug in the
/// `qr_flutter` package and replace this widget with `QrImageView` when
/// you have a real payee VPA / amount to encode.
class _QrLikePainter extends CustomPainter {
  final String seed;

  _QrLikePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    const cells = 21;
    final cell = size.width / cells;
    final rng = math.Random(seed.hashCode);
    for (var y = 0; y < cells; y++) {
      for (var x = 0; x < cells; x++) {
        if (_isFinderArea(x, y, cells)) continue;
        if (rng.nextBool() && rng.nextBool()) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
        }
      }
    }
    // Three finder squares (top-left, top-right, bottom-left).
    _drawFinder(canvas, paint, 0, 0, cell);
    _drawFinder(canvas, paint, (cells - 7) * cell, 0, cell);
    _drawFinder(canvas, paint, 0, (cells - 7) * cell, cell);
  }

  bool _isFinderArea(int x, int y, int cells) {
    final inTopLeft = x < 7 && y < 7;
    final inTopRight = x >= cells - 7 && y < 7;
    final inBottomLeft = x < 7 && y >= cells - 7;
    return inTopLeft || inTopRight || inBottomLeft;
  }

  void _drawFinder(Canvas canvas, Paint paint, double x, double y, double c) {
    // 7x7 outer black, 5x5 inner white, 3x3 inner black.
    canvas.drawRect(Rect.fromLTWH(x, y, c * 7, c * 7), paint);
    final inner = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(x + c, y + c, c * 5, c * 5), inner);
    canvas.drawRect(Rect.fromLTWH(x + 2 * c, y + 2 * c, c * 3, c * 3), paint);
  }

  @override
  bool shouldRepaint(covariant _QrLikePainter oldDelegate) =>
      oldDelegate.seed != seed;
}

// ───────────────────────────────────────────────────────── GPay button

class _OpenInGooglePayButton extends StatelessWidget {
  final VoidCallback onTap;

  const _OpenInGooglePayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.attachmentShareButton,
      borderRadius: BorderRadius.circular(AppSpacing.s12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s14,
            horizontal: AppSpacing.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'G',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.studentProgressBlue,
                ),
              ),
              Text(
                'Pay',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              AppSpacing.h12,
              Text(
                AppStrings.studentPayFeesOpenInGooglePay,
                style: AppTextStyles.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
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

// ───────────────────────────────────────────────────────── App buttons

class _PaymentAppRow extends StatelessWidget {
  final StudentBillingProfile profile;

  const _PaymentAppRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AppButton(
            label: AppStrings.studentPayFeesAppPhonePe,
            labelColor: AppColors.primaryBrand,
            onTap: () => _snack(AppStrings.studentPayFeesAppPhonePe),
          ),
        ),
        AppSpacing.h8,
        Expanded(
          child: _AppButton(
            label: AppStrings.studentPayFeesAppPaytm,
            labelColor: AppColors.textPrimary,
            onTap: () => _snack(AppStrings.studentPayFeesAppPaytm),
          ),
        ),
        AppSpacing.h8,
        Expanded(
          child: _AppButton(
            label: AppStrings.studentPayFeesAppAnyUpi,
            labelColor: AppColors.textPrimary,
            onTap: () => _snack(AppStrings.studentPayFeesAppAnyUpi),
          ),
        ),
      ],
    );
  }

  void _snack(String app) {
    Get.snackbar(
      app,
      profile.instituteUpiHandle,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _AppButton extends StatelessWidget {
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _AppButton({
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.s10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s10),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s10),
            border: Border.all(color: AppColors.borderGrey),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s12,
            horizontal: AppSpacing.s8,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: labelColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── How it works

class _HowItWorksCard extends StatelessWidget {
  final StudentBillingProfile profile;
  final FeeSummary summary;

  const _HowItWorksCard({required this.profile, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.studentPayFeesHowItWorks,
            style: AppTextStyles.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          _Step(index: 1, text: AppStrings.studentPayFeesStep1),
          const SizedBox(height: AppSpacing.s10),
          _Step(
            index: 2,
            text:
                '${AppStrings.studentPayFeesStep2Prefix} '
                '₹${_formatThousands(summary.pendingInRupees)} '
                '${AppStrings.studentPayFeesStep2Suffix} '
                '${profile.instituteName}.',
          ),
          const SizedBox(height: AppSpacing.s10),
          _Step(index: 3, text: AppStrings.studentPayFeesStep3),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int index;
  final String text;

  const _Step({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.studentBrandSoft,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: AppTextStyles.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.studentBrand,
            ),
          ),
        ),
        AppSpacing.h12,
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.lexend(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
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
