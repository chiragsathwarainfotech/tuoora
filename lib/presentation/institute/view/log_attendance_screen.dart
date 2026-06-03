import 'package:cached_network_image/cached_network_image.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_button.dart';
import 'package:tuoora/core/widgets/app_input_field.dart';
import 'package:tuoora/data/models/staff_model.dart';
import 'package:tuoora/presentation/institute/controllers/staff_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:tuoora/core/widgets/app_pickers.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:tuoora/presentation/institute/widgets/institute_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LogAttendanceScreen extends GetView<StaffController> {
  const LogAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: AppStrings.addAttendance),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InstituteLabel('Select Member'),
                    Obx(() {
                      if (controller.selectedLogStaff.value != null) {
                        return _buildSelectedStaffCard(
                          controller.selectedLogStaff.value!,
                        );
                      } else {
                        return _buildStaffSearchField();
                      }
                    }),
                    AppSpacing.v20,
                    Obx(
                      () => AppInputField(
                        label: AppStrings.labelDate,
                        hint: 'MM/dd/yyyy',
                        icon: Icons.calendar_today_rounded,
                        controller: TextEditingController(
                          text: DateFormat(
                            'MM/dd/yyyy',
                          ).format(controller.selectedLogDate.value),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final picked = await AppPickers.date(
                            context,
                            initialDate: controller.selectedLogDate.value,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            controller.selectLogDate(picked);
                          }
                        },
                      ),
                    ),
                    AppSpacing.v24,
                    const InstituteLabel('Attendance Status'),
                    _buildStatusToggle(),
                    AppSpacing.v24,
                    AppInputField(
                      label: AppStrings.absentReason,
                      controller: controller.logNotesController,
                      hint: AppStrings.enterReason,
                      maxLines: 4,
                    ),
                    AppSpacing.v32,
                    _buildLogButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffSearchField() {
    return Column(
      children: [
        AppSearchField(
          hintText: AppStrings.searchMemberByName,
          onChanged: (val) => controller.searchLogStaff(val),
        ),
        Obx(() {
          if (controller.filteredLogStaffs.isEmpty ||
              controller.logSearchQuery.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.background),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: controller.filteredLogStaffs.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final staff = controller.filteredLogStaffs[index];
                return ListTile(
                  leading: _buildStaffAvatar(
                    staff.profileUrl ?? '',
                    staff.fullName,
                    size: 32,
                  ),
                  title: Text(
                    staff.fullName,
                    style: AppTextStyles.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    staff.role?.name ?? "",
                    style: AppTextStyles.outfit(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  onTap: () => controller.setLogStaff(staff),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSelectedStaffCard(Staff staff) {
    return Container(
      padding: AppSpacing.all12,
      decoration: BoxDecoration(
        color: AppColors.fieldBg.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: AppColors.primaryBrand.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          _buildStaffAvatar(staff.profileUrl ?? '', staff.fullName, size: 40),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.fullName,
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  staff.role?.name ?? "",
                  style: AppTextStyles.outfit(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.removeLogStaff(),
            icon: const AppActionIcon(asset: AppImages.icDelete, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleStatus(true),
              child: _buildStatusButton(
                'Present',
                Icons.check_circle_rounded,
                AppColors.successGreen,
                controller.isPresent.value,
              ),
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleStatus(false),
              child: _buildStatusButton(
                'Absent',
                Icons.cancel_rounded,
                AppColors.bohoRed,
                !controller.isPresent.value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
    String label,
    IconData icon,
    Color color,
    bool isSelected,
  ) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: isSelected ? color : AppColors.background,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? color : AppColors.textTertiary,
            size: 32,
          ),
          AppSpacing.v12,
          Text(
            label,
            style: AppTextStyles.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? color : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogButton() {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 16),
      child: Obx(
        () => AppButton(
          onPressed: () => controller.saveAttendanceRecord(),
          label: AppStrings.logAttendance,
          icon: Icons.check_circle_outline_rounded,
          isLoading: controller.isSaving.value,
        ),
      ),
    );
  }

  Widget _buildStaffAvatar(String imageUrl, String name, {double size = 40}) {
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
            image: CachedNetworkImageProvider(imageUrl),
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
            fontWeight: FontWeight.w600,
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
