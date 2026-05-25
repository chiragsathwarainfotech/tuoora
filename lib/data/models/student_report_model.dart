class StudentReportModel {
  final int period;
  final ReportSection attendance;
  final ReportSection assignments;

  StudentReportModel({
    required this.period,
    required this.attendance,
    required this.assignments,
  });

  factory StudentReportModel.fromJson(Map<String, dynamic> json) {
    return StudentReportModel(
      period: json['period'] ?? 4,
      attendance: ReportSection.fromJson(json['attendance'] ?? {}),
      assignments: ReportSection.fromJson(json['assignments'] ?? {}),
    );
  }
}

class ReportSection {
  final int pct;
  final ReportSummary summary;
  final List<ReportWeek> weeks;

  ReportSection({
    required this.pct,
    required this.summary,
    required this.weeks,
  });

  factory ReportSection.fromJson(Map<String, dynamic> json) {
    return ReportSection(
      pct: json['pct'] ?? 0,
      summary: ReportSummary.fromJson(json['summary'] ?? {}),
      weeks: (json['weeks'] as List?)
              ?.map((e) => ReportWeek.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ReportSummary {
  final int present;
  final int absent;
  final int completed;
  final int pending;
  final int total;

  ReportSummary({
    this.present = 0,
    this.absent = 0,
    this.completed = 0,
    this.pending = 0,
    this.total = 0,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class ReportWeek {
  final String label;
  final int present;
  final int absent;
  final int completed;
  final int pending;
  final int total;
  final int pct;

  ReportWeek({
    required this.label,
    this.present = 0,
    this.absent = 0,
    this.completed = 0,
    this.pending = 0,
    this.total = 0,
    this.pct = 0,
  });

  factory ReportWeek.fromJson(Map<String, dynamic> json) {
    return ReportWeek(
      label: json['label'] ?? '',
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
      total: json['total'] ?? 0,
      pct: json['pct'] ?? 0, // Sometimes pct might be missing on assignments? Wait, attendance has pct, assignments might not? The user example: "assignments": ... "completed": 1, "pending": 1, "total": 2. We'll compute it if needed.
    );
  }
}
