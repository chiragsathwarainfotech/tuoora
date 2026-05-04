import 'package:fee_easy/data/models/batch_model.dart';
import 'package:fee_easy/data/models/institute_profile_model.dart';
import 'package:fee_easy/data/models/whatsapp_settings_model.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';
import 'package:fee_easy/presentation/institute/models/report_models.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:fee_easy/presentation/institute/models/attendance_record_model.dart';
import 'package:fee_easy/data/models/notification_model.dart';

abstract class InstituteRepositoryImpl {
  Future<InstituteProfile> getProfile();
  Future<void> updateProfile(Map<String, dynamic> data);

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
  Future<BatchListResponse> listBatches({int page = 1});
  Future<Batch> createBatch(Map<String, dynamic> data);
  Future<Batch> updateBatch(int id, Map<String, dynamic> data);
  Future<void> deleteBatch(int id);

  // Attendance
  Future<List<AttendanceRecordModel>> getAttendance(String date, int batchId);
  Future<void> markAttendance(Map<String, dynamic> data);

  // Homework
  Future<List<HomeworkModel>> getHomeworks(int batchId);
  Future<dynamic> createHomework(Map<String, dynamic> data);
  Future<dynamic> submitHomeworkScore(int homeworkId, Map<String, dynamic> data);

  // Batch Students
  Future<void> removeStudentFromBatch(int batchId, int studentId);
  Future<dynamic> assignStudentsToBatch(int batchId, List<Map<String, dynamic>> students);

  // Resources
  Future<List<ResourceModel>> getResources(int batchId);
  Future<dynamic> uploadResource(Map<String, dynamic> data);
  
  // Notifications
  Future<List<NotificationModel>> getNotifications();
}
