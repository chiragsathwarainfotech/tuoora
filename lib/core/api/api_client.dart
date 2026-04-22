import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect {

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    // Add default headers
    httpClient.addRequestModifier<dynamic>((request) {
      final authService = Get.find<AuthService>();
      request.headers['Accept'] = 'application/json';
      if (authService.isAuthenticated) {
        request.headers['Authorization'] = 'Bearer ${authService.token}';
      }
      return request;
    });

    // Logging & Error Handling
    httpClient.addResponseModifier((request, response) {
      if (response.hasError) {
        // You can add global error handling here (e.g., refreshing tokens or logging out on 401)
        print('API Error: ${response.statusCode} - ${response.statusText}');
      }
      return response;
    });

    super.onInit();
  }
}
