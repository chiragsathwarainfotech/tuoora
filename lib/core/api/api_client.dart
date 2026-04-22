import 'package:fee_easy/core/constants/api_constants.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect {

  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    // Add default headers
    // Detailed Request Logging
    httpClient.addRequestModifier<dynamic>((request) {
      final authService = Get.find<AuthService>();
      request.headers['Accept'] = 'application/json';
      if (authService.isAuthenticated) {
        request.headers['Authorization'] = 'Bearer ${authService.token}';
      }

      print('🚀 [API REQUEST] ${request.method.toUpperCase()} ${request.url}');
      print('Headers: ${request.headers}');
      
      return request;
    });

    // Detailed Response & Error Logging
    httpClient.addResponseModifier((request, response) {
      print('📥 [API RESPONSE] ${request.method.toUpperCase()} ${request.url}');
      print('Status Code: ${response.statusCode}');
      
      if (response.hasError) {
        print('❌ [API ERROR]');
        print('URL: ${request.url}');
        print('Status: ${response.statusCode} ${response.statusText}');
        print('Body: ${response.body}');
        
        // Handle unauthorized globally if needed
        if (response.statusCode == 401) {
          // Get.find<AuthService>().logout();
        }
      } else {
        // Log body only in debug mode or if specifically needed, keeping it minimal for now
        // print('Body: ${response.body}');
      }
      
      print('--------------------------------------------------');
      return response;
    });

    super.onInit();
  }
}
