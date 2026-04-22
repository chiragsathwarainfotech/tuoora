import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/data/models/user_model.dart';
import 'package:fee_easy/data/repositories_impl/auth_repository_impl.dart';

class AuthRepository implements AuthRepositoryImpl {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  @override
  Future<User> loginInstitute(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.instituteLogin,
      {'email': email, 'password': password},
    );
    return _handleResponse(response, 'INSTITUTE');
  }

  @override
  Future<User> loginStudent(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.studentLogin,
      {'email': email, 'password': password},
    );
    return _handleResponse(response, 'STUDENT');
  }

  @override
  Future<User> loginParent(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.parentLogin,
      {'email': email, 'password': password},
    );
    return _handleResponse(response, 'PARENT');
  }

  @override
  Future<User> getInstituteProfile() async {
    final response = await _apiClient.get(ApiConstants.instituteProfile);
    if (response.status.hasError) {
      throw Exception(response.statusText ?? 'Failed to fetch profile');
    }
    final data = response.body['data'];
    // Profile API might not return token again, so we pass empty string if missing
    return User.fromJson(data, data['token'] ?? '', 'INSTITUTE');
  }

  User _handleResponse(dynamic response, String role) {
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Login failed');
    }
    
    final data = response.body['data'];
    final token = data['token'];
    return User.fromJson(data, token, role);
  }
}
