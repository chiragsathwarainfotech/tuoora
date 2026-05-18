import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/data/repositories/auth_repository.dart';
import 'package:tuoora/presentation/shared/controllers/login_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(Get.find<ApiClient>()));
    Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
  }
}

