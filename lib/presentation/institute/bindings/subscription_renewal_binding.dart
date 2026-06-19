import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/data/repositories/institute_repository.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/controllers/subscription_renewal_controller.dart';

class SubscriptionRenewalBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    }
    if (!Get.isRegistered<InstituteRepositoryImpl>()) {
      Get.lazyPut<InstituteRepositoryImpl>(
        () => InstituteRepository(Get.find<ApiClient>()),
        fenix: true,
      );
    }
    Get.lazyPut<SubscriptionRenewalController>(
      () => SubscriptionRenewalController(Get.find<InstituteRepositoryImpl>()),
      fenix: true,
    );
  }
}
