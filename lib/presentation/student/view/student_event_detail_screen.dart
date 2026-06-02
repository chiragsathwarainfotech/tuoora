import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentEventDetailScreen extends StatelessWidget {
  const StudentEventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StudentAppBar(
              title: 'Science Day exhibition',
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageCard(),
                    const SizedBox(height: AppSpacing.s16),
                    _buildInfoCard(),
                    const SizedBox(height: AppSpacing.s16),
                    _buildDetailsCard(),
                    const SizedBox(height: AppSpacing.s24),
                    Text(
                      'ATTACHMENTS',
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    _buildAttachmentsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        gradient: const LinearGradient(
          colors: [AppColors.turquoiseBlue, AppColors.greenText],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: 10,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppSpacing.s16),
                ),
                child: Text(
                  'EVENT',
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Science Day exhibition',
                style: AppTextStyles.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Saturday, 24 May 2026 - 10:00 AM - 1:00 PM',
                style: AppTextStyles.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          _buildInfoRow('When', 'Saturday, 24 May 2026 • 10:00 AM - 1:00 PM'),
          const Divider(height: 1, color: AppColors.borderGrey),
          _buildInfoRow('Where', 'Saraswati Coaching • Hall A'),
          const Divider(height: 1, color: AppColors.borderGrey),
          _buildInfoRow('Hosted by', 'Mr. R. Verma & Mrs. Iyer'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETAILS',
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            'Annual Science Day where students demo their term project. Set up by 9:30 AM, judging starts at 10:30. Bring your printed report, props and three pens. Parents are welcome from 10 AM onward — tea and snacks will be served outside the hall.',
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          _buildAttachmentRow(
            Icons.description,
            AppColors.successGreen,
            AppColors.successBg,
            'Schedule_ScienceDay.pdf',
            'Document - 120 KB',
          ),
          const Divider(height: 1, color: AppColors.borderGrey),
          _buildAttachmentRow(
            Icons.image,
            AppColors.bohoRed,
            AppColors.errorBg,
            'Floor_plan_HallA.png',
            'Image - 480 KB',
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentRow(
    IconData icon,
    Color iconColor,
    Color iconBg,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
