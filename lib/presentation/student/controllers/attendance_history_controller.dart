import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/student_attendance_model.dart';
import 'package:tuoora/data/repositories/student_attendance_repository.dart';

class AttendanceHistoryController extends GetxController {
  final viewDate = DateTime.now().obs;
  final RxBool isLoading = true.obs;
  final Rxn<StudentAttendanceModel> attendanceData = Rxn<StudentAttendanceModel>();

  late final StudentAttendanceRepository _repository;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void onInit() {
    super.onInit();
    _repository = StudentAttendanceRepository(Get.find<ApiClient>());
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      isLoading.value = true;
      final data = await _repository.getAttendance(
        month: viewDate.value.month,
        year: viewDate.value.year,
      );
      attendanceData.value = data;
    } catch (e) {
      AppSnackBar.error(AppStrings.errFailedLoadAttendance);
    } finally {
      isLoading.value = false;
    }
  }

  void prevMonth() {
    viewDate.value = DateTime(viewDate.value.year, viewDate.value.month - 1);
    fetchAttendance();
  }

  void nextMonth() {
    final now = DateTime.now();
    final nextDate = DateTime(viewDate.value.year, viewDate.value.month + 1);
    // Do not allow future months
    if (nextDate.year > now.year || (nextDate.year == now.year && nextDate.month > now.month)) {
      return;
    }
    viewDate.value = nextDate;
    fetchAttendance();
  }

  void goToToday() {
    final now = DateTime.now();
    if (viewDate.value.year != now.year || viewDate.value.month != now.month) {
      viewDate.value = DateTime(now.year, now.month);
      fetchAttendance();
    }
  }

  String get profileRoute => AppRoutes.studentSettings;
  String get updatesRoute => AppRoutes.studentNotifications;

  String get currentMonthName => months[viewDate.value.month - 1];
  String get currentYear => viewDate.value.year.toString();

  /// True only when the currently-viewed month is earlier than this month
  /// — i.e. there is at least one valid past month the user can advance
  /// into. The Next arrow on the calendar header uses this to render
  /// itself as disabled when the user is already on the current month.
  bool get canGoNext {
    final now = DateTime.now();
    final view = viewDate.value;
    if (view.year < now.year) return true;
    if (view.year == now.year && view.month < now.month) return true;
    return false;
  }
}
