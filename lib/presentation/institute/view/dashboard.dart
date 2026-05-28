import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/data/models/menu_item.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class InstituteDashboard extends StatelessWidget {
  const InstituteDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: _buildModulesGrid(),
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
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          Obx(
            () => Text(
              profileController.instituteName.value.isNotEmpty
                  ? profileController.instituteName.value
                  : 'Tuoora',
              style: AppTextStyles.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w800,
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
                              style: AppTextStyles.outfit(
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
      ModuleItem(
        'Staffs',
        Icons.person_search_rounded,
        () => Get.toNamed(AppRoutes.instituteStaffs),
      ),
      ModuleItem(
        'Chats',
        Icons.chat,
        () => Get.toNamed(AppRoutes.instituteChats),
      ),
      ModuleItem(
        'Reports',
        Icons.insert_chart_rounded,
        () => Get.toNamed(AppRoutes.instituteReports),
      ),
      ModuleItem(
        'Leads',
        Icons.leaderboard_rounded,
        () => Get.toNamed(AppRoutes.instituteLeads),
      ),
      ModuleItem(
        'Notes',
        Icons.note_alt_rounded,
        () => Get.toNamed(AppRoutes.instituteNotes),
      ),
      ModuleItem(
        'Expenses',
        Icons.payments_rounded,
        () => Get.toNamed(AppRoutes.instituteExpenses),
      ),
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
        final accent = _accentPalette[index % _accentPalette.length];
        return _buildGridItem(item, accent);
      },
    );
  }

  static const List<Color> _accentPalette = <Color>[
    AppColors.instBrandOrange,
    AppColors.successGreen,
    AppColors.orangeTag,
    AppColors.subjectPhysics,
    AppColors.greenLight,
  ];

  Widget _buildGridItem(ModuleItem item, Color accent) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
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
            Icon(item.icon, color: accent, size: 48),
            AppSpacing.v12,
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 16,
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
