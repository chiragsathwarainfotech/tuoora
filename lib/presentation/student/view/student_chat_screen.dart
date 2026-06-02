import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_back_button.dart';

class StudentChatScreen extends StatelessWidget {
  const StudentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.s16),
          child: Center(child: StudentBackButton()),
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
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Institute',
                  style: AppTextStyles.outfit(
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
          child: Container(color: AppColors.background, height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s24,
              ),
              child: Column(
                children: [
                  _buildDateDivider('MON'),
                  const SizedBox(height: AppSpacing.s16),
                  _buildReceivedMessage(
                    'Good morning Aarav. Reminder: Surprise test on Light on Monday 10 AM.',
                    '9:02 AM',
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _buildReceivedMessage(
                    'Topics: reflection, mirrors, ray diagrams. Bring your geometry box.',
                    '9:02 AM',
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _buildSentMessage('Got it sir, thank you 🙏', '11:14 AM'),
                  const SizedBox(height: AppSpacing.s24),

                  _buildDateDivider('WED'),
                  const SizedBox(height: AppSpacing.s16),
                  _buildReceivedMessage(
                    'Today we covered Trigonometry — Ch. 8 identities. Practice Q.1–Q.10.',
                    '4:12 PM',
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _buildSentMessage(
                    'Sir, in Q.7 can we use the complementary angle formula directly?',
                    '7:48 PM',
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _buildReceivedMessage(
                    'Yes, that\'s the cleanest approach. Show one substitution step in your working.',
                    '8:01 PM',
                  ),
                  const SizedBox(height: AppSpacing.s24),

                  _buildDateDivider('THU'),
                  const SizedBox(height: AppSpacing.s16),
                  _buildEventMessage(
                    'Assignment added: Carbon compounds worksheet (Chemistry). Due 22 May.',
                  ),
                  const SizedBox(height: AppSpacing.s24),

                  _buildDateDivider('TODAY'),
                ],
              ),
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => _showAttachmentSheet(context),
              icon: const Icon(Icons.add, color: AppColors.textSecondary),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.paleSilver.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: AppTextStyles.outfit(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Message the institute...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrand,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.82,
              children: [
                _buildAttachmentItem(
                  Icons.image_rounded,
                  'IMAGE',
                  Colors.green.shade100,
                  Colors.green.shade900,
                  onTap: () => Get.back(),
                ),
                _buildAttachmentItem(
                  Icons.videocam_rounded,
                  'VIDEO',
                  Colors.purple.shade100,
                  Colors.purple.shade900,
                  onTap: () => Get.back(),
                ),
                _buildAttachmentItem(
                  Icons.headphones_rounded,
                  'AUDIO',
                  Colors.red.shade100,
                  Colors.red.shade900,
                  onTap: () => Get.back(),
                ),
                _buildAttachmentItem(
                  Icons.insert_drive_file_rounded,
                  'DOCUMENT',
                  Colors.cyan.shade100,
                  Colors.cyan.shade900,
                  onTap: () => Get.back(),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAttachmentItem(
    IconData icon,
    String label,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(String date) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.background)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Text(
            date,
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.background)),
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
              style: AppTextStyles.outfit(
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
            style: AppTextStyles.outfit(
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
              color: AppColors.orangeTag,
              borderRadius: BorderRadius.circular(AppSpacing.s8),
            ),
            child: Text(
              text,
              style: AppTextStyles.outfit(
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
            style: AppTextStyles.outfit(
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
        decoration: BoxDecoration(
          color: AppColors.errorBg,
          borderRadius: BorderRadius.circular(AppSpacing.s8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 14,
              color: AppColors.orangeTag,
            ),
            AppSpacing.h8,
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.outfit(
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
