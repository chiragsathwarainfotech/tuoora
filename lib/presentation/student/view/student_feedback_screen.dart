import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/presentation/student/controllers/student_feedback_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentFeedbackScreen extends GetView<StudentFeedbackController> {
  const StudentFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StudentAppBar(title: "Tell us what's missing", isRoot: false),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRatingCard(),
                    const SizedBox(height: 16),
                    _buildMessageCard(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'We read everything. Replies come via chat.',
                        style: AppTextStyles.lexend(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HOW'S IT GOING?",
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildRatingItem(FeedbackRating.loveIt, '🥰')),
              const SizedBox(width: 8),
              Expanded(child: _buildRatingItem(FeedbackRating.useful, '🙂')),
              const SizedBox(width: 8),
              Expanded(child: _buildRatingItem(FeedbackRating.meh, '😐')),
              const SizedBox(width: 8),
              Expanded(child: _buildRatingItem(FeedbackRating.broken, '😖')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem(FeedbackRating rating, String emoji) {
    return Obx(() {
      final isSelected = controller.selectedRating.value == rating;
      return GestureDetector(
        onTap: () => controller.setRating(rating),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.errorBg : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.error : AppColors.borderGrey,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                rating.label,
                style: AppTextStyles.lexend(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.error : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMessageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR MESSAGE',
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: TextField(
              controller: controller.messageController,
              maxLines: 5,
              style: AppTextStyles.lexend(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'What would make Tuoora more useful to you?',
                hintStyle: AppTextStyles.lexend(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return ElevatedButton(
        onPressed: isLoading ? null : controller.submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.studentTomorrowPillText,
          disabledBackgroundColor: AppColors.studentTomorrowPillText,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Send to Tuoora',
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
