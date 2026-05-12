import 'package:fee_easy/core/api/api_client.dart';
import 'package:fee_easy/data/repositories/auth_repository.dart';
import 'package:fee_easy/presentation/shared/controllers/login_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(Get.find<ApiClient>()));
    Get.lazyPut(() => LoginController(Get.find<AuthRepository>()));
  }
}

