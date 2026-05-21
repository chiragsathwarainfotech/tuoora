import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_profile_model.dart';
import 'package:tuoora/data/repositories_impl/student_profile_repository_impl.dart';

class StudentProfileRepository implements StudentProfileRepositoryImpl {
  final ApiClient _apiClient;

  StudentProfileRepository(this._apiClient);

  @override
  Future<StudentProfileModel> getProfile() async {
    final response = await _apiClient.get(ApiConstants.studentProfile);
    if (response.status.hasError) {
      throw Exception('Failed to load profile: ${response.statusText}');
    }
    return StudentProfileModel.fromJson(response.body['data']);
  }

  @override
  Future<void> submitFeedback(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiConstants.studentFeedback, data);
    if (response.status.hasError) {
      throw Exception('Failed to submit feedback: ${response.statusText}');
    }
  }
}
