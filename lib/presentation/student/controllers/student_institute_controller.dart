import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/data/models/student_institute_model.dart';
import 'package:tuoora/data/repositories/student_institute_repository.dart';

class StudentInstituteController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<StudentInstituteModel> instituteData = Rxn<StudentInstituteModel>();

  late final StudentInstituteRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentInstituteRepository(Get.find<ApiClient>());
    fetchInstitute();
  }

  Future<void> fetchInstitute() async {
    try {
      isLoading.value = true;
      final data = await _repository.getInstitute();
      instituteData.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load institute details');
    } finally {
      isLoading.value = false;
    }
  }
}
