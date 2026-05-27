import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/data/models/student_model.dart';
import 'package:tuoora/presentation/institute/controllers/student_controller.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_action_icon.dart';
import 'package:tuoora/core/widgets/common_dialog.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentProfileScreen extends GetView<InstituteStudentController> {
  final bool showBottomNav;
  const StudentProfileScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              final student = controller.currentStudent.value;
              final name = student?.name ?? "";
              final id = student?.id.toString() ?? "";
              final imageUrl = student?.imageUrl ?? "";
              final grade = student?.grade ?? '-';
              return Column(
                children: [
                  InstituteAppBar(
                    title: AppStrings.instStudentProfileTitle,
                    actions: [
                      IconButton(
                        onPressed: () => Get.toNamed(
                          AppRoutes.instituteAddEditStudent,
                          arguments: {
                            'studentId': id,
                            'student': student?.toJson(),
                          },
                        ),
                        icon: const AppActionIcon(asset: AppImages.icEdit),
                      ),
                      IconButton(
                        onPressed: () => _showDeleteConfirmation(context, name),
                        icon: const AppActionIcon(asset: AppImages.icDelete),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: AppSpacing.all16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProfileHeader(name, id, imageUrl, grade),
                          AppSpacing.v24,
                          _buildInformationSection(student),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
            Obx(
              () => controller.isLoading.value
                  ? Container(
                      color: Colors.black26,
                      child: const CommonLoading(color: AppColors.white),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── Flat profile header: avatar + name + meta lines.
  Widget _buildProfileHeader(
    String name,
    String id,
    String imageUrl,
    String grade,
  ) {
    return Row(
      children: [
        _buildStudentAvatar(imageUrl, name),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? '—' : name,
                style: AppTextStyles.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v4,
              Text(
                'ID: $id',
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                'Standard: $grade',
                style: AppTextStyles.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentAvatar(String imageUrl, String name) {
    final hasPhoto = imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com');

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryBrandLight,
        shape: BoxShape.circle,
        image: hasPhoto
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: hasPhoto
          ? null
          : Center(
              child: Text(
                _initialsFor(name),
                style: AppTextStyles.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBrand,
                ),
              ),
            ),
    );
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // ───────── Flat info section: section header + key/value rows with
  // thin dividers. No card chrome.
  Widget _buildInformationSection(Student? student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.assignment_ind_rounded,
              color: AppColors.primaryBrand,
              size: 20,
            ),
            AppSpacing.h12,
            Text(
              AppStrings.instAcademicContactInfo,
              style: AppTextStyles.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBrand,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        AppSpacing.v16,
        _buildInfoField(
          AppStrings.instStudentDobLabel,
          student?.dob ?? 'Not Specified',
        ),
        _buildInfoField(
          AppStrings.instParentNameLabel,
          student?.guardianName ?? 'Not Specified',
        ),
        _buildInfoField(
          AppStrings.instPhoneLabel,
          student?.phone ?? 'Not Available',
        ),
        _buildInfoField(
          'Email',
          student?.email ?? 'Not Available',
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String value, {bool isLast = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
              AppSpacing.v4,
              Text(
                value,
                style: AppTextStyles.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.6),
          ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String studentName) {
    CommonDialog.showDeleteConfirmation(
      title: 'Delete Student',
      description: 'Are you sure you want to delete\n$studentName?',
      onConfirm: () => controller.deleteStudent(),
    );
  }
}
