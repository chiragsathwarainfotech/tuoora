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
    await Future.delayed(const Duration(seconds: 2));

    print('SplashController: Checking auth status...');
    print('SplashController: isAuthenticated: ${_authService.isAuthenticated}');
    print('SplashController: currentUser: ${_authService.currentUser?.name} (Role: ${_authService.currentUser?.role})');

    if (_authService.isAuthenticated && _authService.shouldStayAuthenticated) {
      final role = _authService.currentUser?.role;
      print('SplashController: Navigating to dashboard for role: $role');
      _navigateToDashboard(role);
    } else {
      if (_authService.isAuthenticated && !_authService.shouldStayAuthenticated) {
        print('SplashController: User opted out of persistent login. Clearing session.');
        await _authService.clearSession();
      }
      print('SplashController: Not authenticated or persistence disabled. Navigating to role selection.');
      Get.offAllNamed(AppRoutes.roleSelection);
    }
  }

  void _navigateToDashboard(String? role) {
    if (role == 'INSTITUTE') {
      final user = _authService.currentUser;
      if (user?.isProfileSetup == false) {
        Get.offAllNamed(AppRoutes.instituteProfileSetup);
      } else {
        Get.offAllNamed(AppRoutes.instituteDashboard);
      }
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
