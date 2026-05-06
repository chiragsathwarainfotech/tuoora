import 'package:flutter/material.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';

class PaymentItemTile extends StatelessWidget {
  final String title;
  final String date;
  final String ref;
  final String amount;
  final VoidCallback? onDownload;
  final bool showShadow;

  const PaymentItemTile({
    super.key,
    required this.title,
    required this.date,
    required this.ref,
    required this.amount,
    this.onDownload,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s44,
            height: AppSpacing.s44,
            decoration: const BoxDecoration(
              color: Color(0xFFECFDF5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  '$date • Ref: $ref',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount,
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              if (onDownload != null) ...[
                AppSpacing.v8,
                GestureDetector(
                  onTap: onDownload,
                  child: Container(
                    padding: AppSpacing.all6,
                    decoration: BoxDecoration(
                      color: AppColors.reportBorder,
                      borderRadius: BorderRadius.circular(AppSpacing.s8),
                    ),
                    child: SvgPicture.asset(
                      AppImages.icDownload,
                      height: AppSpacing.s14,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textTertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
