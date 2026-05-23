import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/data/models/student_report_model.dart';
import 'package:tuoora/data/repositories/student_report_repository.dart';

class StudentReportsController extends GetxController {
  final selectedPeriod = ReportPeriod.fourWeeks.obs;
  final RxBool isLoading = true.obs;
  final Rxn<StudentReportModel> reportData = Rxn<StudentReportModel>();

  late final StudentReportRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentReportRepository(Get.find<ApiClient>());
    fetchReport();

    ever(selectedPeriod, (_) => fetchReport());
  }

  int _getPeriodValue(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.thisWeek:
        return 1;
      case ReportPeriod.fourWeeks:
        return 4;
      case ReportPeriod.twelveWeeks:
        return 12;
    }
  }

  Future<void> fetchReport() async {
    try {
      isLoading.value = true;
      final data = await _repository.getReport(
        period: _getPeriodValue(selectedPeriod.value),
      );
      reportData.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reports');
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(ReportPeriod period) {
    if (selectedPeriod.value != period) {
      selectedPeriod.value = period;
    }
  }
}
