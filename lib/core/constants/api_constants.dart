class ApiConstants {
  static const String baseUrl = 'https://tuoora.com/admin/api/v1';
  
  // Auth Endpoints
  static const String instituteLogin = '/institute/login';
  static const String studentLogin = '/student/login';
  static const String parentLogin = '/parent/login';
  
  // Institute Endpoints
  static const String instituteStudents = '/institute/students';
  static const String instituteProfile = '/institute/profile';
  static const String instituteProfileUpdate = '/institute/profile/update';
  static const String instituteChangePassword = '/institute/profile/change-password';
  static const String instituteWhatsAppSettings = '/institute/whatsapp-settings';
  static const String instituteFees = '/institute/fees';
  static const String instituteFeesExport = '/institute/fees/export';
  static const String instituteDailyUpdates = '/institute/daily-updates';
}
