import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/controllers/student_receipts_list_controller.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentReceiptsListScreen extends GetView<StudentReceiptsListController> {
  const StudentReceiptsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(title: 'Receipts', showDefaultActions: false),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.studentBrand,
                    ),
                  );
                }
                final items = controller.receipts;
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      child: Text(
                        'No receipts available yet.',
                        style: AppTextStyles.outfit(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.studentBrand,
                  onRefresh: controller.loadReceipts,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    itemCount: items.length + 1,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.s10),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                          child: Text(
                            '${items.length} ${items.length == 1 ? "receipt" : "receipts"} available',
                            style: AppTextStyles.outfit(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      final receipt = items[index - 1];
                      return _ReceiptCard(
                        receipt: receipt,
                        onTap: () => controller.openReceipt(receipt),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final StudentReceipt receipt;
  final VoidCallback onTap;

  const _ReceiptCard({required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.s12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s12),
            border: Border.all(
              color: AppColors.borderGrey.withValues(alpha: 0.5),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.studentPresentBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s8),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.studentPresentBg,
                  size: 20,
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.receiptNumber.isNotEmpty
                          ? receipt.receiptNumber
                          : 'Receipt #${receipt.id}',
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (receipt.date.isNotEmpty) receipt.date,
                        if (receipt.paymentMethod.isNotEmpty)
                          receipt.paymentMethod,
                      ].join('  ·  '),
                      style: AppTextStyles.outfit(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppSpacing.h8,
              Text(
                '₹${receipt.amount}',
                style: AppTextStyles.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
