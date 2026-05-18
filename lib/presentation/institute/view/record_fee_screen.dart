import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:intl/intl.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/record_fee_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordFeeScreen extends GetView<RecordFeeController> {
  const RecordFeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
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
            Obx(
              () => controller.isLoading.value
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                        child: const CommonLoading(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentSearchSection() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
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
                color: AppColors.primaryBrand,
                size: AppSpacing.s20,
              ),
              AppSpacing.h8,
              Text(
                AppStrings.instStudentInfoLabel,
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandAppBarColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          if (!controller.isStudentSelected.value) ...[
            Obx(
              () => AppSearchField(
                hintText: AppStrings.instSearchStudentHint,
                onChanged: (value) => controller.searchQuery.value = value,
                borderColor: controller.studentError.value != null
                    ? Colors.redAccent
                    : Colors.transparent,
              ),
            ),
            Obx(() {
              if (controller.studentError.value != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    controller.studentError.value!,
                    style: AppTextStyles.manrope(
                      fontSize: 12,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            if (controller.searchQuery.value.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.s8),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: AppColors.white,
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
                      leading: _buildStudentAvatar(
                        student.imageUrl,
                        student.name,
                        size: 40,
                      ),
                      title: Text(
                        student.name,
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        student.id.toString(),
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
                color: AppColors.primaryBrandLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildStudentAvatar(
                    controller.selectedStudent.value!.imageUrl,
                    controller.selectedStudent.value!.name,
                    size: 48,
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
                          'Batch: ${controller.selectedStudent.value!.currentBatchName}',
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
                        color: AppColors.primaryBrand,
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
        color: AppColors.white,
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
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
            ),
          ),
          AppSpacing.v8,
          Obx(
            () => Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: AppColors.paleSilver,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: controller.amountError.value != null
                      ? Colors.redAccent
                      : Colors.transparent,
                ),
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
                          color: AppColors.blueSapphire,
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
          ),
          Obx(() {
            if (controller.amountError.value != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Text(
                  controller.amountError.value!,
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          AppSpacing.v20,
          Text(
            'Record Date',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
            ),
          ),
          AppSpacing.v8,
          GestureDetector(
            onTap: () => controller.selectRecordDate(context),
            child: Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: AppColors.paleSilver,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      DateFormat(
                        'dd MMM, yyyy',
                      ).format(controller.selectedRecordDate.value),
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
              fontWeight: FontWeight.w800,
              color: AppColors.brandAppBarColor,
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
          color: isActive
              ? AppColors.primaryBrandLight.withValues(alpha: 0.5)
              : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primaryBrand : AppColors.paleSilver,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.primaryBrand
                  : AppColors.brandAppBarColor,
              size: 20,
            ),
            AppSpacing.h12,
            Text(
              label,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isActive
                    ? AppColors.primaryBrand
                    : AppColors.brandAppBarColor,
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
        color: AppColors.scaffoldBg,
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
              color: AppColors.white,
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
              color: AppColors.primaryBrand,
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
                    color: AppColors.primaryBrand,
                  ),
                ),
                AppSpacing.h8,
                const Icon(
                  Icons.open_in_new,
                  color: AppColors.primaryBrand,
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
    controller.triedToSave.value = true;
    if (!controller.validateForm()) return;

    Get.bottomSheet(
      Container(
        padding: AppSpacing.all24,
        decoration: const BoxDecoration(
          color: AppColors.white,
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
              controller.selectedStudent.value?.id.toString() ?? '-',
            ),
            const Divider(height: 32),
            _buildReceiptRow('Fee Month', controller.selectedMonth.value),
            _buildReceiptRow(
              'Record Date',
              DateFormat(
                'dd MMM, yyyy',
              ).format(controller.selectedRecordDate.value),
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
                    color: AppColors.primaryBrand,
                  ),
                ),
              ],
            ),
            AppSpacing.v32,
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrand,
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
                  color: AppColors.white,
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
                    ? AppColors.successBg
                    : AppColors.warningBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: value == AppStrings.instStatusPaid
                      ? AppColors.greenText
                      : AppColors.primaryBrand,
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

  Widget _buildStudentAvatar(String imageUrl, String name, {double size = 48}) {
    if (imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryBrandLight,
          borderRadius: BorderRadius.circular(size / 3),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0].toUpperCase();
      if (names.length > 1 && names.last.isNotEmpty) {
        initials += names.last[0].toUpperCase();
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primaryBrandLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.manrope(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
    );
  }

  Widget _buildFixedFooterButton() {
    return Container(
      padding: AppSpacing.all24,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: AppButton(
        label: AppStrings.instSaveFeeBtn,
        onPressed: () => controller.saveRecord(),
      ),
    );
  }
}
