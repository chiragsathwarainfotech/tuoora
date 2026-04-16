import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordFeeScreen extends StatelessWidget {
  const RecordFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Record Fee'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStudentSearchSection(),
                    AppSpacing.v16,
                    _buildStatusSection(),
                    AppSpacing.v16,
                    _buildFeeDetailsSection(),
                  ],
                ),
              ),
            ),
            _buildFixedFooterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentSearchSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: AppColors.instPrimaryBlue, size: AppSpacing.s20),
              AppSpacing.h8,
              Text(
                AppStrings.instStudentInfoLabel,
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.instPrimaryBlue,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputSolidGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.instSearchStudentHint,
                hintStyle: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
                suffixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: AppSpacing.s22),
                border: InputBorder.none,
                contentPadding: AppSpacing.all16,
              ),
            ),
          ),
          AppSpacing.v16,
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSpacing.s48,
                  height: AppSpacing.s48,
                  decoration: BoxDecoration(
                    color: AppColors.instPrimaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'JD',
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                AppSpacing.h16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: AppTextStyles.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Batch: Grade 10 - Mathematics',
                        style: AppTextStyles.lexend(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Change',
                  style: AppTextStyles.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.instPrimaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info, color: AppColors.instPrimaryBlue, size: 20),
              AppSpacing.h8,
              Text(
                AppStrings.instRecordStatusLabel,
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.instPrimaryBlue,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          _buildStatusTile(AppStrings.instStatusPaid, Icons.check_circle, true),
          AppSpacing.v12,
          _buildStatusTile(AppStrings.instStatusPending, Icons.access_time_filled, false),
          AppSpacing.v12,
          _buildStatusTile(AppStrings.instStatusPartial, Icons.hourglass_bottom, false),
        ],
      ),
    );
  }

  Widget _buildStatusTile(String label, IconData icon, bool isSelected) {
    return Container(
      padding: AppSpacing.x16.add(AppSpacing.y14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.instRecordStatusPaidBg : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.instRecordStatusIcon.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.instRecordStatusIcon : AppColors.textSecondary,
            ),
          ),
          Icon(
            icon,
            color: isSelected ? AppColors.instRecordStatusIcon : Colors.black45,
            size: AppSpacing.s20,
          ),
        ],
      ),
    );
  }

  Widget _buildFeeDetailsSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, AppSpacing.s4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fee Month
          Text(
            AppStrings.instFeeMonthLabel,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
          AppSpacing.v8,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: AppColors.inputSolidGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'October 2023',
                  style: AppTextStyles.lexend(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(Icons.calendar_month, color: AppColors.textTertiary, size: AppSpacing.s24),
              ],
            ),
          ),
          AppSpacing.v20,

          // Amount
          Text(
            AppStrings.instAmountLabel,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
          AppSpacing.v8,
          Container(
            padding: AppSpacing.all16,
            decoration: BoxDecoration(
              color: AppColors.inputSolidGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1500',
                  style: AppTextStyles.lexend(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.payments, color: AppColors.textTertiary, size: AppSpacing.s24),
              ],
            ),
          ),
          AppSpacing.v20,

          // Payment Method
          Text(
            AppStrings.instPaymentMethodLabel,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
          AppSpacing.v8,
          Row(
            children: [
              Expanded(child: _buildPaymentMethodBtn(AppStrings.instPaymentCash, Icons.wallet, true)),
              AppSpacing.h12,
              Expanded(child: _buildPaymentMethodBtn(AppStrings.instPaymentOnline, Icons.account_balance, false)),
            ],
          ),
          AppSpacing.v24,

          // Receipt Preview Box (Dotted)
          _buildReceiptPreview(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodBtn(String label, IconData icon, bool isActive) {
    return Container(
      padding: AppSpacing.y16,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.instPrimaryBlue : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? AppColors.instPrimaryBlue : AppColors.textPrimary, size: AppSpacing.s22),
          AppSpacing.h8,
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptPreview() {
    return Container(
      padding: AppSpacing.all20,
      // Custom dotted border can be achieved with a CustomPainter or a plugin, 
      // but for mockup we will use an image or rounded dash style.
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1.5, style: BorderStyle.solid), // mockup solid for now
      ),
      child: Column(
        children: [
          Container(
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.description, color: AppColors.instPrimaryBlue, size: AppSpacing.s28),
          ),
          AppSpacing.v16,
          Text(
            AppStrings.instAutoReceiptTitle,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.v4,
          Text(
            AppStrings.instAutoReceiptDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.lexend(
              fontSize: 11,
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          AppSpacing.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.instPreviewReceipt,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.instPrimaryBlue,
                ),
              ),
              AppSpacing.h8,
              const Icon(Icons.open_in_new, color: AppColors.instPrimaryBlue, size: AppSpacing.s16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFixedFooterButton() {
    return Container(
      padding: AppSpacing.all24,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          width: double.infinity,
          padding: AppSpacing.y18,
          decoration: BoxDecoration(
            color: AppColors.instPrimaryBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              AppStrings.instSaveFeeBtn,
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
