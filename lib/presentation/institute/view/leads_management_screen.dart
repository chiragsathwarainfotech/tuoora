import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/presentation/institute/controllers/leads_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/presentation/shared/widgets/common_state_widget.dart';
import 'package:fee_easy/data/models/lead_model.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadsManagementScreen extends GetView<LeadsController> {
  const LeadsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: AppStrings.instLeadsManagementTitle),
            Expanded(
              child: Padding(
                padding: AppSpacing.x24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.v16,
                    _buildSearchField(),
                    AppSpacing.v20,
                    Expanded(
                      child: Obx(() {
                        return CommonStateWidget(
                          isLoading: controller.isLoading.value,
                          isEmpty: controller.filteredLeads.isEmpty,
                          emptyTitle: 'No Leads Found',
                          emptySubtitle: 'Start adding leads to manage your potential students.',
                          emptyIcon: Icons.leaderboard_outlined,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: controller.filteredLeads.length,
                            separatorBuilder: (_, _) => AppSpacing.v16,
                            itemBuilder: (context, index) {
                              final lead = controller.filteredLeads[index];
                              return _buildLeadCard(lead);
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.prepareForAdd();
          Get.toNamed(AppRoutes.instituteAddEditLead);
        },
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        style: AppTextStyles.lexend(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: AppStrings.instSearchLeadsHint,
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.blueSapphire,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.blueSapphire,
            size: AppSpacing.s24,
          ),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }

  Widget _buildLeadCard(Lead lead) {
    return GestureDetector(
      onTap: () {
        controller.selectedLead.value = lead;
        Get.toNamed(AppRoutes.instituteLeadDetails);
      },
      child: Container(
        padding: AppSpacing.all20,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryBrandLight,
                  child: Text(
                    lead.name
                        .split(' ')
                        .map((e) => e[0])
                        .join('')
                        .toUpperCase(),
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBrand,
                    ),
                  ),
                ),
                AppSpacing.h16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name,
                      style: AppTextStyles.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
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
              ],
            ),
            AppSpacing.v16,
            Row(
              children: [
                const Icon(
                  Icons.school_rounded,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
                AppSpacing.h12,
                Text(
                  lead.course,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AppSpacing.v8,
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
                AppSpacing.h12,
                Text(
                  lead.appliedDate,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            AppSpacing.v16,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () => controller.callLead(lead.phone),
                    icon: Icons.phone,
                    label: AppStrings.instCallBtn,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: 8,
                    fontSize: 14,
                  ),
                ),
                AppSpacing.h12,
                _buildActionBtn(Icons.edit_outlined, () {
                  controller.prepareForEdit(lead);
                  Get.toNamed(AppRoutes.instituteAddEditLead);
                }),
                AppSpacing.h12,
                _buildActionBtn(Icons.delete_outline, () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Lead'),
                      content: const Text(
                        'Are you sure you want to delete this lead?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteLead(lead.id);
                            Get.back();
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }, isDanger: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(
    IconData icon,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.all12,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Icon(
          icon,
          color: isDanger ? Colors.red : AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }
}
