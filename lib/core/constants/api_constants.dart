class ApiConstants {
  static const String baseUrl = 'https://tuoora.com/api/v1';

  // Auth Endpoints
  static const String instituteLogin = '/institute/login';
  static const String instituteRegister = '/institute/register';
  static const String instituteVerifyOtp = '/institute/verify-otp';
  static const String studentLogin = '/student/login';
  static const String parentLogin = '/parent/login';

  // Institute Endpoints
  static const String instituteStudents = '/institute/students';
  static const String instituteProfile = '/institute/profile';
  static const String instituteProfileUpdate = '/institute/profile/update';
  static const String instituteBatches = '/institute/batches';
  static const String instituteChangePassword =
      '/institute/profile/change-password';
  static const String instituteWhatsAppSettings =
      '/institute/whatsapp-settings';
  static const String instituteFees = '/institute/fees';
  static const String instituteFeesExport = '/institute/fees/export';
  static const String instituteDailyUpdates = '/institute/daily-updates';
  static const String instituteAttendance = '/institute/attendance';
  static const String instituteHomeworks = '/institute/homeworks';
  static const String instituteResources = '/institute/resources';
  static String downloadResource(int resourceId) =>
      '/institute/resources/$resourceId/download';
  static const String instituteForgotPassword = '/institute/forgot-password';
  static const String instituteResetPassword = '/institute/reset-password';
  static const String instituteNotifications = '/institute/notifications';

  static String removeStudentFromBatch(int batchId) =>
      '/institute/batches/$batchId/remove-student';

  static String assignStudentsToBatch(int batchId) =>
      '/institute/batches/$batchId/assign-students';

  // Reports Endpoints
  static const String instituteReportFee = '/institute/reports/fee';
  static const String instituteReportFeeExport =
      '/institute/reports/fee/export';

  // Attendance Reports
  static const String instituteReportAttendance =
      '/institute/reports/attendance';
  static const String instituteReportAttendanceExport =
      '/institute/reports/attendance/export';

  // Performance Reports
  static const String instituteReportPerformance =
      '/institute/reports/performance';
  static const String instituteReportPerformanceExport =
      '/institute/reports/performance/export';
}
