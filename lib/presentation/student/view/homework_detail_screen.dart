import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomeworkDetailScreen extends StatelessWidget {
  const StudentHomeworkDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Homework Details',
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1E3A8A)),
            onPressed: () {},
          ),
        ],
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
            color: const Color(0xFF003781).withValues(alpha: 0.2),
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
                'Status: Pending',
                const Color(0xFF8B4513).withValues(alpha: 0.8),
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
                  color: const Color(0xFFE5E9EF),
                  borderRadius: BorderRadius.circular(AppSpacing.s10),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF003781),
                  size: AppSpacing.s18,
                ),
              ),
              AppSpacing.h16,
              Text(
                'Instructions from\nTutor',
                style: AppTextStyles.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
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
              color: const Color(0xFF1E293B),
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
                  color: Color(0xFF003781),
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
                color: const Color(0xFF1E3A8A),
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
              color: Color(0xFF94A3B8),
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
        color: const Color(0xFFF1F5F9),
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
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.8,
                ),
              ),
              AppSpacing.v2,
              Text(
                'Dr. Elena Vance',
                style: AppTextStyles.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
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
              color: Color(0xFF003781),
              size: AppSpacing.s24,
            ),
            AppSpacing.h12,
            Text(
              'Attachments',
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileCard(String name, String type, IconData icon) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
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
              color: const Color(0xFF991B1B),
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
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  type,
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.file_download_outlined,
            color: Color(0xFF64748B),
            size: AppSpacing.s22,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9EF),
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
                  color: const Color(0xFF64748B),
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '0%',
                style: AppTextStyles.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.05,
              minHeight: AppSpacing.s12,
              backgroundColor: Color(0xFFD1D9E4),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003781)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s20),
      decoration: BoxDecoration(
        color: const Color(0xFF003781),
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003781).withValues(alpha: 0.3),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.note_add_rounded,
            color: Colors.white,
            size: AppSpacing.s20,
          ),
          AppSpacing.h12,
          Text(
            'Submit Assignment',
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
