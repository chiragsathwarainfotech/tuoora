import 'package:get/get.dart';

class StudentNotificationPreferencesController extends GetxController {
  final muteEverything = false.obs;
  final feeReminders = true.obs;
  final assignmentAlerts = true.obs;
  final attendance = true.obs;
  final dailyUpdates = true.obs;
  final eventsHolidays = true.obs;

  void toggleMuteEverything(bool value) {
    muteEverything.value = value;
    if (value) {
      feeReminders.value = false;
      assignmentAlerts.value = false;
      attendance.value = false;
      dailyUpdates.value = false;
      eventsHolidays.value = false;
    }
  }

  void _unmuteIfAllMuted() {
    if (muteEverything.value) {
      muteEverything.value = false;
    }
  }

  void toggleFeeReminders(bool value) {
    feeReminders.value = value;
    if (value) _unmuteIfAllMuted();
  }

  void toggleAssignmentAlerts(bool value) {
    assignmentAlerts.value = value;
    if (value) _unmuteIfAllMuted();
  }

  void toggleAttendance(bool value) {
    attendance.value = value;
    if (value) _unmuteIfAllMuted();
  }

  void toggleDailyUpdates(bool value) {
    dailyUpdates.value = value;
    if (value) _unmuteIfAllMuted();
  }

  void toggleEventsHolidays(bool value) {
    eventsHolidays.value = value;
    if (value) _unmuteIfAllMuted();
  }
}
