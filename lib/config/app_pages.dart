import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/presentation/institute/bindings/institute_binding.dart';
import 'package:fee_easy/presentation/institute/view/institute_main_screen.dart';
import 'package:fee_easy/presentation/institute/view/edit_student_profile_screen.dart';
import 'package:fee_easy/presentation/institute/view/add_student_screen.dart';
import 'package:fee_easy/presentation/institute/view/batch_details_screen.dart';
import 'package:fee_easy/presentation/institute/view/attendance_marking_screen.dart';
import 'package:fee_easy/presentation/institute/view/mark_attendance_screen.dart';
import 'package:fee_easy/presentation/institute/view/student_profile_screen.dart';
import 'package:fee_easy/presentation/institute/view/record_fee_screen.dart';
import 'package:fee_easy/presentation/institute/view/edit_profile_screen.dart';
import 'package:fee_easy/presentation/institute/view/institute_security_screen.dart';
import 'package:fee_easy/presentation/institute/view/institute_subscription_screen.dart';
import 'package:fee_easy/presentation/institute/view/institute_whatsapp_screen.dart';
import 'package:fee_easy/presentation/institute/view/fee_reports_screen.dart';
import 'package:fee_easy/presentation/institute/view/defaulters_list_screen.dart';
import 'package:fee_easy/presentation/institute/view/institute_updates_screen.dart';
import 'package:fee_easy/presentation/institute/view/create_update_screen.dart';
import 'package:fee_easy/presentation/institute/view/institute_notifications_screen.dart';
import 'package:fee_easy/presentation/institute/view/billing_history_screen.dart';
import 'package:fee_easy/presentation/institute/view/add_edit_batch_screen.dart';
import 'package:fee_easy/presentation/institute/view/assign_students_screen.dart';
import 'package:fee_easy/presentation/parent/view/parent_main_screen.dart';

import 'package:fee_easy/presentation/shared/view/payment_history_screen.dart';
import 'package:fee_easy/presentation/parent/view/homework_tracker_screen.dart';
import 'package:fee_easy/presentation/parent/view/homework_detail_screen.dart';
import 'package:fee_easy/presentation/parent/view/attendance_history_screen.dart';
import 'package:fee_easy/presentation/parent/view/payment_qr_screen.dart';
import 'package:fee_easy/presentation/parent/bindings/parent_binding.dart';
import 'package:fee_easy/presentation/shared/bindings/auth_binding.dart';
import 'package:fee_easy/presentation/shared/view/login_screen.dart';
import 'package:fee_easy/presentation/shared/view/student_profile_screen.dart'
    as shared;
import 'package:fee_easy/presentation/shared/view/updates_screen.dart'
    as shared;
import 'package:fee_easy/presentation/student/view/student_main_screen.dart';
import 'package:fee_easy/presentation/student/bindings/student_binding.dart';
import 'package:fee_easy/presentation/student/view/homework_detail_screen.dart';
import 'package:fee_easy/presentation/shared/view/role_selection_screen.dart';
import 'package:fee_easy/presentation/shared/bindings/splash_binding.dart';
import 'package:fee_easy/presentation/shared/view/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.roleSelection,
      page: () => const RoleSelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    // Parent routes
    GetPage(
      name: AppRoutes.parentDashboard,
      page: () => const ParentMainScreen(),
      binding: ParentBinding(),
    ),
    GetPage(
      name: AppRoutes.parentFees,
      page: () => const ParentMainScreen(),
      binding: ParentBinding(),
    ),
    GetPage(
      name: AppRoutes.parentAttendance,
      page: () => const ParentMainScreen(),
      binding: ParentBinding(),
    ),
    GetPage(
      name: AppRoutes.parentReports,
      page: () => const ParentMainScreen(),
      binding: ParentBinding(),
    ),
    GetPage(
      name: AppRoutes.parentInstitute,
      page: () => const ParentMainScreen(),
      binding: ParentBinding(),
    ),
    GetPage(
      name: AppRoutes.parentStudentProfile,
      page: () => const shared.StudentProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.parentUpdates,
      page: () => const shared.UpdatesScreen(),
    ),
    GetPage(
      name: AppRoutes.parentRecentPayments,
      page: () => const PaymentHistoryScreen(title: 'Recent Payments'),
    ),
    GetPage(
      name: AppRoutes.parentHomeworkTracker,
      page: () => const HomeworkTrackerScreen(),
    ),
    GetPage(
      name: AppRoutes.parentAttendanceHistory,
      page: () => const AttendanceHistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.parentHomeworkDetail,
      page: () => const HomeworkDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.parentPaymentQR,
      page: () => const PaymentQRScreen(),
    ),
    // Student routes
    GetPage(
      name: AppRoutes.studentDashboard,
      page: () => const StudentMainScreen(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: AppRoutes.studentAttendance,
      page: () => const StudentMainScreen(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: AppRoutes.studentSettings,
      page: () => const shared.StudentProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.studentNotifications,
      page: () => const shared.UpdatesScreen(),
    ),
    GetPage(
      name: AppRoutes.studentHomework,
      page: () => const StudentMainScreen(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: AppRoutes.studentHomeworkDetail,
      page: () => const StudentHomeworkDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.studentInstitute,
      page: () => const StudentMainScreen(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: AppRoutes.studentFeeHistory,
      page: () => const PaymentHistoryScreen(title: 'Fee History'),
    ),
    // Institute routes
    GetPage(
      name: AppRoutes.instituteDashboard,
      page: () => const InstituteMainScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteMain,
      page: () => const InstituteMainScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteStudents,
      page: () => const InstituteMainScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteAddStudent,
      page: () => const AddStudentScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteEditStudentProfile,
      page: () => const EditStudentProfileScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteFees,
      page: () => const InstituteMainScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteRecordFee,
      page: () => const RecordFeeScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteBatchDetails,
      page: () => const BatchDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteBatches,
      page: () => const InstituteMainScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteAttendanceMarking,
      page: () => const AttendanceMarkingScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteMarkAttendance,
      page: () => const MarkAttendanceScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteStudentProfile,
      page: () => const StudentProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteEditProfile,
      page: () => const InstituteEditProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteProfile,
      page: () => const InstituteMainScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteSecurity,
      page: () => const InstituteSecurityScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteSubscription,
      page: () => const InstituteSubscriptionScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteWhatsApp,
      page: () => const InstituteWhatsAppScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteFeeReports,
      page: () => const FeeReportsScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteDefaultersList,
      page: () => const DefaultersListScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteUpdates,
      page: () => const InstituteUpdatesScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteCreateUpdate,
      page: () => const CreateUpdateScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteNotifications,
      page: () => const InstituteNotificationsScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteBillingHistory,
      page: () => const BillingHistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.instituteAddBatch,
      page: () => const AddEditBatchScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteEditBatch,
      page: () => const AddEditBatchScreen(),
      binding: InstituteBinding(),
    ),
    GetPage(
      name: AppRoutes.instituteAssignStudents,
      page: () => const AssignStudentsScreen(),
      binding: InstituteBinding(),
    ),
  ];
}
