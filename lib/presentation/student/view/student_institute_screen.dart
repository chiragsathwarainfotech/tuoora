import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentInstituteScreen extends StatelessWidget {
  const StudentInstituteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        child: Column(
          children: [
            const StudentAppBar(
              title: 'Institute',
              showDefaultActions: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 16),
                    _buildContactCard(),
                    const SizedBox(height: 16),
                    _buildChatButton(),
                    const SizedBox(height: 32),
                    Text(
                      'LOCATION',
                      style: AppTextStyles.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildMapCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFF334155),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              'SC',
              style: AppTextStyles.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Saraswati Coaching Centre',
            style: AppTextStyles.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Contact person', 'Mr. R. Verma'),
          Divider(height: 1, color: AppColors.borderGrey.withOpacity(0.5)),
          _buildInfoRow('Phone', '+91  20  4123  7700'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.lexend(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton() {
    return ElevatedButton(
      onPressed: () => Get.toNamed(AppRoutes.studentChat),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF92400E),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Chat with institute',
            style: AppTextStyles.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // The map image placeholder
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Stack(
              children: [
                // Draw some decorative lines and blocks to mimic a map
                Positioned.fill(
                  child: CustomPaint(
                    painter: MapBackgroundPainter(),
                  ),
                ),
                // Map marker
                Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 40,
                    color: const Color(0xFF92400E),
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Location details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.domain_rounded,
                    color: Color(0xFF78350F),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lane 5, Koregaon Park',
                        style: AppTextStyles.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pune, Maharashtra 411001',
                        style: AppTextStyles.lexend(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    side: BorderSide(color: AppColors.borderGrey.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Directions',
                        style: AppTextStyles.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final blockPaint = Paint()
      ..color = const Color(0xFFBBF7D0)
      ..style = PaintingStyle.fill;

    // Draw horizontal road
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.45), roadPaint);
    
    // Draw vertical roads
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.25, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.75, 0), Offset(size.width * 0.8, size.height), roadPaint);

    // Draw some green blocks
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.05, size.height * 0.6, 60, 40), const Radius.circular(4)),
        blockPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.45, size.height * 0.6, 80, 40), const Radius.circular(4)),
        blockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
