import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PaymentQRScreen extends StatelessWidget {
  const PaymentQRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const upiId = 'julian.sterling@okaxis';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBrand),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Payment QR',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.primaryBrand),
            onPressed: () => Get.snackbar(
              'Success',
              'QR Code saved to gallery',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green[700],
              colorText: AppColors.white,
              margin: const EdgeInsets.all(16),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          AppSpacing.v24,
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBrandLight,
                      width: 3,
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/julian_profile.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AppSpacing.v20,
                Text(
                  'Julian Sterling',
                  style: AppTextStyles.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  'Grade 11 • Section A-Alpha',
                  style: AppTextStyles.lexend(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.v32,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              padding: AppSpacing.all32,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 210,
                    height: 210,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.reportBorder,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            size: 180,
                            color: Colors.blue[900],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.primaryBrand,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.v32,
                  Text(
                    'SCAN TO PAY FEES',
                    style: AppTextStyles.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.v24,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () {
                Clipboard.setData(const ClipboardData(text: upiId));
                Get.snackbar(
                  'Copied',
                  'UPI ID copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.darkSlate,
                  colorText: AppColors.white,
                  margin: const EdgeInsets.all(20),
                  borderRadius: 16,
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryBrandLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      upiId,
                      style: AppTextStyles.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBrand,
                      ),
                    ),
                    AppSpacing.h12,
                    const Icon(
                      Icons.copy_rounded,
                      color: AppColors.primaryBrand,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
