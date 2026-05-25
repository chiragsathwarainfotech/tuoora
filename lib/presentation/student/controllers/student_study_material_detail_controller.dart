import 'package:get/get.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/data/models/student_resource_model.dart';
import 'package:tuoora/presentation/student/controllers/attachment_preview_controller.dart';

class StudentStudyMaterialDetailController extends GetxController {
  late final StudentResourceModel material;
  late final List<AssignmentAttachment> attachments;

  @override
  void onInit() {
    super.onInit();
    material = Get.arguments as StudentResourceModel;

    // Convert the single file into an AssignmentAttachment so we can reuse the tile
    attachments = [
      AssignmentAttachment(
        id: material.id.toString(),
        name: material.fileUrl.split('/').last,
        sizeLabel: material.fileSize,
        kind: _getKind(material.fileType),
        url: material.fileUrl,
      ),
    ];
  }

  AssignmentAttachmentKind _getKind(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('video')) return AssignmentAttachmentKind.video;
    if (lowerType.contains('image')) return AssignmentAttachmentKind.image;
    if (lowerType.contains('audio')) return AssignmentAttachmentKind.audio;
    return AssignmentAttachmentKind.document;
  }

  void openAttachment(AssignmentAttachment attachment) {
    Get.toNamed(
      AppRoutes.studentAttachmentPreview,
      arguments: AttachmentPreviewArgs(
        attachment: attachment,
        sourceType: AttachmentSourceType.resource,
        sourceId: material.id.toString(),
      ),
    );
  }
}
