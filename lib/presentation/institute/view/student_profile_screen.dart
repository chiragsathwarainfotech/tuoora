import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_images.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/data/models/student_model.dart';
import 'package:tuoora/presentation/institute/controllers/institute_profile_controller.dart';
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
                          _buildIdCard(
                            name: name,
                            id: id,
                            imageUrl: imageUrl,
                            grade: grade,
                            student: student,
                          ),
                          if (student != null && student.fees.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.s24),
                            _buildFeesSection(student.fees),
                          ],
                          const SizedBox(height: AppSpacing.s24),
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

  // Simple, professional Student ID card:
  //   - Brand-orange header strip with institute name + "STUDENT IDENTITY CARD"
  //   - Circular avatar centred just under the strip
  //   - Student name + "Standard X" tag below the avatar
  //   - Clean info rows (label / value) separated by light dividers
  // Whole card sits on white with a subtle shadow and 16 dp radius.
  Widget _buildIdCard({
    required String name,
    required String id,
    required String imageUrl,
    required String grade,
    required Student? student,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIdHeader(),
            const SizedBox(height: AppSpacing.s16),
            _buildCircleAvatar(imageUrl: imageUrl, name: name, size: 96),
            const SizedBox(height: AppSpacing.s12),
            _buildNameBlock(name: name, grade: grade),
            const SizedBox(height: AppSpacing.s16),
            _buildInfoTable(id: id, student: student),
            // Fee reminder button — only when this student actually owes
            // money. Tapping it POSTs to the fee-reminder endpoint and
            // the student app receives a push notification.
            if ((student?.totalDue ?? 0) > 0) ...[
              const SizedBox(height: AppSpacing.s4),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20,
                  0,
                  AppSpacing.s20,
                  AppSpacing.s16,
                ),
                child: _buildFeeReminderButton(student!.totalDue),
              ),
            ] else
              const SizedBox(height: AppSpacing.s16),
          ],
        ),
      ),
    );
  }

  // Solid brand-orange CTA inside the ID card. Disables itself while the
  // API call is in flight to prevent double-sends.
  Widget _buildFeeReminderButton(num totalDue) {
    return Obx(() {
      final sending = controller.isSendingFeeReminder.value;
      return Material(
        color: sending
            ? AppColors.primaryBrand.withValues(alpha: 0.6)
            : AppColors.primaryBrand,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: InkWell(
          onTap: sending ? null : controller.sendFeeReminder,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (sending)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.white),
                    ),
                  )
                else
                  const Icon(
                    Icons.notifications_active_rounded,
                    size: 18,
                    color: AppColors.white,
                  ),
                AppSpacing.h12,
                Text(
                  sending
                      ? 'Sending Reminder...'
                      : 'Send Fee Reminder  •  ₹${totalDue.toStringAsFixed(0)}',
                  style: AppTextStyles.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Compact fees list shown below the ID card. Each tile shows the date,
  // amount, and a status badge in the institute-side StatusBadge style.
  Widget _buildFeesSection(List<StudentFee> fees) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s20,
              AppSpacing.s16,
              AppSpacing.s20,
              AppSpacing.s8,
            ),
            child: Text(
              'FEES HISTORY',
              style: AppTextStyles.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.fieldLabel,
                letterSpacing: 1.2,
              ),
            ),
          ),
          for (var i = 0; i < fees.length; i++) ...[
            if (i > 0) Divider(height: 1, color: AppColors.fieldBorder),
            _buildFeeRow(fees[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildFeeRow(StudentFee fee) {
    final isPaid = fee.status.toLowerCase() == 'paid';
    final badgeColor = isPaid ? AppColors.successGreen : AppColors.bohoRed;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${fee.totalAmount}',
                  style: AppTextStyles.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fee.date,
                  style: AppTextStyles.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s10,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Text(
              fee.status.toUpperCase(),
              style: AppTextStyles.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Orange header strip with the institute name (pulled from the logged-in
  // profile when available) and the "STUDENT IDENTITY CARD" tagline.
  Widget _buildIdHeader() {
    String resolvedName = 'Tuoora Institute';
    if (Get.isRegistered<InstituteProfileController>()) {
      final v = Get.find<InstituteProfileController>().instituteName.value
          .trim();
      if (v.isNotEmpty) resolvedName = v;
    }
    return Container(
      width: double.infinity,
      color: AppColors.primaryBrand,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            resolvedName.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'STUDENT IDENTITY CARD',
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.white.withValues(alpha: 0.9),
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // Student name (bold dark) + a "Standard X" tag below in brand orange.
  Widget _buildNameBlock({required String name, required String grade}) {
    return Column(
      children: [
        Text(
          name.isEmpty ? '—' : name,
          textAlign: TextAlign.center,
          style: AppTextStyles.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryBrandLight,
            borderRadius: BorderRadius.circular(AppSpacing.s12),
          ),
          child: Text(
            'Standard ${grade.isEmpty ? '—' : grade}',
            style: AppTextStyles.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryBrand,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }

  // The label / value information table.
  Widget _buildInfoTable({required String id, required Student? student}) {
    final rows = <(String, String)>[
      ('ID No', id.isEmpty ? '—' : id),
      ('DOB', student?.dob ?? 'Not Specified'),
      ('Phone', student?.phone ?? 'Not Available'),
      ('Email', student?.email ?? 'Not Available'),
      ('Parent', student?.guardianName ?? 'Not Specified'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                color: AppColors.fieldBorder,
              ),
            _buildIdInfoRow(rows[i].$1, rows[i].$2),
          ],
        ],
      ),
    );
  }

  // Single info row — label on the left in muted slate, value on the right
  // in textPrimary. Vertically padded so dividers between rows breathe.
  Widget _buildIdInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.fieldLabel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Circular avatar with a primary-brand ring. Shows the student's photo
  // when available, otherwise initials on a soft brand background.
  Widget _buildCircleAvatar({
    required String imageUrl,
    required String name,
    required double size,
  }) {
    final bool hasPhoto =
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryBrandLight,
        border: Border.all(color: AppColors.primaryBrand, width: 3),
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
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
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

  void _showDeleteConfirmation(BuildContext context, String studentName) {
    CommonDialog.showDeleteConfirmation(
      title: 'Delete Student',
      description: 'Are you sure you want to delete\n$studentName?',
      onConfirm: () => controller.deleteStudent(),
    );
  }
}
