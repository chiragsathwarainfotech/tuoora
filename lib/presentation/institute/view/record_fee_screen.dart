import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/record_fee_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordFeeScreen extends GetView<RecordFeeController> {
  const RecordFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(
          () => Column(
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
                      _buildFeeDetailsSection(context),
                    ],
                  ),
                ),
              ),
              _buildFixedFooterButton(),
            ],
          ),
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
              const Icon(
                Icons.person,
                color: AppColors.instPrimaryBlue,
                size: AppSpacing.s20,
              ),
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
          if (!controller.isStudentSelected.value) ...[
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputSolidGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: AppStrings.instSearchStudentHint,
                  hintStyle: AppTextStyles.lexend(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textTertiary,
                    size: AppSpacing.s22,
                  ),
                  border: InputBorder.none,
                  contentPadding: AppSpacing.all16,
                ),
              ),
            ),
            if (controller.searchQuery.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.s8),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.filteredStudents.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final student = controller.filteredStudents[index];
                    return ListTile(
                      onTap: () => controller.selectStudent(student),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(student.imageUrl),
                      ),
                      title: Text(
                        student.name,
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        student.id,
                        style: AppTextStyles.lexend(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ] else
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
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          controller.selectedStudent.value!.imageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppSpacing.h16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.selectedStudent.value!.name,
                          style: AppTextStyles.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Batch: ${controller.selectedStudent.value!.batch}',
                          style: AppTextStyles.lexend(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.changeStudent(),
                    child: Text(
                      'Change',
                      style: AppTextStyles.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.instPrimaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeeDetailsSection(BuildContext context) {
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
                Expanded(
                  child: TextField(
                    onChanged: (value) => controller.amount.value = value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: AppTextStyles.lexend(
                        fontSize: 15,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    style: AppTextStyles.lexend(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.payments,
                  color: AppColors.textTertiary,
                  size: AppSpacing.s24,
                ),
              ],
            ),
          ),
          AppSpacing.v20,
          Text(
            'Record Date',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
          AppSpacing.v8,
          GestureDetector(
            onTap: () => controller.selectRecordDate(context),
            child: Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: AppColors.inputSolidGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      DateFormat('dd MMM, yyyy')
                          .format(controller.selectedRecordDate.value),
                      style: AppTextStyles.lexend(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.textTertiary,
                    size: AppSpacing.s22,
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.v20,
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
              Expanded(
                child: _buildPaymentMethodBtn(
                  AppStrings.instPaymentCash,
                  Icons.wallet,
                  controller.paymentMethod.value == AppStrings.instPaymentCash,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: _buildPaymentMethodBtn(
                  AppStrings.instPaymentOnline,
                  Icons.account_balance,
                  controller.paymentMethod.value ==
                      AppStrings.instPaymentOnline,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          _buildReceiptPreview(),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodBtn(String label, IconData icon, bool isActive) {
    return GestureDetector(
      onTap: () => controller.setPaymentMethod(label),
      child: Container(
        padding: AppSpacing.y16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.instPrimaryBlue : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.instPrimaryBlue
                  : AppColors.textPrimary,
              size: AppSpacing.s22,
            ),
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
      ),
    );
  }

  Widget _buildReceiptPreview() {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.divider,
          width: 1.5,
          style: BorderStyle.solid,
        ),
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
            child: const Icon(
              Icons.description,
              color: AppColors.instPrimaryBlue,
              size: AppSpacing.s28,
            ),
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
          GestureDetector(
            onTap: () => _showReceiptPreview(),
            child: Row(
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
                const Icon(
                  Icons.open_in_new,
                  color: AppColors.instPrimaryBlue,
                  size: AppSpacing.s16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiptPreview() {
    if (controller.selectedStudent.value == null) {
      Get.snackbar('Alert', 'Please select a student first');
      return;
    }

    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSpacing.v24,
            Text(
              'Receipt Preview',
              textAlign: TextAlign.center,
              style: AppTextStyles.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v24,
            _buildReceiptRow(
              'Student',
              controller.selectedStudent.value?.name ?? '-',
            ),
            _buildReceiptRow(
              'Student ID',
              controller.selectedStudent.value?.id ?? '-',
            ),
            _buildReceiptRow(
              'Batch',
              controller.selectedStudent.value?.batch ?? '-',
            ),
            const Divider(height: 32),
            _buildReceiptRow('Fee Month', controller.selectedMonth.value),
            _buildReceiptRow(
              'Record Date',
              DateFormat('dd MMM, yyyy')
                  .format(controller.selectedRecordDate.value),
            ),
            _buildReceiptRow('Payment Method', controller.paymentMethod.value),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '₹${controller.amount.value}',
                  style: AppTextStyles.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.instAccentBlue,
                  ),
                ),
              ],
            ),
            AppSpacing.v32,
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.instPrimaryBlue,
                padding: AppSpacing.y16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Close Preview',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            AppSpacing.v16,
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          if (isStatus)
            Container(
              padding: AppSpacing.x10.add(AppSpacing.y4),
              decoration: BoxDecoration(
                color: value == AppStrings.instStatusPaid
                    ? AppColors.instFeesPaidBadgeBg
                    : AppColors.instFeesDueBadgeBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: value == AppStrings.instStatusPaid
                      ? AppColors.instFeesPaidText
                      : AppColors.instFeesDueText,
                ),
              ),
            )
          else
            Text(
              value,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
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
        onTap: () => controller.saveRecord(),
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
