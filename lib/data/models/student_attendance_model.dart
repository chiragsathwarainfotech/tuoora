class StudentAttendanceModel {
  final AttendanceTodayModel today;
  final AttendanceCalendarModel calendar;
  final AttendanceSummaryModel summary;
  final DateTime? batchAssignedDate;

  StudentAttendanceModel({
    required this.today,
    required this.calendar,
    required this.summary,
    this.batchAssignedDate,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      today: AttendanceTodayModel.fromJson(json['today'] ?? {}),
      calendar: AttendanceCalendarModel.fromJson(json['calendar'] ?? {}),
      summary: AttendanceSummaryModel.fromJson(json['summary'] ?? {}),
      batchAssignedDate: DateTime.tryParse(
        json['batch_assigned_date']?.toString() ?? '',
      )?.toLocal(),
    );
  }
}

class AttendanceTodayModel {
  final String status;
  final String text;

  AttendanceTodayModel({required this.status, required this.text});

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) {
    return AttendanceTodayModel(
      status: json['status'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class AttendanceCalendarModel {
  final int month;
  final int year;
  final String monthLabel;
  final String todayLabel;
  final Map<int, String> days;

  AttendanceCalendarModel({
    required this.month,
    required this.year,
    required this.monthLabel,
    required this.todayLabel,
    required this.days,
  });

  factory AttendanceCalendarModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawDays = json['days'] ?? {};
    final Map<int, String> parsedDays = {};
    rawDays.forEach((key, value) {
      final intDay = int.tryParse(key);
      if (intDay != null) {
        parsedDays[intDay] = value.toString();
      }
    });

    return AttendanceCalendarModel(
      month: json['month'] ?? 1,
      year: json['year'] ?? 2024,
      monthLabel: json['month_label'] ?? '',
      todayLabel: json['today_label'] ?? '',
      days: parsedDays,
    );
  }
}

class AttendanceSummaryModel {
  final String label;
  final int pct;
  final int total;
  final int present;
  final int absent;

  AttendanceSummaryModel({
    required this.label,
    required this.pct,
    required this.total,
    required this.present,
    required this.absent,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      label: json['label'] ?? '',
      pct: json['pct'] ?? 0,
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
    );
  }
}
