import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/api_constants.dart';
import 'package:tuoora/data/models/student_notification_model.dart';

class StudentNotificationsRepository {
  final ApiClient _apiClient;

  StudentNotificationsRepository(this._apiClient);

  Future<List<StudentNotification>> getNotifications() async {
    final response = await _apiClient.get(ApiConstants.studentNotifications);
    if (response.status.hasError) {
      throw Exception(
        'Failed to load notifications: ${response.statusText}',
      );
    }
    final list = (response.body['data'] as List?) ?? const [];
    return list
        .map((e) => StudentNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
