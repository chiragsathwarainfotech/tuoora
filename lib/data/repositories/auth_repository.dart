import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/core/services/auth_service.dart';
import 'package:tuoora/data/models/subscription_model.dart';
import 'package:tuoora/data/models/user_model.dart';
import 'package:tuoora/data/repositories_impl/auth_repository_impl.dart';

class AuthRepository implements AuthRepositoryImpl {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  @override
  Future<User> loginInstitute(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.instituteLogin,
      {'email': email, 'password': password},
    );
    final user = _handleResponse(response, 'INSTITUTE');
    await _updateSubscription(response);
    return user;
  }

  @override
  Future<User> loginStudent(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.studentLogin,
      {'email': email, 'password': password},
    );
    final user = _handleResponse(response, 'STUDENT');
    // Students have no subscription — clear any stale one from a prior session.
    await Get.find<AuthService>().setSubscription(null);
    return user;
  }

  /// Reads the top-level `subscription` node (sibling of `data`) and stores it
  /// on [AuthService] so the dashboard banner can react to its status.
  Future<void> _updateSubscription(dynamic response) async {
    try {
      final sub = response.body?['subscription'];
      await Get.find<AuthService>().setSubscription(
        sub != null
            ? Subscription.fromJson(Map<String, dynamic>.from(sub))
            : null,
      );
    } catch (_) {
      // Non-fatal: a missing/malformed subscription node shouldn't block login.
    }
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

