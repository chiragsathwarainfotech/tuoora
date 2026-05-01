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

  User _handleResponse(dynamic response, String role) {
    if (response.status.hasError) {
      throw Exception(response.body?['message'] ?? 'Login failed');
    }

    final data = response.body['data'];
    final token = data['token'];
    return User.fromJson(data, token, role);
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await _apiClient.post(
      ApiConstants.instituteForgotPassword,
      {'email': email},
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to send reset OTP';
      throw Exception(message);
    }

    return response.body['message'] ?? 'Success';
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> data) async {
    final response = await _apiClient.post(
      ApiConstants.instituteResetPassword,
      data,
    );

    if (response.status.hasError) {
      final message = response.body?['message'] ?? 'Failed to reset password';
      throw Exception(message);
    }

    return response.body['message'] ?? 'Success';
  }
}
