import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/institute/controllers/homework_rating_controller.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeworkRatingScreen extends StatelessWidget {
  const HomeworkRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeworkModel homework = Get.arguments;
    final controller = Get.put(
      HomeworkRatingController(homework),
      tag: homework.id,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: AppStrings.instHomeworkRatingTitle,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(homework),
                    AppSpacing.v24,
                    _buildProgressSection(homework),
                    AppSpacing.v24,
                    _buildFilterSection(controller),
                    AppSpacing.v24,
                    Obx(
                      () => Column(
                        children: controller.filteredSubmissions
                            .map(
                              (sub) => _buildStudentRatingCard(controller, sub),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InstituteBottomButton(
        label: AppStrings.instSaveAllRatingsBtn,
        icon: Icons.save_outlined,
        onTap: () => controller.saveAllRatings(),
      ),
    );
  }

  Widget _buildHeader(HomeworkModel hw) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hw.subject.toUpperCase(),
              style: AppTextStyles.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.instPrimaryBlue,
                letterSpacing: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.indigoLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'BATCH B-12', // Placeholder batch name
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.instPrimaryBlue,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.v8,
        Text(
          hw.title,
          style: AppTextStyles.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(HomeworkModel hw) {
    final submitted = hw.submittedCount;
    final total = hw.submissions.length;
    final progress = total == 0 ? 0.0 : submitted / total;

    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_box_outlined,
                    color: AppColors.instPrimaryBlue,
                    size: 20,
                  ),
                  AppSpacing.h8,
                  Text(
                    AppStrings.instGradingProgressLabel,
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$submitted/$total ',
                      style: AppTextStyles.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.instPrimaryBlue,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.instSubmittedTag,
                      style: AppTextStyles.lexend(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF2F4F7),
              color: AppColors.instPrimaryBlue,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(HomeworkRatingController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(controller, AppStrings.instFilterAll, 0),
          AppSpacing.h12,
          _buildFilterChip(controller, AppStrings.instFilterSubmitted, 1),
          AppSpacing.h12,
          _buildFilterChip(controller, AppStrings.instFilterMissing, 2),
          AppSpacing.h12,
          _buildFilterChip(controller, AppStrings.instFilterLate, 3),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    HomeworkRatingController controller,
    String label,
    int index,
  ) {
    return Obx(() {
      final isSelected = controller.filterIndex.value == index;
      return GestureDetector(
        onTap: () => controller.filterIndex.value = index,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.instPrimaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.instPrimaryBlue
                  : const Color(0xFFD0D5DD),
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStudentRatingCard(
    HomeworkRatingController controller,
    HomeworkSubmission sub,
  ) {
    final isSubmitted = sub.isSubmitted;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.instFeesAvatarBg,
                child: Text(sub.student.name[0]),
              ),
              AppSpacing.h16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sub.student.name,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'ID: #${sub.student.id}',
                      style: AppTextStyles.lexend(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(sub.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  sub.status,
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _getStatusColor(sub.status),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          if (isSubmitted)
            Row(
              children: [
                Text(
                  AppStrings.instScoreLabel,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => controller.updateScore(
                          sub.student.id.toString(),
                          (sub.score ?? 0) - 1,
                        ),
                        icon: const Icon(Icons.remove, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      AppSpacing.h12,
                      Text(
                        sub.score?.toStringAsFixed(0) ?? '-',
                        style: AppTextStyles.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.instPrimaryBlue,
                        ),
                      ),
                      AppSpacing.h12,
                      IconButton(
                        onPressed: () => controller.updateScore(
                          sub.student.id.toString(),
                          (sub.score ?? 0) + 1,
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                AppSpacing.h8,
                Text(
                  '/ 10',
                  style: AppTextStyles.lexend(
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            )
          else
            ElevatedButton(
              onPressed: () =>
                  controller.sendReminder(sub.student.id.toString()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667085),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  AppSpacing.h8,
                  Text(
                    AppStrings.instSendReminderBtn,
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SUBMITTED':
        return const Color(0xFF12B76A);
      case 'LATE':
        return AppColors.warningAmber;
      case 'PENDING':
        return const Color(0xFFF04438);
      default:
        return AppColors.textTertiary;
    }
  }
}
