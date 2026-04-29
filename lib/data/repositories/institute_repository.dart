import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/data/models/institute_profile_model.dart';
import 'package:fee_easy/data/models/whatsapp_settings_model.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/presentation/institute/models/report_models.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

class InstituteRepository implements InstituteRepositoryImpl {
  final ApiClient _apiClient;

  InstituteRepository(this._apiClient);

  @override
  Future<String> registerInstitute(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiConstants.instituteRegister, data);
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Registration failed';
      throw Exception(message);
    }
    return response.body['message'] ?? 'Success';
  }

  @override
  Future<String> verifyOtp(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiConstants.instituteVerifyOtp, data);
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'OTP verification failed';
      throw Exception(message);
    }
    
    final token = response.body['data']?['token'];
    if (token == null) {
      throw Exception('Token not found in response');
    }
    return token;
  }

  @override
  Future<InstituteProfile> getProfile() async {
    final response = await _apiClient.get(ApiConstants.instituteProfile);
    if (response.status.hasError) {
      throw Exception('Failed to fetch profile: ${response.statusText}');
    }

    final body = response.body;
    if (body == null || body['data'] == null) {
      throw Exception('Invalid profile response');
    }

    return InstituteProfile.fromJson(body['data']);
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final formData = FormData(data);

    if (data['logo_url'] != null &&
        data['logo_url'].toString().isNotEmpty &&
        !data['logo_url'].toString().startsWith('http')) {
      formData.files.add(
        MapEntry(
          'logo_url',
          MultipartFile(data['logo_url'], filename: 'institute_logo.jpg'),
        ),
      );
      data.remove('logo_url');
    }

    final response = await _apiClient.post(
      ApiConstants.instituteProfileUpdate,
      formData,
    );

    if (response.status.hasError) {
      throw Exception('Failed to update profile: ${response.statusText}');
    }
  }

  @override
  Future<WhatsAppSettings?> getWhatsAppSettings() async {
    final response = await _apiClient.get(
      ApiConstants.instituteWhatsAppSettings,
    );
    if (response.status.hasError) {
      if (response.statusCode == 404) return null;
      throw Exception(
        'Failed to fetch WhatsApp settings: ${response.statusText}',
      );
    }

    final body = response.body;
    if (body == null || body['data'] == null) return null;

    return WhatsAppSettings.fromJson(body['data']);
  }

  @override
  Future<WhatsAppSettings> saveWhatsAppSettings(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.instituteWhatsAppSettings,
      data,
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to save WhatsApp settings: ${response.statusText}',
      );
    }
    return WhatsAppSettings.fromJson(response.body['data']);
  }

  @override
  Future<WhatsAppSettings> updateWhatsAppSettings(
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.put(
      ApiConstants.instituteWhatsAppSettings,
      data,
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to update WhatsApp settings: ${response.statusText}',
      );
    }
    return WhatsAppSettings.fromJson(response.body['data']);
  }

  @override
  Future<void> changePassword(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.instituteChangePassword,
      data,
    );
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to change password';
      throw Exception(message);
    }
  }

  @override
  Future<FeeListResponse> listFees({int page = 1}) async {
    final response = await _apiClient.get(
      ApiConstants.instituteFees,
      query: {'page': page.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch fees: ${response.statusText}');
    }
    return FeeListResponse.fromJson(response.body['data']);
  }

  @override
  Future<FeeRecord> createFee(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiConstants.instituteFees, data);
    if (response.status.hasError) {
      final message =
          response.body?['message'] ?? 'Failed to create fee record';
      throw Exception(message);
    }
    return FeeRecord.fromJson(response.body['data']);
  }

  @override
  Future<List<int>> exportFees() async {
    final response = await _apiClient.get(ApiConstants.instituteFeesExport);

    if (response.status.hasError) {
      throw Exception('Failed to download report: ${response.statusText}');
    }

    // Convert Stream<List<int>> to List<int>
    return _collectBytes(response.bodyBytes);
  }

  @override
  Future<FeeReportResponse> getFeeReport() async {
    final response = await _apiClient.get(ApiConstants.instituteReportFee);
    if (response.status.hasError) {
      throw Exception('Failed to fetch fee report: ${response.statusText}');
    }
    return FeeReportResponse.fromJson(response.body['data']);
  }

  @override
  Future<BatchFeeDetailResponse> getBatchFeeReport(int batchId) async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportFee,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to fetch batch fee report: ${response.statusText}',
      );
    }
    return BatchFeeDetailResponse.fromJson(response.body['data']);
  }

  @override
  Future<List<int>> exportFeeReport() async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportFeeExport,
    );
    if (response.status.hasError) {
      throw Exception('Failed to export fee report: ${response.statusText}');
    }
    return _collectBytes(response.bodyBytes);
  }

  @override
  Future<AttendanceReportResponse> getAttendanceReport() async {
    final response = await _apiClient.get(ApiConstants.instituteReportAttendance);
    if (response.status.hasError) {
      throw Exception('Failed to fetch attendance report: ${response.statusText}');
    }
    return AttendanceReportResponse.fromJson(response.body['data']);
  }

  @override
  Future<BatchAttendanceDetailResponse> getBatchAttendanceReport(int batchId) async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportAttendance,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch batch attendance report: ${response.statusText}');
    }
    return BatchAttendanceDetailResponse.fromJson(response.body['data']);
  }

  @override
  Future<List<int>> exportAttendanceReport() async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportAttendanceExport,
    );
    if (response.status.hasError) {
      throw Exception('Failed to export attendance report: ${response.statusText}');
    }
    return _collectBytes(response.bodyBytes);
  }

  @override
  Future<PerformanceReportResponse> getPerformanceReport() async {
    final response = await _apiClient.get(ApiConstants.instituteReportPerformance);
    if (response.status.hasError) {
      throw Exception('Failed to fetch performance report: ${response.statusText}');
    }
    return PerformanceReportResponse.fromJson(response.body['data']);
  }

  @override
  Future<BatchPerformanceDetailResponse> getBatchPerformanceReport(int batchId) async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportPerformance,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch batch performance report: ${response.statusText}');
    }
    return BatchPerformanceDetailResponse.fromJson(response.body['data']);
  }

  @override
  Future<List<int>> exportPerformanceReport() async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportPerformanceExport,
    );
    if (response.status.hasError) {
      throw Exception('Failed to export performance report: ${response.statusText}');
    }
    return _collectBytes(response.bodyBytes);
  }

  Future<List<int>> _collectBytes(Stream<List<int>>? stream) async {
    if (stream == null) {
      throw Exception('Received empty file from server');
    }
    final List<int> allBytes = [];
    await for (final chunk in stream) {
      allBytes.addAll(chunk);
    }
    return allBytes;
  }
}
