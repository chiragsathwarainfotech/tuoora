import 'package:tuoora/core/api/api_client.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/institute/controllers/forgot_password_controller.dart';
import 'package:tuoora/data/repositories/auth_repository.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut(() => ForgotPasswordController());
  }
}

