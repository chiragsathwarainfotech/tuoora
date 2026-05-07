import 'package:fee_easy/presentation/institute/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  final expenses = <ExpenseModel>[].obs;
  final isLoading = false.obs;

  // Add Expense Form Controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedCategory = 'Shopping'.obs;
  final selectedDate = DateTime.now().obs;
  final isOnlinePayment = false.obs;
  final selectedReceiptPath = RxnString();
  final selectedAnalysisMonth = DateTime.now().obs;
  final formKey = GlobalKey<FormState>();

  void nextAnalysisMonth() {
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

  final categories = [
    'Shopping',
    'Bills',
    'Entertainment',
    'Food & Drink',
    'Transport',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  void loadExpenses() {
    expenses.assignAll([
      ExpenseModel(
        id: '1',
        title: 'Grocery Store',
        date: DateTime(2023, 10, 12),
        category: 'Shopping',
        amount: 120.50,
        icon: Icons.shopping_cart_rounded,
        iconBgColor: const Color(0xFFFFF7ED),
      ),
      ExpenseModel(
        id: '2',
        title: 'Utility Bill',
        date: DateTime(2023, 10, 8),
        category: 'Bills',
        amount: 85.00,
        icon: Icons.bolt_rounded,
        iconBgColor: const Color(0xFFEFF6FF),
      ),
      ExpenseModel(
        id: '3',
        title: 'Netflix Subscription',
        date: DateTime(2023, 10, 5),
        category: 'Entertainment',
        amount: 15.99,
        icon: Icons.movie_rounded,
        iconBgColor: const Color(0xFFFAF5FF),
      ),
      ExpenseModel(
        id: '4',
        title: 'Starbucks Coffee',
        date: DateTime(2023, 10, 3),
        category: 'Food & Drink',
        amount: 5.45,
        icon: Icons.local_cafe_rounded,
        iconBgColor: const Color(0xFFECFDF5),
      ),
      ExpenseModel(
        id: '5',
        title: 'Uber Ride',
        date: DateTime(2023, 10, 1),
        category: 'Transport',
        amount: 24.30,
        icon: Icons.directions_car_rounded,
        iconBgColor: const Color(0xFFF1F5F9),
      ),
    ]);
  }

  void resetForm() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory.value = 'Shopping';
    selectedDate.value = DateTime.now();
    isOnlinePayment.value = false;
    selectedReceiptPath.value = null;
  }

  void togglePaymentMethod(bool isOnline) {
    isOnlinePayment.value = isOnline;
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

  void addExpense() {
    if (formKey.currentState?.validate() ?? false) {
      final newExpense = ExpenseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: descriptionController.text.isEmpty
            ? selectedCategory.value
            : descriptionController.text,
        date: selectedDate.value,
        category: selectedCategory.value,
        amount: double.tryParse(amountController.text) ?? 0.0,
        icon: _getIconForCategory(selectedCategory.value),
        iconBgColor: _getBgColorForCategory(selectedCategory.value),
      );

      expenses.insert(0, newExpense);
      Get.back();
      Get.snackbar('Success', 'Expense added successfully');
      resetForm();
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_cart_rounded;
      case 'Bills':
        return Icons.bolt_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Food & Drink':
        return Icons.local_cafe_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      default:
        return Icons.payments_rounded;
    }
  }

  Color _getBgColorForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return const Color(0xFFFFF7ED);
      case 'Bills':
        return const Color(0xFFEFF6FF);
      case 'Entertainment':
        return const Color(0xFFFAF5FF);
      case 'Food & Drink':
        return const Color(0xFFECFDF5);
      case 'Transport':
        return const Color(0xFFF1F5F9);
      default:
        return const Color(0xFFF8FAFC);
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
