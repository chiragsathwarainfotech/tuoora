class Subscription {
  final int id;
  final int? instituteId;
  final String planName;
  final String amount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final String effectiveStatus;
  final String statusLabel;
  final int daysLeft;

  const Subscription({
    required this.id,
    this.instituteId,
    required this.planName,
    required this.amount,
    this.startDate,
    this.endDate,
    required this.status,
    this.effectiveStatus = '',
    this.statusLabel = '',
    this.daysLeft = 0,
  });

  bool get isActive => effectiveStatus.toLowerCase() == 'active';
  bool get isExpired => effectiveStatus.toLowerCase() == 'expired';
  bool get isPending => effectiveStatus.toLowerCase() == 'pending';
  bool get isCancel => effectiveStatus.toLowerCase() == 'cancel';
  bool get isExpireSoon => effectiveStatus.toLowerCase() == 'expire_soon';
  bool get isReject => effectiveStatus.toLowerCase() == 'reject';

  Subscription copyWith({String? status}) {
    return Subscription(
      id: id,
      instituteId: instituteId,
      planName: planName,
      amount: amount,
      startDate: startDate,
      endDate: endDate,
      status: status ?? this.status,
      effectiveStatus: effectiveStatus,
      statusLabel: statusLabel,
      daysLeft: daysLeft,
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString())?.toLocal();
    }

    return Subscription(
      id: json['id'] ?? 0,
      instituteId: json['institute_id'],
      planName: json['plan_name'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      status: (json['status'] ?? '').toString(),
      effectiveStatus: (json['effective_status'] ?? json['status'] ?? '').toString(),
      statusLabel: (json['status_label'] ?? '').toString(),
      daysLeft: json['days_left'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institute_id': instituteId,
      'plan_name': planName,
      'amount': amount,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'effective_status': effectiveStatus,
      'status_label': statusLabel,
      'days_left': daysLeft,
    };
  }
}
