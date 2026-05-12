import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/widgets/app_button.dart';
import 'package:fee_easy/core/widgets/app_input_field.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/widgets/app_search_field.dart';
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
            const InstituteAppBar(title: 'Log Attendance'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.all24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      label: 'SELECT STAFF MEMBER',
                      child: Obx(() {
                        if (controller.selectedLogStaff.value != null) {
                          return _buildSelectedStaffCard(
                            controller.selectedLogStaff.value!,
                          );
                        } else {
                          return _buildStaffSearchField();
                        }
                      }),
                    ),
                    AppSpacing.v20,
                    Obx(
                      () => AppInputField(
                        label: 'SELECT DATE',
                        hint: 'MM/dd/yyyy',
                        icon: Icons.calendar_today_rounded,
                        controller: TextEditingController(
                          text: DateFormat(
                            'MM/dd/yyyy',
                          ).format(controller.selectedLogDate.value),
                        ),
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
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
                    Text(
                      'ATTENDANCE STATUS',
                      style: AppTextStyles.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    AppSpacing.v12,
                    _buildStatusToggle(),
                    AppSpacing.v24,
                    AppInputField(
                      label: 'ADDITIONAL NOTES',
                      controller: controller.logNotesController,
                      hint: 'Any overtime details or shift adjustments...',
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

  Widget _buildSectionCard({required String label, required Widget child}) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          AppSpacing.v12,
          child,
        ],
      ),
    );
  }

  Widget _buildStaffSearchField() {
    return Column(
      children: [
        AppSearchField(
          hintText: 'Search by name or role...',
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
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
                    style: AppTextStyles.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    staff.role?.name ?? "",
                    style: AppTextStyles.lexend(
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
        color: AppColors.paleSilver.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
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
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  staff.role?.name ?? "",
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.removeLogStaff(),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.bohoRed,
              size: 20,
            ),
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
                AppColors.textMuted,
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
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? color : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? color : AppColors.textTertiary,
            size: 28,
          ),
          AppSpacing.v12,
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isSelected ? color : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogButton() {
    return Obx(
      () => AppButton(
        onPressed: () => controller.saveAttendanceRecord(),
        label: 'Log Attendance',
        icon: Icons.check_circle_outline_rounded,
        isLoading: controller.isSaving.value,
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
          style: AppTextStyles.manrope(
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
