import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
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
  final RxBool isSubmitting = false.obs;
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
      // Newest-created first; assignments with no createdAt fall to the
      // bottom (still stable amongst themselves).
      int byNewest(Assignment a, Assignment b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      }

      pending.assignAll(List.of(data.pending)..sort(byNewest));
      completed.assignAll(List.of(data.completed)..sort(byNewest));

      weeklyTotal.value = data.summary.total;
      weeklyRemaining.value = data.summary.pending;
      weeklyCompleted.value = data.summary.completed;
      weeklyOverdue.value = data.summary.overdue;
    } catch (e) {
      AppSnackBar.error(AppStrings.failedToLoadAssignments);
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
      AppSnackBar.error(AppStrings.failedToLoadAssignmentDetails);
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> openAssignmentById(int id) async {
    selectedAssignment.value = null;
    Get.toNamed(AppRoutes.studentAssignmentDetail);

    try {
      isDetailLoading.value = true;
      final detail = await _repository.getHomeworkDetail(id);
      selectedAssignment.value = detail;
    } catch (e) {
      AppSnackBar.error(AppStrings.failedToLoadAssignmentDetails);
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

  /// Marks the currently-open assignment as submitted. On success the local
  /// pending/completed lists are reshuffled and the detail view reflects
  /// the new state immediately — no full reload needed.
  Future<void> submitCurrentAssignment() async {
    final assignment = selectedAssignment.value;
    if (assignment == null || isSubmitting.value) return;
    try {
      isSubmitting.value = true;
      final id = int.tryParse(assignment.id) ?? 0;
      await _repository.submitHomework(id);

      // Optimistically flip the assignment from pending → completed locally
      // so the user sees the change without waiting for a fresh fetch.
      pending.removeWhere((a) => a.id == assignment.id);
      final submitted = Assignment(
        id: assignment.id,
        title: assignment.title,
        subjectLabel: assignment.subjectLabel,
        dueLabel: assignment.dueLabel,
        icon: assignment.icon,
        stripe: assignment.stripe,
        iconBg: assignment.iconBg,
        iconColor: assignment.iconColor,
        badge: AssignmentBadge.done,
        dueDateFullText: assignment.dueDateFullText,
        instructions: assignment.instructions,
        assignedBy: assignment.assignedBy,
        attachments: assignment.attachments,
        pendingNote: null,
        completedNote: 'Status: Submitted',
        gradeNote: assignment.gradeNote,
      );
      completed.insert(0, submitted);
      selectedAssignment.value = submitted;
      weeklyCompleted.value++;
      if (weeklyRemaining.value > 0) weeklyRemaining.value--;

      AppSnackBar.success(AppStrings.assignmentSubmittedSuccessfully);
    } catch (e) {
      AppSnackBar.error(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSubmitting.value = false;
    }
  }

  List<Assignment> get activeItems =>
      activeTab.value == 0 ? pending : completed;
}
