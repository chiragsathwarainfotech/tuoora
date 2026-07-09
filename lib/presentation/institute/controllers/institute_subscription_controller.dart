import 'package:get/get.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/institute_subscription_model.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';

class InstituteSubscriptionController extends GetxController {
  final InstituteRepositoryImpl _repository;

  InstituteSubscriptionController(this._repository);

  final RxBool isLoading = true.obs;
  final Rx<InstituteSubscriptionData?> subscriptionData = Rx<InstituteSubscriptionData?>(null);
  final selectedPlan = Rx<SubscriptionPlan?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionData();
  }

  Future<void> fetchSubscriptionData() async {
    try {
      isLoading.value = true;
      final data = await _repository.getSubscriptionData();
      subscriptionData.value = data;
      // Auto-select first active paid plan on initial load
      if (selectedPlan.value == null) {
        final active = data.plans.where((p) => p.status == 1 && !p.isFree).toList();
        if (active.isNotEmpty) selectedPlan.value = active.first;
      }
    } catch (e) {
      AppSnackBar.error(AppStrings.failedToFetchSubscriptionData);
    } finally {
      isLoading.value = false;
    }
  }
}
