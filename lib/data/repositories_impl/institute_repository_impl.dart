import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/models/batch_model.dart';
import 'package:tuoora/data/models/institute_profile_model.dart';
import 'package:tuoora/data/models/staff_model.dart';
import 'package:tuoora/data/models/whatsapp_settings_model.dart';
import 'package:tuoora/presentation/institute/models/expense_model.dart';
import 'package:tuoora/presentation/institute/models/fee_record.dart';
import 'package:tuoora/presentation/institute/models/report_models.dart';
import 'package:tuoora/presentation/institute/models/homework_model.dart';
import 'package:tuoora/presentation/institute/models/resource_model.dart';
import 'package:tuoora/presentation/institute/models/attendance_record_model.dart';
import 'package:tuoora/data/models/notification_model.dart';

abstract class InstituteRepositoryImpl {
  Future<InstituteProfile> getProfile();
  Future<InstituteSubscriptionData> getSubscriptionData();
  Future<void> updateProfile(Map<String, dynamic> data);

  Future<({String upiId, String? upiQrCodeUrl})> updatePaymentSettings({
    required String upiId,
    String? qrImagePath,
  });

  Future<void> renewSubscription({
    required String transactionId,
    required String screenshotPath,
    String? message,
  });

  // Authentication
  Future<String> registerInstitute(Map<String, dynamic> data);
  Future<String> verifyOtp(Map<String, dynamic> data);

  // WhatsApp Settings
  Future<WhatsAppSettings?> getWhatsAppSettings();
  Future<WhatsAppSettings> saveWhatsAppSettings(Map<String, dynamic> data);
  Future<WhatsAppSettings> updateWhatsAppSettings(Map<String, dynamic> data);

  // Password Management
  Future<void> changePassword(Map<String, dynamic> data);

  // Fees Management
  Future<FeeListResponse> listFees({int page = 1});
  Future<FeeRecord> createFee(Map<String, dynamic> data);
  Future<List<int>> exportFees();

  // Downloads the PDF receipt for a single fee record.
  Future<List<int>> downloadFeeReceipt(int feeId);

  // Reports
  Future<FeeReportResponse> getFeeReport();
  Future<BatchFeeDetailResponse> getBatchFeeReport(int batchId);
  Future<List<int>> exportFeeReport();

  // Attendance Reports
  Future<AttendanceReportResponse> getAttendanceReport();
  Future<BatchAttendanceDetailResponse> getBatchAttendanceReport(int batchId);
  Future<List<int>> exportAttendanceReport();

  // Performance Reports
  Future<PerformanceReportResponse> getPerformanceReport();
  Future<BatchPerformanceDetailResponse> getBatchPerformanceReport(int batchId);
  Future<List<int>> exportPerformanceReport();

  // Batches Management
  Future<BatchListResponse> listBatches({int page = 1, String? search});
  Future<Batch> createBatch(Map<String, dynamic> data);
  Future<Batch> updateBatch(int id, Map<String, dynamic> data);
  Future<void> deleteBatch(int id);

  // Attendance
  Future<List<AttendanceRecordModel>> getAttendance(String date, int batchId);
  Future<void> markAttendance(Map<String, dynamic> data);

  // Homework
  Future<List<HomeworkModel>> getHomeworks(int batchId);
  Future<HomeworkModel> getHomeworkDetails(int homeworkId);
  Future<dynamic> createHomework(Map<String, dynamic> data);
  Future<dynamic> submitHomeworkScore(
    int homeworkId,
    Map<String, dynamic> data,
  );

  // Batch Students
  Future<void> removeStudentFromBatch(int batchId, int studentId);
  Future<dynamic> assignStudentsToBatch(
    int batchId,
    List<Map<String, dynamic>> students,
  );

  // Resources
  Future<List<ResourceModel>> getResources(int batchId);
  Future<dynamic> uploadResource(Map<String, dynamic> data);
  Future<List<int>> downloadResource(
    int resourceId, {
    Function(double)? onProgress,
  });

  // Notifications
  Future<List<NotificationModel>> getNotifications();

  // Expenses
  Future<ExpenseListResponse> listExpenses({int page = 1});
  Future<List<ExpenseCategory>> getExpenseCategories();
  Future<ExpenseCategory> createExpenseCategory(Map<String, dynamic> data);
  Future<ExpenseModel> createExpense(Map<String, dynamic> data);
  Future<ExpenseAnalysis> getExpenseAnalysis(String month, String year);

  // Staff
  Future<StaffListResponse> listStaff({int page = 1, String? search});
  Future<void> deleteStaff(int id);
  Future<List<StaffRole>> getStaffRoles();
  Future<List<StaffDepartment>> getStaffDepartments();
  Future<Staff> createStaff(Map<String, dynamic> data, String? imagePath);
  Future<Staff> updateStaff(
    int id,
    Map<String, dynamic> data,
    String? imagePath,
  );
  Future<SalaryListResponse> getStaffSalaries(int staffId, {int page = 1});
  Future<SalaryPreview> getSalaryPreview(int staffId);
  Future<AttendanceListResponse> getStaffAttendance(
    int staffId, {
    int page = 1,
    String? month,
    String? year,
  });
  Future<AttendanceListResponse> getAttendanceLogs({
    int? page,
    String? month,
    String? year,
  });
  Future<void> logStaffAttendance(Map<String, dynamic> data);
  Future<SalaryListResponse> getGlobalSalaries({
    int? page,
    String? month,
    String? year,
  });
  Future<void> logSalary(Map<String, dynamic> data);
  Future<void> deleteResource(int id);
}
