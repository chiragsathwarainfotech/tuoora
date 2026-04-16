import 'package:get/get.dart';
import '../controllers/institute_controller.dart';

class InstituteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InstituteController>(() => InstituteController());
  }
}
