import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';

/// Controller for the student-side Fees tab + Receipt + Pay-fees screens.
///
/// Holds the summary (paid / pending split), the list of monthly
/// statements, the currently-selected statement (for the receipt screen),
/// and helper methods to drive navigation. Mock seeds match the design
/// screenshots; swap [loadFees] for a repository call when the API lands.
class FeesController extends GetxController {
  /// Header card aggregate.
  final Rx<FeeSummary> summary = const FeeSummary(
    totalInRupees: 22500,
    paidInRupees: 13500,
    pendingInRupees: 9000,
    billedMonths: 5,
    pendingMonthsLabel: '2 months · May - Feb',
  ).obs;

  /// Monthly statement list. First entry is the most-recent month.
  final RxList<FeeStatement> statements = <FeeStatement>[].obs;

  /// Set when the user taps a statement; read by the receipt screen.
  final Rxn<FeeStatement> selectedStatement = Rxn<FeeStatement>();

  /// Identity data shown on the receipt + pay-fees screens.
  final Rx<StudentBillingProfile> billingProfile = const StudentBillingProfile(
    studentName: 'Aarav Sharma',
    rollNumber: 'STU-2026-041',
    instituteName: 'Saraswati Coaching Centre',
    instituteUpiHandle: 'saraswati@ybl',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadFees();
  }

  void loadFees() {
    statements.assignAll(_seedStatements);
  }

  /// Opens the receipt screen for the given [statement].
  void openReceipt(FeeStatement statement) {
    selectedStatement.value = statement;
    Get.toNamed(AppRoutes.studentFeeReceipt);
  }

  /// Opens the Pay-fees (UPI QR) screen. The screen reads
  /// [summary] + [billingProfile] directly — no extra state to set.
  void openPayFees() {
    Get.toNamed(AppRoutes.studentPayFees);
  }

  /// Copy-to-clipboard handler for the UPI handle on the pay-fees screen.
  Future<void> copyUpiHandle() async {
    final handle = billingProfile.value.instituteUpiHandle;
    await Clipboard.setData(ClipboardData(text: handle));
    AppSnackBar.success(handle, title: AppStrings.studentPayFeesCopyHint);
  }

  // ────────────────────────────────────────────────────────── mock seeds

  static const _seedStatements = <FeeStatement>[
    FeeStatement(
      id: 'INV-2026-05',
      periodLabel: 'May 2026',
      monthHeader: 'MAY 2026',
      amountInRupees: 4500,
      status: FeeStatus.pending,
      dateLabel: 'Due 25 May',
      dueDateShort: '25 May',
      lateFeeLabel: '₹100 after due date',
    ),
    FeeStatement(
      id: 'INV-2026-04',
      periodLabel: 'April 2026',
      monthHeader: 'APRIL 2026',
      amountInRupees: 4500,
      status: FeeStatus.paid,
      dateLabel: 'Paid 02 Apr · UPI · PhonePe',
      dueDateShort: '25 Apr',
    ),
    FeeStatement(
      id: 'INV-2026-03',
      periodLabel: 'March 2026',
      monthHeader: 'MARCH 2026',
      amountInRupees: 4500,
      status: FeeStatus.paid,
      dateLabel: 'Paid 04 Mar · Cash',
      dueDateShort: '25 Mar',
    ),
    FeeStatement(
      id: 'INV-2026-02',
      periodLabel: 'Feb 2026',
      monthHeader: 'FEB 2026',
      amountInRupees: 4500,
      status: FeeStatus.pending,
      dateLabel: 'Due 25 Feb',
      dueDateShort: '25 Feb',
      lateFeeLabel: '₹100 after due date',
    ),
    FeeStatement(
      id: 'INV-2026-01',
      periodLabel: 'Jan 2026',
      monthHeader: 'JAN 2026',
      amountInRupees: 4500,
      status: FeeStatus.paid,
      dateLabel: 'Paid 03 Jan · UPI · GPay',
      dueDateShort: '25 Jan',
    ),
  ];
}
