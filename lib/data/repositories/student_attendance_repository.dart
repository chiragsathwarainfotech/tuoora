import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_attendance_model.dart';

class StudentAttendanceRepository {
  final ApiClient _apiClient;

  StudentAttendanceRepository(this._apiClient);

  Future<StudentAttendanceModel> getAttendance({int? month, int? year}) async {
    final Map<String, dynamic> query = {};
    if (month != null) query['month'] = month.toString();
    if (year != null) query['year'] = year.toString();

    final response = await _apiClient.get(
      ApiConstants.studentAttendance,
      query: query.isNotEmpty ? query : null,
    );

    if (response.status.hasError) {
      throw Exception('Failed to load attendance: ${response.statusText}');
    }

    return StudentAttendanceModel.fromJson(response.body['data']);
  }
}
