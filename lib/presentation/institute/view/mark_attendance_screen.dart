import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/presentation/institute/widgets/institute_app_bar.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  // Using simple list for mock state
  final List<Map<String, dynamic>> students = [
    {
      'name': 'Aria Smith',
      'id': 'PHY-2023-001',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=aria',
    },
    {
      'name': 'Julian Chen',
      'id': 'PHY-2023-042',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=julian',
    },
    {
      'name': 'Elena Rodriguez',
      'id': 'PHY-2023-115',
      'isPresent': false,
      'avatar': 'https://i.pravatar.cc/150?u=elena',
    },
    {
      'name': 'Marcus Wright',
      'id': 'PHY-2023-089',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=marcus',
    },
    {
      'name': 'Sarah Jenkins',
      'id': 'PHY-2023-201',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=sarah',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const InstituteAppBar(title: 'Mark Attendance'),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.x24.add(AppSpacing.y16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBatchHeader(),
                    AppSpacing.v24,
                    _buildBulkActionButton(),
                    AppSpacing.v24,
                    _buildSearchBar(),
                    AppSpacing.v24,
                    ...students.map(
                      (student) => Padding(
                        padding: AppSpacing.bottom16,
                        child: _buildStudentCard(student),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.instBatchPhysics,
          style: AppTextStyles.manrope(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v4,
        Text(
          'October 24, 2023 • Tuesday',
          style: AppTextStyles.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBulkActionButton() {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          for (var s in students) {
            s['isPresent'] = true;
          }
        });
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: AppSpacing.y16,
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.done_all_rounded,
            color: Color(0xFF1E3A8A),
            size: AppSpacing.s20,
          ),
          AppSpacing.h8,
          Text(
            AppStrings.instMarkAllPresent,
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: AppSpacing.x16,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppColors.textMuted),
          hintText: AppStrings.instSearchStudentHintAlt,
          hintStyle: AppTextStyles.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Container(
      padding: AppSpacing.all16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB).withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(student['avatar']),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'ID: ${student['id']}',
                  style: AppTextStyles.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusToggle(student),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(Map<String, dynamic> student) {
    bool isPresent = student['isPresent'];
    return Container(
      height: AppSpacing.s36,
      decoration: BoxDecoration(
        color: AppColors.instStatusPickerBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => student['isPresent'] = true),
            child: Container(
              padding: AppSpacing.x12,
              decoration: BoxDecoration(
                color: isPresent ? const Color(0xFF1E3A8A) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                AppStrings.instStatusPresentRaw,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isPresent ? Colors.white : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => student['isPresent'] = false),
            child: Container(
              padding: AppSpacing.x12,
              decoration: BoxDecoration(
                color: !isPresent
                    ? const Color(0xFF7C2D12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                AppStrings.instStatusAbsentRaw,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: !isPresent ? Colors.white : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: AppSpacing.all24,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -AppSpacing.s4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Get.back(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF005AC1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, AppSpacing.s56),
          elevation: 0,
        ),
        child: Text(
          AppStrings.instSubmitAttendance,
          style: AppTextStyles.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
