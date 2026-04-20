import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/record_fee_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/attendance_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/updates_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/security_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/whatsapp_controller.dart';
import 'package:get/get.dart';

class InstituteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstituteController>(() => InstituteController());
    Get.lazyPut<InstituteStudentController>(() => InstituteStudentController(), fenix: true);
    Get.lazyPut<RecordFeeController>(() => RecordFeeController(), fenix: true);
    Get.lazyPut<AttendanceController>(() => AttendanceController(), fenix: true);
    Get.lazyPut<ReportsController>(() => ReportsController(), fenix: true);
    Get.lazyPut<InstituteProfileController>(() => InstituteProfileController(), fenix: true);
    Get.lazyPut<UpdatesController>(() => UpdatesController(), fenix: true);
    Get.lazyPut<BatchController>(() => BatchController(), fenix: true);
    Get.lazyPut<SecurityController>(() => SecurityController(), fenix: true);
    Get.lazyPut<WhatsAppController>(() => WhatsAppController(), fenix: true);
  }
}
