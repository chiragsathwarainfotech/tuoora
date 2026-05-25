import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_dashboard_model.dart';

class StudentDashboardRepository {
  final ApiClient _apiClient;

  StudentDashboardRepository(this._apiClient);

  Future<StudentDashboardData> getDashboardData() async {
    final response = await _apiClient.get(ApiConstants.studentDashboard);

    if (response.status.hasError) {
      throw Exception('Failed to load dashboard data: ${response.statusText}');
    }

    return StudentDashboardData.fromJson(response.body['data']);
  }
}
