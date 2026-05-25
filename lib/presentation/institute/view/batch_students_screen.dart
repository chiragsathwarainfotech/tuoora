import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/institute/controllers/batch_details_controller.dart';
import 'package:tuoora/presentation/institute/models/batch_model.dart';
import 'package:tuoora/presentation/institute/widgets/institute_app_bar.dart';
import 'package:tuoora/presentation/institute/widgets/institute_bottom_button.dart';
import 'package:tuoora/core/widgets/common_dialog.dart';
import 'package:tuoora/core/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchStudentsScreen extends StatelessWidget {
  const BatchStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BatchModel batch = Get.arguments;
    final BatchDetailsController controller = Get.find<BatchDetailsController>(
      tag: batch.id,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Batch Students'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  children: [
                    _buildEnrolledHeader(controller),
                    AppSpacing.v24,
                    _buildSearchBar(controller),
                    AppSpacing.v24,
                    _buildAssignedStudentList(controller, context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InstituteBottomButton(
        label: 'Assign Student',
        icon: Icons.person_add_alt_1_rounded,
        onTap: () => Get.toNamed(
          AppRoutes.instituteAssignToBatch,
          arguments: controller.batch,
        ),
      ),
    );
  }

  Widget _buildEnrolledHeader(BatchDetailsController controller) {
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
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL ENROLLED',
                  style: AppTextStyles.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 1,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  '${controller.assignedStudents.length}',
                  style: AppTextStyles.manrope(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryBrand,
                  ),
                ),
              ],
            ),
            _buildAvatarStack(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(BatchDetailsController controller) {
    return SizedBox(
      height: 40,
      width: 100,
      child: Stack(
        children: [
          ...List.generate(
            controller.assignedStudents.length > 3
                ? 3
                : controller.assignedStudents.length,
            (index) => Positioned(
              left: index * 25.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: [
                    AppColors.warningBg,
                    AppColors.successBg,
                    AppColors.greenBg,
                  ][index % 3],
                  child: Text(
                    controller.assignedStudents[index].student.name[0],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDarkGrey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (controller.assignedStudents.length > 3)
            Positioned(
              left: 75,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.borderGrey,
                  child: Text(
                    '+${controller.assignedStudents.length - 3}',
                    style: AppTextStyles.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BatchDetailsController controller) {
    return AppSearchField(
      hintText: 'Search enrolled students...',
      controller: controller.assignedSearchController,
      onChanged: (val) => controller.assignedSearchQuery.value = val,
    );
  }

  Widget _buildAssignedStudentList(
    BatchDetailsController controller,
    BuildContext context,
  ) {
    return Obx(() {
      final students = controller.filteredAssignedStudents;
      if (students.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'No students found',
              style: AppTextStyles.lexend(color: AppColors.textMuted),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final bs = students[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: AppSpacing.all12,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStudentAvatar(
                  bs.student.profileImageUrl,
                  bs.student.name,
                ),
                AppSpacing.h16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bs.student.name,
                        style: AppTextStyles.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'ID: ${bs.student.id}',
                        style: AppTextStyles.lexend(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _showRemoveConfirmation(context, controller, bs),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.bohoRed,
                    size: 24,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showRemoveConfirmation(
    BuildContext context,
    BatchDetailsController controller,
    BatchStudent bs,
  ) {
    CommonDialog.showDeleteConfirmation(
      title: 'Remove Student',
      description:
          'Are you sure you want to remove\n${bs.student.name} from this batch?',
      confirmText: 'Remove',
      onConfirm: () => controller.removeStudentFromBatch(bs.student.id),
    );
  }

  Widget _buildStudentAvatar(String? imageUrl, String name) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com')) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primaryBrandLight,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0].toUpperCase();
      if (names.length > 1) {
        initials += names[names.length - 1][0].toUpperCase();
      }
    }

    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.primaryBrandLight,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBrand,
          ),
        ),
      ),
    );
  }
}
