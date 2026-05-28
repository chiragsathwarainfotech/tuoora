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
                      child: _buildIdCard(
                        name: name,
                        id: id,
                        imageUrl: imageUrl,
                        grade: grade,
                        student: student,
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

  // ───────── Full Student ID-Card layout matching the reference design:
  //   - WHITE top half with the institute name + tagline
  //   - DIAGONAL brand-orange ribbons at the seam
  //   - HEXAGONAL photo straddling the seam
  //   - DARK BROWN (brandAppBarColor) bottom half carrying the name +
  //     "Standard X" designation + a label : value info table.
  // Purple in the reference is swapped for our brand orange so the card
  // sits in the app's existing colour rhythm.
  Widget _buildIdCard({
    required String name,
    required String id,
    required String imageUrl,
    required String grade,
    required Student? student,
  }) {
    const double topHeight = 160;
    const double hexagonSize = 116;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // (1) Base column — white top, dark bottom. The dark bottom is
            // auto-height; padding-top is reserved so the hexagon photo
            // (which floats over the seam) doesn't collide with the name.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIdCardTopHalf(topHeight),
                _buildIdCardBottomHalf(
                  name: name,
                  id: id,
                  grade: grade,
                  student: student,
                  topPadding: hexagonSize * 0.55,
                ),
              ],
            ),
            // (2) Diagonal brand-orange ribbons at the seam.
            Positioned(
              top: topHeight - 24,
              left: 0,
              right: 0,
              height: 80,
              child: IgnorePointer(child: _buildDiagonalRibbons()),
            ),
            // (3) Hexagonal photo centred over the seam.
            Positioned(
              top: topHeight - hexagonSize / 2,
              left: 0,
              right: 0,
              child: Center(
                child: _buildHexagonAvatar(
                  imageUrl: imageUrl,
                  name: name,
                  size: hexagonSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // White top half: institute name (dark) + tagline (brand orange).
  Widget _buildIdCardTopHalf(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'TUOORA INSTITUTE',
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'STUDENT IDENTITY CARD',
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBrand,
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  // Two slanted brand-orange ribbons that mimic the angled stripes in the
  // reference image. One full-width primary stripe and a thinner darker
  // stripe just below for depth.
  Widget _buildDiagonalRibbons() {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Transform.translate(
          offset: const Offset(0, 14),
          child: Transform.rotate(
            angle: -0.10,
            child: Container(
              height: 28,
              color: AppColors.brandAppBarColor,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 6),
          child: Transform.rotate(
            angle: -0.10,
            child: Container(
              height: 22,
              color: AppColors.primaryBrand,
            ),
          ),
        ),
      ],
    );
  }

  // Dark bottom half — name, designation chip, then label : value info rows.
  Widget _buildIdCardBottomHalf({
    required String name,
    required String id,
    required String grade,
    required Student? student,
    required double topPadding,
  }) {
    return Container(
      width: double.infinity,
      color: AppColors.brandAppBarColor,
      padding: EdgeInsets.fromLTRB(28, topPadding, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              name.isEmpty ? '—' : name,
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Standard $grade',
              textAlign: TextAlign.center,
              style: AppTextStyles.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBrand,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 22),
          _buildIdInfoRow('ID No', id.isEmpty ? '—' : id),
          _buildIdInfoRow(
            'DOB',
            student?.dob ?? 'Not Specified',
          ),
          _buildIdInfoRow(
            'Phone',
            student?.phone ?? 'Not Available',
          ),
          _buildIdInfoRow(
            'Email',
            student?.email ?? 'Not Available',
          ),
          const SizedBox(height: 10),
          _buildIdInfoRow(
            'Parent',
            student?.guardianName ?? 'Not Specified',
          ),
        ],
      ),
    );
  }

  // "Label  : value" row in white text — uses a fixed-width label column so
  // every colon lines up vertically the way it does on the reference.
  Widget _buildIdInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          Text(
            ': ',
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hexagonal photo container clipped via [_HexagonClipper]. Renders the
  // student's profile picture when one is available, otherwise their
  // initials on a light brand background. Wrapped in a slightly bigger
  // hexagon in brand orange so the photo reads with a coloured border.
  Widget _buildHexagonAvatar({
    required String imageUrl,
    required String name,
    required double size,
  }) {
    final bool hasPhoto =
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('http') &&
        !imageUrl.contains('ui-avatars.com');

    return ClipPath(
      clipper: _HexagonClipper(),
      child: Container(
        width: size,
        height: size,
        color: AppColors.primaryBrand,
        padding: const EdgeInsets.all(4),
        child: ClipPath(
          clipper: _HexagonClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBrandLight,
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

// Vertically-oriented regular hexagon used for the ID-card photo. Points
// face top and bottom; the flat sides face left and right.
class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.25)
      ..lineTo(w, h * 0.75)
      ..lineTo(w * 0.5, h)
      ..lineTo(0, h * 0.75)
      ..lineTo(0, h * 0.25)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
