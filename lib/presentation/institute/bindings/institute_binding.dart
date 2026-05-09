import 'package:fee_easy/data/repositories/auth_repository.dart';
import 'package:fee_easy/data/repositories_impl/auth_repository_impl.dart';
import 'package:fee_easy/data/repositories/daily_update_repository.dart';
import 'package:fee_easy/data/repositories_impl/daily_update_repository_impl.dart';
import 'package:fee_easy/data/repositories/institute_repository.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/data/repositories/student_repository.dart';
import 'package:fee_easy/data/repositories_impl/student_repository_impl.dart';
import 'package:fee_easy/data/repositories_impl/leads_repository_impl.dart';
import 'package:fee_easy/data/repositories_impl/notes_repository_impl.dart';
import 'package:fee_easy/data/repositories_impl/chat_repository_impl.dart';
import 'package:fee_easy/data/repositories_impl/staff_repository_impl.dart';
import 'package:fee_easy/presentation/institute/controllers/attendance_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/batch_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/institute_profile_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/leads_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/notes_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/notification_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/record_fee_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/reports_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/security_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/student_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/updates_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/whatsapp_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/chat_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/staff_controller.dart';
import 'package:fee_easy/presentation/institute/controllers/expense_controller.dart';
import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/services/download_service.dart';
import 'package:get/get.dart';

class InstituteBinding extends Bindings {
  @override
  void dependencies() {
    // API Dependencies FIRST
    Get.lazyPut<ApiClient>(() => ApiClient());
    Get.lazyPut<StudentRepositoryImpl>(
      () => StudentRepository(Get.find<ApiClient>()),
    );
    Get.lazyPut<AuthRepositoryImpl>(
      () => AuthRepository(Get.find<ApiClient>()),
    );
    Get.lazyPut<InstituteRepositoryImpl>(
      () => InstituteRepository(Get.find<ApiClient>()),
    );
    Get.lazyPut<DailyUpdateRepositoryImpl>(
      () => DailyUpdateRepository(Get.find<ApiClient>()),
    );
    Get.lazyPut<LeadsRepositoryImpl>(
      () => LeadsRepositoryImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<NotesRepositoryImpl>(() => NotesRepositoryImpl());
    Get.lazyPut<ChatRepositoryImpl>(() => ChatRepositoryImpl());
    Get.lazyPut<StaffRepositoryImpl>(() => StaffRepositoryImpl());

    // Controllers
    Get.lazyPut<InstituteController>(() => InstituteController());
    Get.lazyPut<InstituteStudentController>(
      () => InstituteStudentController(),
      fenix: true,
    );
    Get.lazyPut<RecordFeeController>(() => RecordFeeController(), fenix: true);
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(Get.find<InstituteRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut<ReportsController>(() => ReportsController(), fenix: true);
    Get.lazyPut<InstituteProfileController>(
      () => InstituteProfileController(Get.find<InstituteRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut<UpdatesController>(
      () => UpdatesController(
        Get.find<DailyUpdateRepositoryImpl>(),
        Get.find<InstituteRepositoryImpl>(),
      ),
      fenix: true,
    );
    
    // BatchController depends on InstituteRepositoryImpl
    Get.put<BatchController>(
      BatchController(Get.find<InstituteRepositoryImpl>()),
      permanent: true,
    );
    
    Get.lazyPut<SecurityController>(
      () => SecurityController(Get.find<InstituteRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut<WhatsAppController>(() => WhatsAppController(), fenix: true);
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        Get.find<InstituteRepositoryImpl>() as InstituteRepository,
      ),
      fenix: true,
    );
    Get.lazyPut<LeadsController>(() => LeadsController(), fenix: true);
    Get.lazyPut<NotesController>(() => NotesController(), fenix: true);
    Get.lazyPut<ChatController>(
      () => ChatController(Get.find<ChatRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut<StaffController>(
      () => StaffController(Get.find<StaffRepositoryImpl>()),
      fenix: true,
    );
    Get.lazyPut<ExpenseController>(
      () => ExpenseController(Get.find<InstituteRepositoryImpl>()),
      fenix: true,
    );

    Get.put<DownloadService>(DownloadService(), permanent: true);
  }
}
