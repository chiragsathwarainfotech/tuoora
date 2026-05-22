import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_report_model.dart';

class StudentReportRepository {
  final ApiClient _apiClient;

  StudentReportRepository(this._apiClient);

  Future<StudentReportModel> getReport({int period = 4}) async {
    final response = await _apiClient.get(
      ApiConstants.studentReport,
      query: {'period': period.toString()},
    );

    if (response.status.hasError) {
      throw Exception('Failed to load reports: ${response.statusText}');
    }

    return StudentReportModel.fromJson(response.body['data']);
  }
}
