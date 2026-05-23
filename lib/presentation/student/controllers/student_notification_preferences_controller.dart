import 'package:get/get.dart';
import 'package:tuoora/data/repositories/student_notifications_repository.dart';
import 'dart:async';

class StudentNotificationPreferencesController extends GetxController {
  final StudentNotificationsRepository _repository;

  StudentNotificationPreferencesController(this._repository);

  final isLoading = true.obs;

  final muteEverything = false.obs;
  final feeReminders = false.obs;
  final assignmentAlerts = false.obs;
  final attendance = false.obs;
  final dailyUpdates = false.obs;
  final eventsHolidays = false.obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      final data = await _repository.getNotificationSettings();
      _updateObservables(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notification settings');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateObservables(Map<String, dynamic> data) {
    muteEverything.value = _parseBool(data['mute_all']);
    feeReminders.value = _parseBool(data['fee_reminders']);
    assignmentAlerts.value = _parseBool(data['assignment_alerts']);
    attendance.value = _parseBool(data['attendance']);
    dailyUpdates.value = _parseBool(data['daily_updates']);
    eventsHolidays.value = _parseBool(data['events_holidays']);
  }

  void _syncSettings() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final data = {
          'mute_all': muteEverything.value,
          'daily_updates': dailyUpdates.value,
          'fee_reminders': feeReminders.value,
          'assignment_alerts': assignmentAlerts.value,
          'attendance': attendance.value,
          'events_holidays': eventsHolidays.value,
        };
        await _repository.updateNotificationSettings(data);
      } catch (e) {
        Get.snackbar('Error', 'Failed to update settings');
        fetchSettings(); // Revert to remote on failure
      }
    });
  }

  void toggleMuteEverything(bool value) {
    muteEverything.value = value;
    if (value) {
      feeReminders.value = false;
      assignmentAlerts.value = false;
      attendance.value = false;
      dailyUpdates.value = false;
      eventsHolidays.value = false;
    }
    _syncSettings();
  }

  void _unmuteIfAllMuted() {
    if (muteEverything.value) {
      muteEverything.value = false;
    }
  }

  void toggleFeeReminders(bool value) {
    feeReminders.value = value;
    if (value) _unmuteIfAllMuted();
    _syncSettings();
  }

  void toggleAssignmentAlerts(bool value) {
    assignmentAlerts.value = value;
    if (value) _unmuteIfAllMuted();
    _syncSettings();
  }

  void toggleAttendance(bool value) {
    attendance.value = value;
    if (value) _unmuteIfAllMuted();
    _syncSettings();
  }

  void toggleDailyUpdates(bool value) {
    dailyUpdates.value = value;
    if (value) _unmuteIfAllMuted();
    _syncSettings();
  }

  void toggleEventsHolidays(bool value) {
    eventsHolidays.value = value;
    if (value) _unmuteIfAllMuted();
    _syncSettings();
  }
}
