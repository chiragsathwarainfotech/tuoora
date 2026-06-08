class Subscription {
  final int id;
  final int? instituteId;
  final String planName;
  final String amount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;

  const Subscription({
    required this.id,
    this.instituteId,
    required this.planName,
    required this.amount,
    this.startDate,
    this.endDate,
    required this.status,
  });

  bool get isActive => status.toLowerCase() == 'active';
  bool get isExpired => status.toLowerCase() == 'expired';
  bool get isPending => status.toLowerCase() == 'pending';

  Subscription copyWith({String? status}) {
    return Subscription(
      id: id,
      instituteId: instituteId,
      planName: planName,
      amount: amount,
      startDate: startDate,
      endDate: endDate,
      status: status ?? this.status,
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.tryParse(value.toString());
    }

    return Subscription(
      id: json['id'] ?? 0,
      instituteId: json['institute_id'],
      planName: json['plan_name'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      status: (json['status'] ?? '').toString(),
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
    };
  }
}
