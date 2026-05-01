import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/data/models/menu_item.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class InstituteDashboard extends StatelessWidget {
  const InstituteDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.v24,
                  Text(
                    'INSTITUTIONAL PORTAL',
                    style: AppTextStyles.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF663322),
                      letterSpacing: 1,
                    ),
                  ),
                  AppSpacing.v4,
                  Text(
                    'Dashboard Overview',
                    style: AppTextStyles.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.v32,
                  _buildModulesGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    final profileController = Get.find<InstituteProfileController>();
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Obx(
            () => Text(
              profileController.instituteName.value.isNotEmpty
                  ? profileController.instituteName.value
                  : 'FeeEasy',
              style: AppTextStyles.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryBrand,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteNotifications),
            child: const Icon(
              Icons.notifications_rounded,
              color: AppColors.primaryBrand,
              size: 28,
            ),
          ),
          AppSpacing.h20,
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.instituteProfile),
            child: Obx(
              () => Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryBrandLight,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child:
                      profileController.profileImagePath.value != null &&
                          profileController.profileImagePath.value!.startsWith(
                            'http',
                          )
                      ? Image.network(
                          profileController.profileImagePath.value!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.primaryBrandLight,
                          child: Center(
                            child: Text(
                              profileController.instituteName.value.isNotEmpty
                                  ? profileController.instituteName.value[0]
                                        .toUpperCase()
                                  : 'I',
                              style: AppTextStyles.manrope(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryBrand,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesGrid() {
    final modules = [
      ModuleItem(
        'Students',
        Icons.people_rounded,
        () => Get.toNamed(AppRoutes.instituteStudents),
      ),
      ModuleItem(
        'Batches',
        Icons.layers_rounded,
        () => Get.toNamed(AppRoutes.instituteBatches),
      ),
      ModuleItem(
        'Fees',
        Icons.account_balance_wallet_rounded,
        () => Get.toNamed(AppRoutes.instituteFees),
      ),
      ModuleItem('Teachers', Icons.person_search_rounded, () {}),
      ModuleItem('Engagement', Icons.auto_graph_rounded, () {}),
      ModuleItem(
        'Reports',
        Icons.insert_chart_rounded,
        () => Get.toNamed(AppRoutes.instituteReports),
      ),
      ModuleItem('Leads', Icons.leaderboard_rounded, () {}),
      ModuleItem('Notes', Icons.note_alt_rounded, () {}),
      ModuleItem('Expenses', Icons.payments_rounded, () {}),
      ModuleItem(
        'Updates',
        Icons.campaign_rounded,
        () => Get.toNamed(AppRoutes.instituteUpdates),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final item = modules[index];
        return _buildGridItem(item);
      },
    );
  }

  Widget _buildGridItem(ModuleItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.instDashboardIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: AppColors.instDashboardIcon,
                size: 24,
              ),
            ),
            AppSpacing.v12,
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
