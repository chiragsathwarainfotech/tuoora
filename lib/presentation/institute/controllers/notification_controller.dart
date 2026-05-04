import 'package:fee_easy/data/models/notification_model.dart';
import 'package:fee_easy/data/repositories/institute_repository.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final InstituteRepository _repository;

  NotificationController(this._repository);

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedNotifications = await _repository.getNotifications();
      notifications.assignAll(fetchedNotifications);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}
