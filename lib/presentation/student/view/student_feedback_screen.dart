import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/input_styles.dart';
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
            Padding(
              padding: AppSpacing.screenPaddingTop,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRatingCard(),
                  const SizedBox(height: 16),
                  _buildMessageCard(),
                  const SizedBox(height: 16),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "HOW'S IT GOING?",
            style: AppTextStyles.outfit(
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBrandLight
                : AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
              color: isSelected ? AppColors.primaryBrand : AppColors.borderGrey,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                rating.label,
                style: AppTextStyles.outfit(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryBrand
                      : AppColors.textSecondary,
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
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR MESSAGE',
            style: AppTextStyles.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.messageController,
            maxLines: 5,
            style: InputStyles.textStyle(),
            // Uses the shared institute input design system: 4 dp radius,
            // tight padding, Outfit hint. Border kept via the matching
            // border colour through `fillColor: scaffoldBg`.
            decoration: InputStyles.filled(
              hintText: 'What would make Tuoora more useful to you?',
              fillColor: AppColors.scaffoldBg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      return AppButton(
        label: 'Send to Tuoora',
        icon: Icons.arrow_forward_rounded,
        backgroundColor: AppColors.bohoRed,
        borderRadius: AppSpacing.cardRadius,
        padding: AppSpacing.cardPadding,
        isLoading: isLoading,
        isDisabled: isLoading,
        onPressed: isLoading ? null : controller.submitFeedback,
      );
    });
  }
}
