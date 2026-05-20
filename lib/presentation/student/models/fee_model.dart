/// Status of a fee statement / receipt row.
enum FeeStatus { paid, pending }

/// One row in the STATEMENT list on the fees tab. Also drives the
/// receipt screen when tapped.
class FeeStatement {
  final String id; // 'INV-2026-05'
  final String periodLabel; // 'May 2026'
  final String monthHeader; // 'MAY 2026' (uppercase, used on receipt)
  final int amountInRupees;
  final FeeStatus status;

  /// `Due 25 May` (pending) or `Paid 02 Apr · UPI · PhonePe` (paid).
  final String dateLabel;

  /// `25 May` — used as the standalone due-date row on the receipt.
  final String dueDateShort;

  /// e.g. `₹100 after due date`. Optional.
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

/// Aggregate header card on the fees tab.
class FeeSummary {
  final int totalInRupees;
  final int paidInRupees;
  final int pendingInRupees;
  final int billedMonths;

  /// Pre-formatted list of pending months for the pay-fees outstanding
  /// header (e.g. `2 months · May - Feb`).
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

/// Static identity data shown on the receipt / pay-fees screens. In a
/// real build this comes from AuthService + institute profile; we keep
/// it on a tiny value object so the UI doesn't reach into other layers.
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
