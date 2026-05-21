import 'package:tuoora/core/enums/app_enums.dart';

class FeeStatement {
  final String id;
  final String periodLabel;
  final String monthHeader;
  final int amountInRupees;
  final FeeStatus status;
  final String dateLabel;
  final String dueDateShort;
  final String? lateFeeLabel;

  const FeeStatement({
    required this.id,
    required this.periodLabel,
    required this.monthHeader,
    required this.amountInRupees,
    required this.status,
    required this.dateLabel,
    required this.dueDateShort,
    this.lateFeeLabel,
  });

  bool get isPaid => status == FeeStatus.paid;
  bool get isPending => status == FeeStatus.pending;
}

class FeeSummary {
  final int totalInRupees;
  final int paidInRupees;
  final int pendingInRupees;
  final int billedMonths;
  final String pendingMonthsLabel;

  const FeeSummary({
    required this.totalInRupees,
    required this.paidInRupees,
    required this.pendingInRupees,
    required this.billedMonths,
    required this.pendingMonthsLabel,
  });

  double get paidFraction =>
      totalInRupees == 0 ? 0 : paidInRupees / totalInRupees;

  int get paidPercent => (paidFraction * 100).round();
}

class StudentBillingProfile {
  final String studentName;
  final String rollNumber;
  final String instituteName;
  final String instituteUpiHandle;

  const StudentBillingProfile({
    required this.studentName,
    required this.rollNumber,
    required this.instituteName,
    required this.instituteUpiHandle,
  });
}
