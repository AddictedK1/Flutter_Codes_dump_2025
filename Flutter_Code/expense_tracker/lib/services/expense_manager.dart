import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseManager {
  static const String _expensesKey = 'expenses';
  static const String _budgetKey = 'monthly_budget';

  // Save expenses to shared preferences
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = expenses.map((e) => e.toJson()).toList();
    await prefs.setString(_expensesKey, jsonEncode(jsonList));
  }

  // Load expenses from shared preferences
  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_expensesKey);

    if (jsonString == null) {
      return [];
    }

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    final expenses = await loadExpenses();
    expenses.add(expense);
    await saveExpenses(expenses);
  }

  // Update an existing expense
  Future<void> updateExpense(String id, Expense updatedExpense) async {
    final expenses = await loadExpenses();
    final index = expenses.indexWhere((e) => e.id == id);

    if (index != -1) {
      expenses[index] = updatedExpense;
      await saveExpenses(expenses);
    }
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    final expenses = await loadExpenses();
    expenses.removeWhere((e) => e.id == id);
    await saveExpenses(expenses);
  }

  // Get expenses filtered by category
  Future<List<Expense>> getExpensesByCategory(String category) async {
    final expenses = await loadExpenses();
    return expenses.where((e) => e.category == category).toList();
  }

  // Get expenses within a date range
  Future<List<Expense>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final expenses = await loadExpenses();
    return expenses.where((e) {
      return e.date.isAfter(start.subtract(const Duration(days: 1))) &&
          e.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Calculate total expenses
  Future<double> getTotalExpenses() async {
    final expenses = await loadExpenses();
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  // Calculate category-wise totals
  Future<Map<String, double>> getCategoryTotals() async {
    final expenses = await loadExpenses();
    final Map<String, double> totals = {};

    for (var expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }

    return totals;
  }

  // Save monthly budget
  Future<void> setMonthlyBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }

  // Get monthly budget
  Future<double> getMonthlyBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey) ?? 0.0;
  }

  // Get current month expenses
  Future<double> getCurrentMonthTotal() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final expenses = await getExpensesByDateRange(startOfMonth, endOfMonth);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }
}
