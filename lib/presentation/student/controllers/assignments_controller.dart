import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/data/repositories/student_homework_repository.dart';
import 'package:tuoora/presentation/student/controllers/attachment_preview_controller.dart';

class AssignmentsController extends GetxController {
  final RxInt activeTab = 0.obs;

  final RxList<Assignment> pending = <Assignment>[].obs;
  final RxList<Assignment> completed = <Assignment>[].obs;

  final Rxn<Assignment> selectedAssignment = Rxn<Assignment>();

  final Rxn<AssignmentAttachment> selectedAttachment =
      Rxn<AssignmentAttachment>();

  final RxBool isLoading = true.obs;
  final RxBool isDetailLoading = false.obs;
  final RxBool isAttachmentLoading = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  late StudentHomeworkRepository _repository;

  final RxInt weeklyRemaining = 0.obs;
  final RxInt weeklyTotal = 0.obs;
  final RxInt weeklyCompleted = 0.obs;
  final RxInt weeklyOverdue = 0.obs;
  final RxString teacherName = 'Institute'.obs;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentHomeworkRepository(Get.find<ApiClient>());
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    try {
      isLoading.value = true;
      final data = await _repository.getHomeworks();
      pending.assignAll(data.pending);
      completed.assignAll(data.completed);

      weeklyTotal.value = data.summary.total;
      weeklyRemaining.value = data.summary.pending;
      weeklyCompleted.value = data.summary.completed;
      weeklyOverdue.value = data.summary.overdue;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load assignments');
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    if (index < 0 || index > 1 || activeTab.value == index) return;
    activeTab.value = index;
  }

  Future<void> openAssignment(Assignment assignment) async {
    selectedAssignment.value = assignment;
    Get.toNamed(AppRoutes.studentAssignmentDetail);

    try {
      isDetailLoading.value = true;
      final int id = int.parse(assignment.id);
      final detail = await _repository.getHomeworkDetail(id);
      selectedAssignment.value = detail;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load assignment details');
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// Opens the assignment detail screen for [id] alone — used by
  /// notification taps where we only have the homework id and not a
  /// pre-built [Assignment] from the list.
  Future<void> openAssignmentById(int id) async {
    selectedAssignment.value = null;
    Get.toNamed(AppRoutes.studentAssignmentDetail);

    try {
      isDetailLoading.value = true;
      final detail = await _repository.getHomeworkDetail(id);
      selectedAssignment.value = detail;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load assignment details');
    } finally {
      isDetailLoading.value = false;
    }
  }

  void openAttachment(AssignmentAttachment attachment) {
    final assignment = selectedAssignment.value;
    if (assignment == null) return;

    Get.toNamed(
      AppRoutes.studentAttachmentPreview,
      arguments: AttachmentPreviewArgs(
        attachment: attachment,
        sourceType: AttachmentSourceType.assignment,
        sourceId: assignment.id,
        onLoadPreview: () async {
          final int id = int.parse(assignment.id);
          final attachmentDetail = await _repository.getHomeworkAttachment(id);

          final ctrl = Get.find<AttachmentPreviewController>();
          ctrl.selectedAttachment.value = AssignmentAttachment(
            id: attachment.id,
            name: attachment.name,
            sizeLabel: attachmentDetail.fileSize,
            kind: attachment.kind,
            url: attachmentDetail.previewUrl,
            extensionLabel: attachmentDetail.extension,
          );
        },
      ),
    );
  }

  List<Assignment> get activeItems =>
      activeTab.value == 0 ? pending : completed;
}
