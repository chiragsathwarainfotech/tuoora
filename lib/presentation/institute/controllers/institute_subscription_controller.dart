import 'package:get/get.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';

class InstituteSubscriptionController extends GetxController {
  final InstituteRepositoryImpl _repository;

  InstituteSubscriptionController(this._repository);

  final RxBool isLoading = true.obs;
  final Rx<InstituteSubscriptionData?> subscriptionData = Rx<InstituteSubscriptionData?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionData();
  }

  Future<void> fetchSubscriptionData() async {
    try {
      isLoading.value = true;
      subscriptionData.value = await _repository.getSubscriptionData();
    } catch (e) {
      AppSnackBar.error('Failed to fetch subscription data');
    } finally {
      isLoading.value = false;
    }
  }
}
