import 'package:get/get.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  // Observable list of expenses
  var expenses = <Expense>[].obs;

  // Observable for total expenses
  var totalExpenses = 0.0.obs;

  // Categories
  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Other',
  ];

  // Add expense
  void addExpense(Expense expense) {
    expenses.add(expense);
    _calculateTotal();
  }

  // Delete expense
  void deleteExpense(String id) {
    expenses.removeWhere((expense) => expense.id == id);
    _calculateTotal();
  }

  // Calculate total expenses
  void _calculateTotal() {
    totalExpenses.value = expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  // Get expenses by category
  List<Expense> getExpensesByCategory(String category) {
    return expenses.where((expense) => expense.category == category).toList();
  }

  // Get today's expenses
  List<Expense> getTodayExpenses() {
    final today = DateTime.now();
    return expenses.where((expense) {
      return expense.date.year == today.year &&
          expense.date.month == today.month &&
          expense.date.day == today.day;
    }).toList();
  }

  // Get total for a specific category
  double getTotalByCategory(String category) {
    return getExpensesByCategory(
      category,
    ).fold(0, (sum, expense) => sum + expense.amount);
  }
}
