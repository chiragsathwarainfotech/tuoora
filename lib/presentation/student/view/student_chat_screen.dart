import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';

class StudentChatScreen extends StatelessWidget {
  const StudentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.darkSlate,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'SC',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            AppSpacing.h12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saraswati Coaching Centre',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Institute',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.divider, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s24),
              child: Column(
                children: [
                  _buildDateDivider('MON'),
                  const SizedBox(height: AppSpacing.s16),
                  _buildReceivedMessage(
                      'Good morning Aarav. Reminder: Surprise test on Light on Monday 10 AM.',
                      '9:02 AM'),
                  const SizedBox(height: AppSpacing.s12),
                  _buildReceivedMessage(
                      'Topics: reflection, mirrors, ray diagrams. Bring your geometry box.',
                      '9:02 AM'),
                  const SizedBox(height: AppSpacing.s12),
                  _buildSentMessage('Got it sir, thank you 🙏', '11:14 AM'),
                  const SizedBox(height: AppSpacing.s24),
                  
                  _buildDateDivider('WED'),
                  const SizedBox(height: AppSpacing.s16),
                  _buildReceivedMessage(
                      'Today we covered Trigonometry — Ch. 8 identities. Practice Q.1–Q.10.',
                      '4:12 PM'),
                  const SizedBox(height: AppSpacing.s12),
                  _buildSentMessage(
                      'Sir, in Q.7 can we use the complementary angle formula directly?',
                      '7:48 PM'),
                  const SizedBox(height: AppSpacing.s12),
                  _buildReceivedMessage(
                      'Yes, that\'s the cleanest approach. Show one substitution step in your working.',
                      '8:01 PM'),
                  const SizedBox(height: AppSpacing.s24),
                  
                  _buildDateDivider('THU'),
                  const SizedBox(height: AppSpacing.s16),
                  _buildEventMessage('Assignment added: Carbon compounds worksheet (Chemistry). Due 22 May.'),
                  const SizedBox(height: AppSpacing.s24),
                  
                  _buildDateDivider('TODAY'),
                ],
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(AppSpacing.s8),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: const Icon(Icons.add, color: AppColors.textSecondary, size: 20),
            ),
            AppSpacing.h12,
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s8),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Message the institute...',
                  style: AppTextStyles.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
            AppSpacing.h12,
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.circular(AppSpacing.s8),
              ),
              child: const Icon(Icons.arrow_forward, color: AppColors.textSecondary, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Text(
            date,
            style: AppTextStyles.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }

  Widget _buildReceivedMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            margin: const EdgeInsets.only(right: 64),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.s8),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Text(
              text,
              style: AppTextStyles.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            time,
            style: AppTextStyles.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s16),
            margin: const EdgeInsets.only(left: 64),
            decoration: BoxDecoration(
              color: AppColors.studentBrandAccent,
              borderRadius: BorderRadius.circular(AppSpacing.s8),
            ),
            child: Text(
              text,
              style: AppTextStyles.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            time,
            style: AppTextStyles.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventMessage(String text) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16, vertical: AppSpacing.s12),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
        decoration: BoxDecoration(
          color: AppColors.studentTomorrowPillBg,
          borderRadius: BorderRadius.circular(AppSpacing.s8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 14, color: AppColors.studentBrandAccent),
            AppSpacing.h8,
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.lexend(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
