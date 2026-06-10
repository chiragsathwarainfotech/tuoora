import 'package:flutter/material.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tuoora/data/models/student_notification_model.dart';

class StudentEventDetailScreen extends StatelessWidget {
  const StudentEventDetailScreen({super.key});

  StudentNotification? get notification {
    if (Get.arguments is StudentNotification) {
      return Get.arguments as StudentNotification;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final notif = notification;
    final title = notif?.title ?? AppStrings.details;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudentAppBar(title: title, showDefaultActions: false),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImageCard(notif),
                    const SizedBox(height: AppSpacing.s16),
                    _buildDetailsCard(notif),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(StudentNotification? notif) {
    final title = notif?.title ?? AppStrings.scienceDayExhibition;
    final isEvent = notif?.kind == NotificationKind.eventsHolidays;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.s12),
        gradient: notif?.image == null
            ? const LinearGradient(
                colors: [AppColors.turquoiseBlue, AppColors.greenText],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        image: notif?.image != null
            ? DecorationImage(
                image: CachedNetworkImageProvider(notif!.image!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.4),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Stack(
        children: [
          if (notif?.image == null) ...[
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
          ],
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
                  isEvent ? 'Event / Holiday' : 'Update',
                  style: AppTextStyles.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(StudentNotification? notif) {
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
            AppStrings.details,
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.s12),
          Text(
            notif?.message ?? AppStrings.annualScienceDayWhereStudentsDemo,
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
}
