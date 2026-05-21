import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/presentation/student/controllers/student_study_material_detail_controller.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';
import 'package:tuoora/presentation/student/widgets/student_attachment_tile.dart';

class StudentStudyMaterialDetailScreen extends GetView<StudentStudyMaterialDetailController> {
  const StudentStudyMaterialDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final material = controller.material;
    
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        child: Column(
          children: [
            StudentAppBar(
              title: material['title'],
              showDefaultActions: false,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildHeaderCard(material),
                  const SizedBox(height: 24),
                  Text(
                    'FILES',
                    style: AppTextStyles.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...controller.attachments.map((attachment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: StudentAttachmentTile(
                        attachment: attachment,
                        onTap: () => controller.openAttachment(attachment),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(item['subjectBgColor']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['subject'],
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(item['subjectTextColor']),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item['teacher']} · ${item['date']}',
                style: AppTextStyles.lexend(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item['description'],
            style: AppTextStyles.lexend(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
