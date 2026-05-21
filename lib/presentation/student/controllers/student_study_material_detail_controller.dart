import 'package:get/get.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';
import 'package:tuoora/config/app_routes.dart';

class StudentStudyMaterialDetailController extends GetxController {
  final Map<String, dynamic> material = Get.arguments ?? {
    'subject': 'Mathematics',
    'date': 'Today',
    'title': 'Trigonometry — quick reference',
    'description': 'All Class X trig identities, complementary-angle formulas, and sign chart on one page. Print and stick inside your notebook.',
    'fileCount': 1,
    'isVideo': false,
    'teacher': 'Mr. R. Verma',
    'subjectBgColor': 0xFFFEF2F2,
    'subjectTextColor': 0xFF991B1B,
  };

  final attachments = <AssignmentAttachment>[
    const AssignmentAttachment(
      id: 'doc_1',
      name: 'Trig identities cheat sheet.pdf',
      sizeLabel: '180 KB',
      kind: AssignmentAttachmentKind.document,
      pageCount: 3,
    ),
    const AssignmentAttachment(
      id: 'vid_1',
      name: 'Reflection concepts.mp4',
      sizeLabel: '38 MB',
      kind: AssignmentAttachmentKind.video,
      durationLabel: '6:02',
    ),
    const AssignmentAttachment(
      id: 'img_1',
      name: 'Functional groups chart.png',
      sizeLabel: '720 KB',
      kind: AssignmentAttachmentKind.image,
    ),
  ];

  void openAttachment(AssignmentAttachment attachment) {
    if (!Get.isRegistered<AssignmentsController>()) {
      Get.put(AssignmentsController());
    }
    final assignmentsCtrl = Get.find<AssignmentsController>();
    assignmentsCtrl.selectedAttachment.value = attachment;
    Get.toNamed(AppRoutes.studentAttachmentPreview);
  }
}
