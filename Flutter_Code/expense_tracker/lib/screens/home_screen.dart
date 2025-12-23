import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';
import '../screens/add_expense_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/expense_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExpenseManager _expenseManager = ExpenseManager();
  List<Expense> _expenses = [];
  List<Expense> _filteredExpenses = [];
  double _monthlyBudget = 0.0;
  double _currentMonthTotal = 0.0;
  Map<String, double> _categoryTotals = {};
  bool _isLoading = true;

  String? _selectedCategoryFilter;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final expenses = await _expenseManager.loadExpenses();
    final budget = await _expenseManager.getMonthlyBudget();
    final monthTotal = await _expenseManager.getCurrentMonthTotal();
    final categoryTotals = await _expenseManager.getCategoryTotals();

    setState(() {
      _expenses = expenses;
      _filteredExpenses = expenses;
      _monthlyBudget = budget;
      _currentMonthTotal = monthTotal;
      _categoryTotals = categoryTotals;
      _isLoading = false;
    });

    _applyFilters();
  }

  void _applyFilters() {
    List<Expense> filtered = List.from(_expenses);

    if (_selectedCategoryFilter != null) {
      filtered = filtered
          .where((e) => e.category == _selectedCategoryFilter)
          .toList();
    }

    if (_selectedDateRange != null) {
      filtered = filtered.where((e) {
        return e.date.isAfter(
              _selectedDateRange!.start.subtract(const Duration(days: 1)),
            ) &&
            e.date.isBefore(
              _selectedDateRange!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    setState(() {
      _filteredExpenses = filtered;
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _applyFilters();
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategoryFilter = null;
      _selectedDateRange = null;
    });
    _applyFilters();
  }

  Future<void> _addExpense() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );

    if (result == true) {
      _loadData();
    }
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );

    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildBudgetCard(),
                _buildFilterBar(),
                if (_categoryTotals.isNotEmpty) _buildCategoryTotals(),
                Expanded(
                  child: ExpenseListWidget(
                    expenses: _filteredExpenses,
                    onExpenseChanged: _loadData,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBudgetCard() {
    final progress = _monthlyBudget > 0
        ? _currentMonthTotal / _monthlyBudget
        : 0.0;
    final progressClamped = progress.clamp(0.0, 1.0);

    Color progressColor;
    if (progress < 0.7) {
      progressColor = Colors.green;
    } else if (progress < 0.9) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_currentMonthTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
                if (_monthlyBudget > 0)
                  Text(
                    'of \$${_monthlyBudget.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_monthlyBudget > 0) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressClamped,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                progress >= 1.0
                    ? 'Budget exceeded by \$${(_currentMonthTotal - _monthlyBudget).toStringAsFixed(2)}'
                    : 'Remaining: \$${(_monthlyBudget - _currentMonthTotal).toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: progress >= 1.0 ? Colors.red : Colors.grey[700],
                  fontWeight: progress >= 1.0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ] else
              const Text(
                'Set a monthly budget in Settings',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final hasFilters =
        _selectedCategoryFilter != null || _selectedDateRange != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(_selectedCategoryFilter ?? 'All Categories'),
                    selected: _selectedCategoryFilter != null,
                    onSelected: (_) => _showCategoryFilter(),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(
                      _selectedDateRange != null
                          ? '${DateFormat('MMM dd').format(_selectedDateRange!.start)} - ${DateFormat('MMM dd').format(_selectedDateRange!.end)}'
                          : 'All Dates',
                    ),
                    selected: _selectedDateRange != null,
                    onSelected: (_) => _selectDateRange(),
                  ),
                ],
              ),
            ),
          ),
          if (hasFilters)
            IconButton(icon: const Icon(Icons.clear), onPressed: _clearFilters),
        ],
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Categories'),
              leading: const Icon(Icons.all_inclusive),
              onTap: () {
                setState(() => _selectedCategoryFilter = null);
                _applyFilters();
                Navigator.pop(context);
              },
            ),
            ...ExpenseCategory.categories.map((category) {
              return ListTile(
                title: Text(category),
                leading: Icon(_getCategoryIcon(category)),
                onTap: () {
                  setState(() => _selectedCategoryFilter = category);
                  _applyFilters();
                  Navigator.pop(context);
                },
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildCategoryTotals() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Breakdown',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...ExpenseCategory.categories.map((category) {
              final total = _categoryTotals[category] ?? 0.0;
              final percentage = _currentMonthTotal > 0
                  ? (total / _currentMonthTotal * 100)
                  : 0.0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getCategoryColor(category),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.shopping:
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.orange;
      case ExpenseCategory.transport:
        return Colors.blue;
      case ExpenseCategory.shopping:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
