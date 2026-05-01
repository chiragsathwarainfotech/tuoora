import 'package:fee_easy/core/api/api_client.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/shared/controllers/forgot_password_controller.dart';
import 'package:fee_easy/data/repositories/auth_repository.dart';

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
