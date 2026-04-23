import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_details_controller.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchDetailsScreen extends StatefulWidget {
  const BatchDetailsScreen({super.key});

  @override
  State<BatchDetailsScreen> createState() => _BatchDetailsScreenState();
}

class _BatchDetailsScreenState extends State<BatchDetailsScreen> {
  late BatchDetailsController controller;
  final BatchController batchController = Get.find<BatchController>();

  @override
  void initState() {
    super.initState();
    final BatchModel batch = Get.arguments;
    controller = Get.put(BatchDetailsController(batch), tag: batch.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            InstituteAppBar(
              title: 'Batch Details',
              actions: [
                IconButton(
                  onPressed: () {
                    batchController.initEditMode(controller.batch);
                    Get.toNamed(AppRoutes.instituteEditBatch);
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.instAccentBlue,
                  ),
                ),
                IconButton(
                  onPressed: () => _showDeleteBatchConfirmation(context),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFD92D20),
                  ),
                ),
                AppSpacing.h8,
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBatchHeader(),
                    AppSpacing.v32,
                    _buildStudentListHeader(),
                    AppSpacing.v16,
                    _buildAssignedSearchBar(),
                    AppSpacing.v16,
                    _buildStudentList(),
                    AppSpacing.v32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchHeader() {
    final batch = controller.batch;
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s10,
                  vertical: AppSpacing.s6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.instBatchTagBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.instActiveBatchTag,
                  style: AppTextStyles.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.instBatchTagText,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              AppSpacing.h12,
              Text(
                'ID: #${batch.id.length > 4 ? batch.id.substring(0, 4) : batch.id}',
                style: AppTextStyles.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          AppSpacing.v16,
          Text(
            batch.title,
            style: AppTextStyles.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.instPrimaryBlue,
            ),
          ),
          AppSpacing.v8,
          Text(
            batch.description,
            style: AppTextStyles.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          AppSpacing.v24,
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniCard(
                  AppStrings.instStudentsCountLabel,
                  '${controller.assignedStudents.length}',
                ),
              ),
              AppSpacing.h16,
              Expanded(
                child: _buildMetricMiniCard(
                  'Batch Fee',
                  '₹${batch.baseFee.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricMiniCard(String label, String value) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.v4,
          Text(
            value,
            style: AppTextStyles.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.instAccentBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.instStudentListLabel,
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: () => _showAddStudentDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.instPrimaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
                AppSpacing.h8,
                Text(
                  'Add',
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignedSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.assignedSearchController,
        onChanged: (val) => controller.assignedSearchQuery.value = val,
        decoration: InputDecoration(
          hintText: 'Search assigned students...',
          hintStyle: AppTextStyles.lexend(fontSize: 14, color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 20),
          suffixIcon: Obx(() => controller.assignedSearchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    controller.assignedSearchController.clear();
                    controller.assignedSearchQuery.value = '';
                  },
                )
              : const SizedBox.shrink()),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  void _showDeleteBatchConfirmation(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: AppSpacing.all32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: AppSpacing.all16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Color(0xFFD92D20),
                  size: 32,
                ),
              ),
              AppSpacing.v24,
              Text(
                'Delete Batch',
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v12,
              Text(
                'Are you sure you want to delete\n${controller.batch.title}?',
                textAlign: TextAlign.center,
                style: AppTextStyles.lexend(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textTertiary,
                ),
              ),
              AppSpacing.v32,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: AppSpacing.y16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.h12,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // close dialog
                        batchController.deleteBatch(controller.batch.id);
                        Get.back(); // go back from screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD92D20),
                        padding: AppSpacing.y16,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Yes, Delete',
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    controller.clearSearch();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: double.infinity,
          padding: AppSpacing.all24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Student to Batch',
                style: AppTextStyles.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.v20,
              _buildSearchField(),
              AppSpacing.v16,
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Obx(() {
                  if (controller.searchResults.isNotEmpty) {
                    return _buildSearchResults();
                  }
                  if (controller.selectedStudent.value != null) {
                    return _buildFeeEntryForm();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.search, size: 48, color: Colors.grey.shade300),
                        AppSpacing.v12,
                        Text(
                          'Search students by name or ID',
                          style: AppTextStyles.lexend(
                            fontSize: 14,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.searchStudents,
        decoration: InputDecoration(
          hintText: 'Search student by name or ID...',
          hintStyle: AppTextStyles.lexend(fontSize: 14, color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
          border: InputBorder.none,
          contentPadding: AppSpacing.all16,
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final student = controller.searchResults[index];
          return ListTile(
            title: Text(student.name, style: AppTextStyles.manrope(fontWeight: FontWeight.w700)),
            subtitle: Text(student.id, style: AppTextStyles.lexend(fontSize: 12)),
            onTap: () => controller.selectStudent(student),
          );
        },
      ),
    );
  }

  Widget _buildFeeEntryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSpacing.v20,
        const Divider(),
        AppSpacing.v16,
        Text(
          'Set Batch Fee for ${controller.selectedStudent.value!.name}',
          style: AppTextStyles.manrope(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        AppSpacing.v12,
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller.feeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '₹ ',
              border: InputBorder.none,
              contentPadding: AppSpacing.all16,
            ),
          ),
        ),
        AppSpacing.v20,
        ElevatedButton(
          onPressed: controller.addStudentToBatch,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.instPrimaryBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Confirm Add to Batch',
            style: AppTextStyles.manrope(fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList() {
    return Obx(() {
      if (controller.assignedStudents.isEmpty) {
        return Container(
          padding: AppSpacing.all32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.group_off_rounded, size: 48, color: AppColors.textMuted),
              AppSpacing.v16,
              Text(
                'No students assigned to this batch yet.',
                textAlign: TextAlign.center,
                style: AppTextStyles.lexend(color: AppColors.textTertiary),
              ),
            ],
          ),
        );
      }
      
      final filteredList = controller.filteredAssignedStudents;
      if (filteredList.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No matching students found.',
              style: AppTextStyles.lexend(color: AppColors.textTertiary),
            ),
          ),
        );
      }

      return Column(
        children: filteredList.map((bs) => _buildStudentItem(bs)).toList(),
      );
    });
  }

  Widget _buildStudentItem(BatchStudent bs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.instFeesAvatarBg,
            child: Text(bs.student.name[0], style: const TextStyle(fontWeight: FontWeight.bold)),
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
                  bs.student.id,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${bs.assignedFee.toStringAsFixed(0)}',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.instAccentBlue,
                ),
              ),
              Text(
                'Batch Fee',
                style: AppTextStyles.lexend(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
