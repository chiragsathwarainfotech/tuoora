import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/presentation/institute/controllers/leads_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/data/models/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadDetailsScreen extends GetView<LeadsController> {
  const LeadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Obx(() {
          final lead = controller.selectedLead.value;
          if (lead == null) {
            return const Center(child: Text('Lead not found'));
          }
          return Column(
            children: [
              const InstituteAppBar(title: AppStrings.instLeadDetailsTitle),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.x24.add(AppSpacing.y16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(lead),
                      AppSpacing.v32,
                      _buildContactSection(lead),
                      AppSpacing.v32,
                      _buildInfoCard(
                        Icons.school_rounded,
                        AppStrings.instCourseSelectionLabel,
                        lead.course,
                        subtitle: 'Part-time (Cohort 12) • Starts Oct 15, 2024',
                      ),
                      AppSpacing.v16,
                      _buildInfoCard(
                        Icons.location_on_rounded,
                        AppStrings.instAddressLabel,
                        lead.address ?? 'Not provided',
                      ),
                      AppSpacing.v16,
                      _buildInfoCard(
                        Icons.campaign_rounded,
                        AppStrings.instReferenceLabel,
                        lead.reference ?? 'Not provided',
                      ),
                      AppSpacing.v32,
                      _buildInteractionHistory(lead),
                      AppSpacing.v32,
                    ],
                  ),
                ),
              ),
              _buildBottomAction(lead),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(Lead lead) {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrandLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lead.status,
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                '${AppStrings.instAppliedSuffix} ${lead.appliedDate}',
                style: AppTextStyles.lexend(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            lead.name,
            style: AppTextStyles.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBrand,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(Lead lead) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildContactRow(Icons.email_rounded, 'EMAIL', lead.email),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          _buildContactRow(Icons.phone_rounded, 'PHONE', lead.phone),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBrand, size: 20),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.lexend(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.v4,
              Text(
                value,
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value, {
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBrand, size: 18),
              AppSpacing.h12,
              Text(
                label,
                style: AppTextStyles.lexend(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            AppSpacing.v4,
            Text(
              subtitle,
              style: AppTextStyles.lexend(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInteractionHistory(Lead lead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.history_rounded,
              color: AppColors.primaryBrand,
              size: 20,
            ),
            AppSpacing.h12,
            Text(
              AppStrings.instInteractionHistoryHeading,
              style: AppTextStyles.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
              ),
            ),
          ],
        ),
        AppSpacing.v24,
        if (lead.interactionHistory != null &&
            lead.interactionHistory!.isNotEmpty)
          ...lead.interactionHistory!.map((item) => _buildTimelineItem(item))
        else
          Container(
            padding: AppSpacing.all20,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('No interaction history available'),
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineItem(InteractionHistory item) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBrand,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primaryBrand.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Container(
              padding: AppSpacing.all16,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        item.date,
                        style: AppTextStyles.lexend(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.v8,
                  Text(
                    item.description,
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(Lead lead) {
    return Container(
      padding: AppSpacing.all24,
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
      child: AppButton(
        label: '${AppStrings.instCallBtn} ${lead.name.split(' ')[0]}',
        icon: Icons.phone,
        onPressed: () => controller.callLead(lead.phone),
      ),
    );
  }
}
