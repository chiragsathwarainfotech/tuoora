import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeworkDetailScreen extends StatelessWidget {
  const HomeworkDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated data
    final String title = Get.arguments?['title'] ?? 'Photosynthesis Lab Report';
    final String subject = Get.arguments?['subject'] ?? 'Biology';
    final String status = Get.arguments?['status'] ?? 'Completed Today';
    final Color statusColor = Get.arguments?['statusColor'] ?? AppColors.checkGreen;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Homework Details',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: AppSpacing.all24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.s32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: AppSpacing.s10,
                    offset: const Offset(0, AppSpacing.s4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: AppSpacing.all12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(AppSpacing.s12),
                        ),
                        child: const Icon(Icons.science_outlined, color: Color(0xFF16A34A), size: 24),
                      ),
                      AppSpacing.h16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject,
                              style: AppTextStyles.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF16A34A),
                                letterSpacing: 1.0,
                              ),
                            ),
                            AppSpacing.v4,
                            Text(
                              title,
                              style: AppTextStyles.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v24,
                  const Divider(color: AppColors.divider),
                  AppSpacing.v24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem('Assigned Date', 'Sept 15, 2024'),
                      _buildInfoItem('Due Date', 'Sept 20, 2024'),
                    ],
                  ),
                  AppSpacing.v24,
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.all16,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.s16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: statusColor, size: 18),
                        AppSpacing.h8,
                        Text(
                          'Status: $status',
                          style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.v32,

            // Description Section
            Text(
              'Description',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v12,
            Text(
              'Please complete the lab report detailing our findings from the photosynthesis experiment performed in class. Your report should include your hypothesis, experimental setup, observations, and a conclusion based on the data gathered.',
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),

            AppSpacing.v32,

            // Instructions Section
            Text(
              'Instructions',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v16,
            _buildInstructionStep(1, 'Summarize the light-dependent and light-independent reactions.'),
            _buildInstructionStep(2, 'Include the data table from the class spreadsheet.'),
            _buildInstructionStep(3, 'Draw or attach a diagram representing the cycle.'),
            _buildInstructionStep(4, 'Upload the PDF file to the school portal before the deadline.'),

            AppSpacing.v32,

            // Attachments Placeholder
            Text(
              'Attachments',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            AppSpacing.v12,
            Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.s16),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: AppColors.errorRed, size: 28),
                  AppSpacing.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lab_Report_Template.pdf',
                          style: AppTextStyles.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '2.4 MB',
                          style: AppTextStyles.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.download_rounded, color: AppColors.primaryBlue),
                ],
              ),
            ),
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
          ),
        ),
        AppSpacing.v4,
        Text(
          value,
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
