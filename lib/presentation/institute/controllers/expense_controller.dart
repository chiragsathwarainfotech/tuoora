import 'package:tuoora/core/utils/validation_utils.dart';
import 'package:tuoora/data/repositories_impl/institute_repository_impl.dart';
import 'package:tuoora/presentation/institute/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/api/api_exception.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class ExpenseController extends GetxController {
  final InstituteRepositoryImpl _repository;

  ExpenseController(this._repository);

  final expenses = <ExpenseModel>[].obs;
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final categories = <ExpenseCategory>[].obs;

  // Analysis State
  final expenseAnalysis = Rxn<ExpenseAnalysis>();
  final isAnalysisLoading = false.obs;
  final selectedAnalysisMonth = DateTime.now().obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalItems = 0.obs;

  // Add Expense Form Controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedCategory = Rxn<ExpenseCategory>();
  final selectedDate = DateTime.now().obs;
  final isOnlinePayment = false.obs;
  final selectedReceiptPath = RxnString();
  final formKey = GlobalKey<FormState>();

  // Validation States (Pattern consistent with Add Student)
  final triedToSave = false.obs;
  final amountError = RxnString();
  final descriptionError = RxnString();
  final categoryError = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
    loadCategories();
    loadExpenseAnalysis();

    // Listeners to clear errors as user types
    amountController.addListener(() {
      if (triedToSave.value) validateForm();
    });
    descriptionController.addListener(() {
      if (triedToSave.value) validateForm();
    });
    ever(selectedCategory, (_) {
      if (triedToSave.value) validateForm();
    });

    // Auto-refresh analysis when month changes
    ever(selectedAnalysisMonth, (_) => loadExpenseAnalysis());
  }

  bool validateForm() {
    bool isValid = true;

    // Amount validation
    final amountVal = ValidationUtils.validateAmount(
      amountController.text,
      'Amount',
    );
    amountError.value = amountVal;
    if (amountVal != null) isValid = false;

    // Description validation
    final descVal = ValidationUtils.validateRequired(
      descriptionController.text,
      'Description',
    );
    descriptionError.value = descVal;
    if (descVal != null) isValid = false;

    // Category validation
    final categoryVal = ValidationUtils.validateCategorySelection(
      selectedCategory.value,
    );
    categoryError.value = categoryVal;
    if (categoryVal != null) isValid = false;

    return isValid;
  }

  Future<void> loadExpenses({int page = 1}) async {
    if (isLoading.value && page != 1) return;

    try {
      if (page == 1) isLoading.value = true;
      final response = await _repository.listExpenses(page: page);

      if (page == 1) {
        expenses.assignAll(response.items);
      } else {
        expenses.addAll(response.items);
      }

      currentPage.value = response.currentPage;
      lastPage.value = response.lastPage;
      totalItems.value = response.total;
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    } finally {
      if (page == 1) isLoading.value = false;
    }
  }

  Future<void> loadMoreExpenses() async {
    if (currentPage.value < lastPage.value) {
      await loadExpenses(page: currentPage.value + 1);
    }
  }

  Future<void> loadCategories() async {
    try {
      isCategoriesLoading.value = true;
      final fetchedCategories = await _repository.getExpenseCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      debugPrint('Error loading categories: $e');
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> loadExpenseAnalysis() async {
    try {
      isAnalysisLoading.value = true;
      final month = DateFormat('MM').format(selectedAnalysisMonth.value);
      final year = DateFormat('yyyy').format(selectedAnalysisMonth.value);

      final analysis = await _repository.getExpenseAnalysis(month, year);

      // Sort categories by percentage descending (high first)
      analysis.categories.sort((a, b) => b.percentage.compareTo(a.percentage));

      expenseAnalysis.value = analysis;
    } catch (e) {
      debugPrint('Error loading analysis: $e');
      expenseAnalysis.value = null;
    } finally {
      isAnalysisLoading.value = false;
    }
  }

  bool get canGoToNextMonth {
    final now = DateTime.now();
    final currentView = selectedAnalysisMonth.value;
    // Cannot go beyond current month
    if (currentView.year < now.year) return true;
    if (currentView.year == now.year && currentView.month < now.month) {
      return true;
    }
    return false;
  }

  void nextAnalysisMonth() {
    if (!canGoToNextMonth) return;

    selectedAnalysisMonth.value = DateTime(
      selectedAnalysisMonth.value.year,
      selectedAnalysisMonth.value.month + 1,
    );
  }

  void prevAnalysisMonth() {
    selectedAnalysisMonth.value = DateTime(
      selectedAnalysisMonth.value.year,
      selectedAnalysisMonth.value.month - 1,
    );
  }

  void setAnalysisMonth(DateTime date) {
    selectedAnalysisMonth.value = DateTime(date.year, date.month);
  }

  void resetForm() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory.value = null;
    selectedDate.value = DateTime.now();
    isOnlinePayment.value = false;
    selectedReceiptPath.value = null;
    triedToSave.value = false;
    amountError.value = null;
    descriptionError.value = null;
    categoryError.value = null;
  }

  void togglePaymentMethod(bool isOnline) {
    isOnlinePayment.value = isOnline;
  }

  Future<void> pickReceipt() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        selectedReceiptPath.value = result.files.single.path!;
      }
    } catch (e) {
      AppSnackBar.error('Failed to pick receipt: $e');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  Future<void> addExpense() async {
    triedToSave.value = true;
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        'expense_category_id': selectedCategory.value!.id.toString(),
        'amount': amountController.text,
        'date': selectedDate.value.toIso8601String().split('T')[0],
        'description': descriptionController.text,
        'payment_method': isOnlinePayment.value ? 'Online' : 'Cash',
      };

      if (selectedReceiptPath.value != null) {
        data['receipt_image'] = selectedReceiptPath.value;
      }

      await _repository.createExpense(data);

      Get.back();
      Get.snackbar('Success', 'Expense added successfully');
      resetForm();
      loadExpenses(page: 1); // Refresh list
      loadExpenseAnalysis(); // Refresh analysis
    } catch (e) {
      if (e is ValidationException) {
        _handleValidationErrors(e.errors);
        AppSnackBar.error('Please correct the highlighted errors');
      } else {
        AppSnackBar.error(e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _handleValidationErrors(Map<String, dynamic> errors) {
    if (errors.containsKey('amount')) {
      amountError.value = (errors['amount'] as List).first.toString();
    }
    if (errors.containsKey('description')) {
      descriptionError.value = (errors['description'] as List).first.toString();
    }
    if (errors.containsKey('expense_category_id')) {
      categoryError.value = (errors['expense_category_id'] as List).first
          .toString();
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
