import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomeworkDetailScreen extends StatefulWidget {
  const StudentHomeworkDetailScreen({super.key});

  @override
  State<StudentHomeworkDetailScreen> createState() =>
      _StudentHomeworkDetailScreenState();
}

class _StudentHomeworkDetailScreenState
    extends State<StudentHomeworkDetailScreen> {
  double _progress = 0.05; // Starting at 5%
  bool _isSubmitted = false;

  void _incrementProgress() {
    setState(() {
      if (_progress < 1.0) {
        _progress = (_progress + 0.50).clamp(0.0, 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepBlue),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Homework Details',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.deepBlue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.x24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.v16,
            _buildFeaturedHeaderCard(),
            AppSpacing.v32,
            _buildInstructionsCard(),
            AppSpacing.v24,
            _buildTutorProfile(),
            AppSpacing.v32,
            _buildAttachmentsSection(),
            AppSpacing.v40,
            _buildProgressCard(),
            AppSpacing.v32,
            _buildSubmitButton(),
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedHeaderCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        color: const Color(0xFF004494),
        borderRadius: BorderRadius.circular(AppSpacing.s32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlueDark.withValues(alpha: 0.2),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Text(
              'MATHEMATICS',
              style: AppTextStyles.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          AppSpacing.v24,
          Text(
            'Advanced\nCalculus',
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          AppSpacing.v32,
          Row(
            children: [
              _buildStatusChip(
                Icons.calendar_month_outlined,
                'Due: Oct 24, 2023',
                Colors.white.withValues(alpha: 0.1),
              ),
              AppSpacing.h12,
              _buildStatusChip(
                Icons.access_time_rounded,
                _isSubmitted ? 'Status: Submitted' : 'Status: Pending',
                _isSubmitted
                    ? AppColors.darkGreen.withValues(alpha: 0.8)
                    : const Color(0xFF8B4513).withValues(alpha: 0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: AppSpacing.s14),
          AppSpacing.h6,
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s28),
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
                padding: AppSpacing.all10,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
                child: const Icon(
                  Icons.description,
                  color: AppColors.primaryBlueDark,
                  size: AppSpacing.s18,
                ),
              ),
              AppSpacing.h16,
              Text(
                'Instructions from\nTutor',
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkSlate,
                  height: 1.2,
                ),
              ),
            ],
          ),
          AppSpacing.v24,
          Text(
            'Welcome to the final module of our Calculus series. For this assignment, please focus on the practical applications of Green\'s Theorem and Stoke\'s Theorem.',
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.6,
            ),
          ),
          AppSpacing.v20,
          Text(
            'Specific Tasks:',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.darkSlate,
            ),
          ),
          AppSpacing.v12,
          _buildBulletItem(
            'Calculate the line integrals for the provided vector fields.',
          ),
          _buildBulletItem(
            'Provide a step-by-step derivation of the surface normal vectors.',
          ),
          _buildBulletItem(
            'Compare your analytical results with the numerical approximations found in Chapter 4.',
          ),
          AppSpacing.v24,
          Container(
            padding: AppSpacing.all20,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(AppSpacing.s16),
              border: const Border(
                left: BorderSide(
                  color: AppColors.primaryBlueDark,
                  width: AppSpacing.s4,
                ),
              ),
            ),
            child: Text(
              'Graphs must be plotted clearly. Hand-drawn sketches are acceptable if scanned at high resolution (300 DPI minimum).',
              style: AppTextStyles.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: AppColors.deepBlue,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.s6),
            child: Icon(
              Icons.circle,
              size: AppSpacing.s6,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorProfile() {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: AppColors.reportBorder,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: AppSpacing.s22,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
          ),
          AppSpacing.h16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ASSIGNED TUTOR',
                style: AppTextStyles.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              AppSpacing.v2,
              Text(
                'Dr. Elena Vance',
                style: AppTextStyles.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkSlate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.link_rounded,
              color: AppColors.primaryBlueDark,
              size: AppSpacing.s24,
            ),
            AppSpacing.h12,
            Text(
              'Attachments',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        AppSpacing.v20,
        Container(
          padding: AppSpacing.all24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: AppSpacing.s10,
                offset: const Offset(0, AppSpacing.s4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildFileCard(
                'Study_Guide_Calculus.pdf',
                'STUDY GUIDE',
                Icons.picture_as_pdf_rounded,
              ),
              AppSpacing.v16,
              _buildFileCard(
                'problem_set_v2.pdf',
                'PROBLEM SET',
                Icons.description_rounded,
              ),
              AppSpacing.v24,
              Text(
                'Tip: Open both files to reach 100% progress.',
                style: AppTextStyles.lexend(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileCard(String name, String type, IconData icon) {
    return InkWell(
      onTap: _incrementProgress,
      borderRadius: BorderRadius.circular(AppSpacing.s16),
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppSpacing.s16),
          border: Border.all(color: const Color(0xFFEDF2F7)),
        ),
        child: Row(
          children: [
            Container(
              padding: AppSpacing.all10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.s10),
              ),
              child: Icon(
                icon,
                color: AppColors.redDot,
                size: AppSpacing.s18,
              ),
            ),
            AppSpacing.h16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkSlate,
                    ),
                  ),
                  Text(
                    type,
                    style: AppTextStyles.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.file_download_outlined,
              color: AppColors.textTertiary,
              size: AppSpacing.s22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR PROGRESS',
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: AppSpacing.s12,
              backgroundColor: const Color(0xFFD1D9E4),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlueDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final bool isEnabled = _progress >= 1.0 && !_isSubmitted;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primaryBlueDark.withValues(alpha: 0.3),
                  blurRadius: AppSpacing.s20,
                  offset: const Offset(0, AppSpacing.s10),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                setState(() => _isSubmitted = true);
                Get.snackbar(
                  'Success',
                  'Homework submitted successfully!',
                  backgroundColor: AppColors.darkGreen,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlueDark,
          disabledBackgroundColor: AppColors.borderLightGray,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.s20),
          ),
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isSubmitted
                    ? Icons.check_circle_rounded
                    : Icons.note_add_rounded,
                color: isEnabled || _isSubmitted
                    ? Colors.white
                    : Colors.grey.shade500,
                size: AppSpacing.s20,
              ),
              AppSpacing.h12,
              Text(
                _isSubmitted ? 'Submitted' : 'Submit Assignment',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isEnabled || _isSubmitted
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
