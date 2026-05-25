import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_institute_model.dart';

class StudentInstituteRepository {
  final ApiClient _apiClient;

  StudentInstituteRepository(this._apiClient);

  Future<StudentInstituteModel> getInstitute() async {
    final response = await _apiClient.get(ApiConstants.studentInstitute);

    if (response.status.hasError) {
      throw Exception('Failed to load institute: ${response.statusText}');
    }

    return StudentInstituteModel.fromJson(response.body['data']);
  }
}
