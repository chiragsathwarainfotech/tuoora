import 'package:get/get.dart';

import '../controllers/assignments_controller.dart';
import '../controllers/fees_controller.dart';
import '../controllers/student_controller.dart';
import '../controllers/attendance_history_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentController>(() => StudentController());
    Get.lazyPut<AssignmentsController>(
      () => AssignmentsController(),
      fenix: true,
    );
    Get.lazyPut<FeesController>(() => FeesController(), fenix: true);
    Get.lazyPut<AttendanceHistoryController>(() => AttendanceHistoryController(), fenix: true);
  }
}
