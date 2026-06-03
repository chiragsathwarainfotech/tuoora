import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/services/download_service.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/repositories/student_fees_repository.dart';
import 'package:tuoora/data/repositories/student_institute_repository.dart';
import 'package:tuoora/presentation/student/models/fee_model.dart';

class FeesController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool isReceiptLoading = false.obs;
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;

  final Rx<FeeSummary> summary = const FeeSummary(
    totalInRupees: 0,
    paidInRupees: 0,
    pendingInRupees: 0,
    billedMonths: 0,
    pendingMonthsLabel: '',
  ).obs;

  final RxList<FeeStatement> statements = <FeeStatement>[].obs;
  final Rxn<FeeStatement> selectedStatement = Rxn<FeeStatement>();
  final Rxn<StudentReceipt> currentReceipt = Rxn<StudentReceipt>();

  final Rx<StudentBillingProfile> billingProfile = const StudentBillingProfile(
    studentName: '',
    rollNumber: '',
    instituteName: '',
    instituteUpiHandle: '',
  ).obs;

  late final StudentFeesRepository _repository;
  late final StudentInstituteRepository _instituteRepository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentFeesRepository(Get.find<ApiClient>());
    _instituteRepository = StudentInstituteRepository(Get.find<ApiClient>());
    loadFees();
    // Fetch UPI handle + QR url for the Pay Fees screen in the background.
    // We don't block the fees list on this — the Pay Fees screen has its
    // own empty-state when payment isn't configured.
    _loadBillingProfile();
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

  /// Pulls the institute's UPI ID + QR URL from `/student/institute` and
  /// folds them into [billingProfile]. Silent on failure — the Pay Fees
  /// screen falls back to its empty state if both fields are missing.
  Future<void> _loadBillingProfile() async {
    try {
      final inst = await _instituteRepository.getInstitute();
      billingProfile.value = StudentBillingProfile(
        studentName: billingProfile.value.studentName,
        rollNumber: billingProfile.value.rollNumber,
        instituteName: inst.name,
        instituteUpiHandle: inst.upiId ?? '',
        instituteUpiQrCodeUrl: inst.upiQrCodeUrl,
      );
    } catch (_) {
      // Leave billingProfile as-is; Pay Fees screen will show empty state.
    }
  }

  Future<void> openReceipt(FeeStatement statement) async {
    selectedStatement.value = statement;
    currentReceipt.value = null;
    Get.toNamed(AppRoutes.studentFeeReceipt);
    await _fetchReceipt(statement.feeId);
  }

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
      AppSnackBar.error(AppStrings.failedToLoadReceipt);
    } finally {
      isReceiptLoading.value = false;
    }
  }

  Future<void> downloadCurrentReceipt() async {
    final receipt = currentReceipt.value;
    if (receipt == null) return;
    await _downloadReceipt(receipt);
  }

  Future<void> _downloadReceipt(StudentReceipt receipt) async {
    if (isDownloading.value) return;
    isDownloading.value = true;
    downloadProgress.value = 0.0;
    final fileName = receipt.receiptNumber.isNotEmpty
        ? '${receipt.receiptNumber}.pdf'
        : 'receipt-${receipt.id}.pdf';
    try {
      await Get.find<DownloadService>().download(
        label: AppStrings.pleaseWaitYourReceiptIsBeing,
        fileName: fileName,
        fetch: () async => Uint8List.fromList(
          await _repository.downloadFeeReceipt(
            receipt.id,
            onProgress: (p) => downloadProgress.value = p,
          ),
        ),
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
    if (handle.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: handle));
    AppSnackBar.success(handle, title: AppStrings.studentPayFeesCopyHint);
  }
}
