import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/presentation/shared/widgets/common_state_widget.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffListScreen extends GetView<StaffController> {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                InstituteAppBar(title: 'Staff Directory'),
                Expanded(
                  child: Padding(
                    padding: AppSpacing.x24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.v16,
                        _buildSearchBar(),
                        AppSpacing.v20,
                        Expanded(
                          child: Obx(() {
                            return CommonStateWidget(
                              isLoading: controller.isLoading.value,
                              isEmpty: controller.filteredStaffs.isEmpty,
                              emptyTitle: 'No Staff Found',
                              emptySubtitle:
                                  controller.searchQuery.value.isEmpty
                                  ? 'You haven\'t added any staff members yet.'
                                  : 'No staff members match your search.',
                              emptyIcon: Icons.people_outline_rounded,
                              child: _buildStaffGrid(),
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleSilver,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) => controller.searchQuery.value = value,
        style: AppTextStyles.lexend(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search Staff',
          hintStyle: AppTextStyles.lexend(
            fontSize: 14,
            color: AppColors.blueSapphire,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.blueSapphire,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStaffGrid() {
    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: controller.filteredStaffs.length,
          itemBuilder: (context, index) {
            final staff = controller.filteredStaffs[index];
            return _buildStaffCard(staff);
          },
        ),
        Positioned(
          right: 0,
          bottom: 24,
          child: FloatingActionButton(
            onPressed: () {
              controller.prepareForAdd();
              Get.toNamed(AppRoutes.instituteAddEditStaff);
            },
            backgroundColor: AppColors.primaryBrand,
            child: const Icon(Icons.add, color: AppColors.white, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffCard(Staff staff) {
    return GestureDetector(
      onTap: () {
        controller.selectStaff(staff);
        Get.toNamed(AppRoutes.instituteStaffDetails);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryBrand, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppSpacing.v12,
            Text(
              staff.name,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.v2,
            Text(
              staff.role,
              style: AppTextStyles.lexend(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
