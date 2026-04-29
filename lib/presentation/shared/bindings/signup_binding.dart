import 'package:fee_easy/data/repositories/institute_repository.dart';
import 'package:get/get.dart';
import 'package:fee_easy/presentation/shared/controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => SignupController(Get.find<InstituteRepository>()),
    );
  }
}
