import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/services/download_service.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/repositories/student_fees_repository.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';

class FeesController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isReceiptLoading = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  /// Aggregate header card values. Defaults are all-zero until the first
  /// fetch resolves.
  final Rx<FeeSummary> summary = const FeeSummary(
    totalInRupees: 0,
    paidInRupees: 0,
    pendingInRupees: 0,
    billedMonths: 0,
    pendingMonthsLabel: '',
  ).obs;

  /// Fees list rendered on the Fees tab.
  final RxList<FeeStatement> statements = <FeeStatement>[].obs;

  /// Set when the user taps a statement; consumed by the receipt screen
  /// for the header/period/amount values that the receipt-detail API
  /// does not return on its own.
  final Rxn<FeeStatement> selectedStatement = Rxn<FeeStatement>();

  /// Latest receipt payload from `/student/receipts/{id}` — populated by
  /// [openReceipt] / [openReceiptById].
  final Rxn<StudentReceipt> currentReceipt = Rxn<StudentReceipt>();

  /// Identity data shown on the Pay-fees screen. Receipt screen now
  /// reads directly from [currentReceipt] instead.
  final Rx<StudentBillingProfile> billingProfile = const StudentBillingProfile(
    studentName: '',
    rollNumber: '',
    instituteName: '',
    instituteUpiHandle: '',
  ).obs;

  late final StudentFeesRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentFeesRepository(Get.find<ApiClient>());
    loadFees();
  }

  Future<void> loadFees() async {
    try {
      isLoading.value = true;
      final data = await _repository.getFees();
      statements.assignAll(data.fees);
      summary.value = data.summary;
    } catch (_) {
      AppSnackBar.error(AppStrings.errFailedLoadFees);
    } finally {
      isLoading.value = false;
    }
  }

  /// Opens the receipt screen for [statement] and fetches the receipt
  /// detail from the API. The screen renders a spinner while loading.
  Future<void> openReceipt(FeeStatement statement) async {
    selectedStatement.value = statement;
    currentReceipt.value = null;
    Get.toNamed(AppRoutes.studentFeeReceipt);
    await _fetchReceipt(statement.feeId);
  }

  /// Opens the receipt screen by id alone (used from the receipts-list
  /// screen which has no [FeeStatement] context).
  Future<void> openReceiptById(int feeId) async {
    selectedStatement.value = null;
    currentReceipt.value = null;
    Get.toNamed(AppRoutes.studentFeeReceipt);
    await _fetchReceipt(feeId);
  }

  Future<void> _fetchReceipt(int feeId) async {
    try {
      isReceiptLoading.value = true;
      currentReceipt.value = await _repository.getReceipt(feeId);
    } catch (_) {
      AppSnackBar.error('Failed to load receipt');
    } finally {
      isReceiptLoading.value = false;
    }
  }

  /// Downloads the receipt PDF for the currently-open receipt. The
  /// receipt screen wires its download button to this.
  Future<void> downloadCurrentReceipt() async {
    final receipt = currentReceipt.value;
    if (receipt == null) return;
    await _downloadReceipt(receipt);
  }

  Future<void> _downloadReceipt(StudentReceipt receipt) async {
    if (isDownloading.value) return;
    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      AppSnackBar.success(
        'Please wait, your receipt is being downloaded...',
        title: AppStrings.labelDownloading,
      );

      final bytes = await _repository.downloadFeeReceipt(
        receipt.id,
        onProgress: (p) => downloadProgress.value = p,
      );

      final downloadService = Get.find<DownloadService>();
      final fileName = receipt.receiptNumber.isNotEmpty
          ? '${receipt.receiptNumber}.pdf'
          : 'receipt-${receipt.id}.pdf';
      await downloadService.saveFile(
        bytes: Uint8List.fromList(bytes),
        fileName: fileName,
      );
    } catch (e) {
      AppSnackBar.error(
        'Failed to download receipt: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  void openPayFees() {
    Get.toNamed(AppRoutes.studentPayFees);
  }

  Future<void> copyUpiHandle() async {
    final handle = billingProfile.value.instituteUpiHandle;
    await Clipboard.setData(ClipboardData(text: handle));
    AppSnackBar.success(handle, title: AppStrings.studentPayFeesCopyHint);
  }
}
