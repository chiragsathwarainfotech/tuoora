import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/data/models/batch_model.dart';
import 'package:fee_easy/data/models/institute_profile_model.dart';
import 'package:fee_easy/data/models/whatsapp_settings_model.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/presentation/institute/models/report_models.dart';
import 'package:fee_easy/presentation/institute/models/homework_model.dart';
import 'package:fee_easy/presentation/institute/models/resource_model.dart';
import 'package:fee_easy/presentation/institute/models/attendance_record_model.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

class InstituteRepository implements InstituteRepositoryImpl {
  final ApiClient _apiClient;

  InstituteRepository(this._apiClient);

  @override
  Future<String> registerInstitute(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.instituteRegister,
      data,
    );
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Registration failed';
      throw Exception(message);
    }
    return response.body['message'] ?? 'Success';
  }

  @override
  Future<String> verifyOtp(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.instituteVerifyOtp,
      data,
    );
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
    final response = await _apiClient.get(
      ApiConstants.instituteReportAttendance,
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to fetch attendance report: ${response.statusText}',
      );
    }
    return AttendanceReportResponse.fromJson(response.body['data']);
  }

  @override
  Future<BatchAttendanceDetailResponse> getBatchAttendanceReport(
    int batchId,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportAttendance,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to fetch batch attendance report: ${response.statusText}',
      );
    }
    return BatchAttendanceDetailResponse.fromJson(response.body['data']);
  }

  @override
  Future<List<int>> exportAttendanceReport() async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportAttendanceExport,
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to export attendance report: ${response.statusText}',
      );
    }
    return _collectBytes(response.bodyBytes);
  }

  @override
  Future<PerformanceReportResponse> getPerformanceReport() async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportPerformance,
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to fetch performance report: ${response.statusText}',
      );
    }
    return PerformanceReportResponse.fromJson(response.body['data']);
  }

  @override
  Future<BatchPerformanceDetailResponse> getBatchPerformanceReport(
    int batchId,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportPerformance,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to fetch batch performance report: ${response.statusText}',
      );
    }
    return BatchPerformanceDetailResponse.fromJson(response.body['data']);
  }

  @override
  Future<List<int>> exportPerformanceReport() async {
    final response = await _apiClient.get(
      ApiConstants.instituteReportPerformanceExport,
    );
    if (response.status.hasError) {
      throw Exception(
        'Failed to export performance report: ${response.statusText}',
      );
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

  @override
  Future<BatchListResponse> listBatches({int page = 1}) async {
    final response = await _apiClient.get(
      ApiConstants.instituteBatches,
      query: {'page': page.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch batches: ${response.statusText}');
    }
    return BatchListResponse.fromJson(response.body['data']);
  }

  @override
  Future<Batch> createBatch(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiConstants.instituteBatches, data);
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to create batch';
      throw Exception(message);
    }
    return Batch.fromJson(response.body['data']);
  }

  @override
  Future<Batch> updateBatch(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.put(
      '${ApiConstants.instituteBatches}/$id',
      data,
    );
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to update batch';
      throw Exception(message);
    }
    return Batch.fromJson(response.body['data']);
  }

  @override
  Future<void> deleteBatch(int id) async {
    final response = await _apiClient.delete(
      '${ApiConstants.instituteBatches}/$id',
    );
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to delete batch';
      throw Exception(message);
    }
  }

  @override
  Future<void> markAttendance(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.instituteAttendance,
      data,
    );
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to mark attendance';
      throw Exception(message);
    }
  }

  @override
  Future<List<HomeworkModel>> getHomeworks(int batchId) async {
    final response = await _apiClient.get(
      ApiConstants.instituteHomeworks,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch homeworks: ${response.statusText}');
    }

    final dynamic bodyData = response.body['data'];
    List<dynamic> data = [];

    if (bodyData is List) {
      data = bodyData;
    } else if (bodyData is Map && bodyData['data'] is List) {
      // Handle paginated response where the list is nested in another 'data' field
      data = bodyData['data'];
    }

    return data.map((json) => HomeworkModel.fromJson(json)).toList();
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendance(
    String date,
    int batchId,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.instituteAttendance,
      query: {'date': date, 'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch attendance: ${response.statusText}');
    }

    final List<dynamic> data = response.body['data'] ?? [];
    return data.map((json) => AttendanceRecordModel.fromJson(json)).toList();
  }

  @override
  Future<dynamic> createHomework(Map<String, dynamic> data) async {
    final Map<String, dynamic> fields = {
      'batch_id': data['batch_id'],
      'title': data['title'],
      'description': data['description'],
      'due_date': data['due_date'],
    };

    if (data['attachment'] != null) {
      fields['attachment'] = MultipartFile(
        data['attachment'],
        filename: data['attachment'].split('/').last,
      );
    }

    final response = await _apiClient.post(
      ApiConstants.instituteHomeworks,
      FormData(fields),
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to create homework';
      throw Exception(message);
    }
    return response.body['data'];
  }

  @override
  Future<void> removeStudentFromBatch(int batchId, int studentId) async {
    final response = await _apiClient.post(
      ApiConstants.removeStudentFromBatch(batchId),
      {'student_id': studentId},
    );
    if (response.status.hasError) {
      final message =
          response.body?['message'] ?? 'Failed to remove student from batch';
      throw Exception(message);
    }
  }

  @override
  Future<dynamic> assignStudentsToBatch(
    int batchId,
    List<Map<String, dynamic>> students,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.assignStudentsToBatch(batchId),
      {'students': students},
    );
    if (response.status.hasError) {
      final message =
          response.body?['message'] ?? 'Failed to assign students to batch';
      throw Exception(message);
    }
    return response.body['data'];
  }

  @override
  Future<dynamic> submitHomeworkScore(
    int homeworkId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(
      '${ApiConstants.instituteHomeworks}/$homeworkId/score',
      data,
    );
    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to submit ratings';
      throw Exception(message);
    }
    return response.body;
  }

  @override
  Future<List<ResourceModel>> getResources(int batchId) async {
    final response = await _apiClient.get(
      ApiConstants.instituteResources,
      query: {'batch_id': batchId.toString()},
    );
    if (response.status.hasError) {
      throw Exception('Failed to fetch resources: ${response.statusText}');
    }

    final dynamic bodyData = response.body['data'];
    List<dynamic> data = [];

    if (bodyData is List) {
      data = bodyData;
    } else if (bodyData is Map && bodyData['data'] is List) {
      data = bodyData['data'];
    }

    return data.map((json) => ResourceModel.fromJson(json)).toList();
  }

  @override
  Future<dynamic> uploadResource(Map<String, dynamic> data) async {
    final formData = FormData(data);

    if (data['file'] != null && data['file'] is String) {
      final String filePath = data['file'];
      formData.files.add(
        MapEntry(
          'file',
          MultipartFile(filePath, filename: filePath.split('/').last),
        ),
      );
    }

    final response = await _apiClient.post(
      ApiConstants.instituteResources,
      formData,
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to upload resource';
      throw Exception(message);
    }
    return response.body['data'];
  }
}
