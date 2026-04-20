import 'package:flutter/material.dart';

class FeeRecord {
  final String studentName;
  final String studentId;
  final String batch;
  final String amount;
  final String status; // 'Paid', 'Due', 'Partial'
  final String month;
  final String paymentMethod; // 'Cash', 'Online'
  final DateTime timestamp;
  final Color statusBg;
  final Color statusText;

  FeeRecord({
    required this.studentName,
    required this.studentId,
    required this.batch,
    required this.amount,
    required this.status,
    required this.month,
    required this.paymentMethod,
    required this.timestamp,
    required this.statusBg,
    required this.statusText,
  });
}
