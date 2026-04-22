import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/services/auth_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Add a slight delay for better UX
    await Future.delayed(const Duration(seconds: 2));

    if (_authService.isAuthenticated) {
      final role = _authService.currentUser?.role;
      _navigateToDashboard(role);
    } else {
      Get.offAllNamed(AppRoutes.roleSelection);
    }
  }

  void _navigateToDashboard(String? role) {
    if (role == 'INSTITUTE') {
      Get.offAllNamed(AppRoutes.instituteDashboard);
    } else if (role == 'STUDENT') {
      Get.offAllNamed(AppRoutes.studentDashboard);
    } else if (role == 'PARENT') {
      Get.offAllNamed(AppRoutes.parentDashboard);
    } else {
      // Fallback
      Get.offAllNamed(AppRoutes.roleSelection);
    }
  }
}
