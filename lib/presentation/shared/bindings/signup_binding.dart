import 'package:tuoora/data/repositories/auth_repository.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/data/repositories/institute_repository.dart';
import 'package:get/get.dart';
import 'package:tuoora/presentation/shared/controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<InstituteRepository>(() => InstituteRepository(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController());
  }
}

