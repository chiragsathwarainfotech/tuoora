import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/data/models/student_resource_model.dart';
import 'package:tuoora/data/repositories/student_resource_repository.dart';

class StudentStudyMaterialController extends GetxController {
  final RxBool isLoading = true.obs;

  final RxList<String> subjects = <String>[].obs;
  final RxList<StudentResourceModel> resources = <StudentResourceModel>[].obs;

  late final StudentResourceRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentResourceRepository(Get.find<ApiClient>());
    fetchResources();
  }

  Future<void> fetchResources() async {
    try {
      isLoading.value = true;
      final data = await _repository.getResources();
      subjects.assignAll(data.subjects);
      resources.assignAll(data.resources);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load study materials');
    } finally {
      isLoading.value = false;
    }
  }
}
