import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:get/get.dart';

class HomeworkRatingController extends GetxController {
  final HomeworkModel homework;
  
  final filterIndex = 0.obs; // 0: All, 1: Submitted, 2: Missing/Pending, 3: Late
  final submissions = <HomeworkSubmission>[].obs;

  HomeworkRatingController(this.homework);

  @override
  void onInit() {
    super.onInit();
    submissions.assignAll(homework.submissions);
  }

  List<HomeworkSubmission> get filteredSubmissions {
    if (filterIndex.value == 0) return submissions;
    if (filterIndex.value == 1) return submissions.where((s) => s.isSubmitted && !s.isLate).toList();
    if (filterIndex.value == 2) return submissions.where((s) => !s.isSubmitted).toList();
    if (filterIndex.value == 3) return submissions.where((s) => s.isLate).toList();
    return submissions;
  }

  void updateScore(String studentId, double newScore) {
    final index = submissions.indexWhere((s) => s.student.id == studentId);
    if (index != -1) {
      submissions[index].score = newScore;
      submissions.refresh();
    }
  }

  void saveAllRatings() {
    // In a real app, send to API
    Get.back();
    Get.snackbar('Success', 'All ratings saved successfully');
  }

  void sendReminder(String studentId) {
    Get.snackbar('Reminder Sent', 'A reminder has been sent to the student.');
  }
}
