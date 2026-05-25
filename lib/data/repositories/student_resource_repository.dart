import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_resource_model.dart';

class StudentResourceRepository {
  final ApiClient _apiClient;

  StudentResourceRepository(this._apiClient);

  Future<StudentResourcesResponse> getResources() async {
    final response = await _apiClient.get(ApiConstants.studentResources);

    if (response.status.hasError) {
      throw Exception('Failed to load resources: ${response.statusText}');
    }

    return StudentResourcesResponse.fromJson(response.body['data']);
  }
}
