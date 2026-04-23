class FeeRecord {
  final String studentName;
  final String studentId;
  final String batch;
  final String amount;
  final String month;
  final String paymentMethod; // 'Cash', 'Online'
  final DateTime timestamp;

  FeeRecord({
    required this.studentName,
    required this.studentId,
    required this.batch,
    required this.amount,
    required this.month,
    required this.paymentMethod,
    required this.timestamp,
  });
}
