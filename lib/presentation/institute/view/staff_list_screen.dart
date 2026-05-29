import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/widgets/common_state_widget.dart';
import 'package:tuoora/presentation/institute/controllers/staff_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/data/models/staff_model.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffListScreen extends GetView<StaffController> {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Staff Management'),
            Expanded(
              child: Padding(
                padding: AppSpacing.x16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.v16,
                    _buildSearchBar(),
                    AppSpacing.v20,
                    Expanded(
                      child: Obx(() {
                        final staffs = controller.staffList;
                        return CommonStateWidget(
                          isLoading:
                              controller.isLoading.value && staffs.isEmpty,
                          isEmpty: staffs.isEmpty,
                          emptyTitle: 'No Staff Found',
                          emptySubtitle: controller.searchQuery.value.isEmpty
                              ? 'You haven\'t added any staff members yet.'
                              : 'No staff members match your search.',
                          emptyIcon: Icons.people_outline_rounded,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!controller.isLoading.value &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                controller.loadMoreStaff();
                              }
                              return false;
                            },
                            child: RefreshIndicator(
                              onRefresh: () => controller.fetchStaffs(page: 1),
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.8,
                                    ),
                                itemCount:
                                    staffs.length +
                                    (controller.currentPage.value <
                                            controller.lastPage.value
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index == staffs.length) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final staff = staffs[index];
                                  return _buildStaffCard(staff);
                                },
                              ),
                            ),
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
          Get.toNamed(AppRoutes.instituteAddEditStaff);
        },
        backgroundColor: AppColors.primaryBrand,
        child: const Icon(Icons.add, color: AppColors.white, size: 32),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      hintText: 'Search Staff',
      onChanged: (value) => controller.searchQuery.value = value,
    );
  }

  Widget _buildStaffCard(Staff staff) {
    return GestureDetector(
      onTap: () {
        controller.selectStaff(staff);
        Get.toNamed(AppRoutes.instituteStaffDetails);
      },
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.background),
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
            _buildStaffAvatar(staff.profileUrl ?? '', staff.fullName, size: 60),
            AppSpacing.v8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                staff.fullName,
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.v2,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                staff.role?.name ?? 'No Role',
                style: AppTextStyles.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffAvatar(String imageUrl, String name, {double size = 48}) {
    if (imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryBrand.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primaryBrand.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          getInitials(name),
          style: AppTextStyles.outfit(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return 'ST';
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length > 1 ? 2 : 1;
    for (var i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }
    return initials.toUpperCase();
  }
}
