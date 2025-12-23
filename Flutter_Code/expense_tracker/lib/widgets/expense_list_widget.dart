import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';
import '../screens/add_expense_screen.dart';

class ExpenseListWidget extends StatefulWidget {
  final List<Expense> expenses;
  final Function() onExpenseChanged;

  const ExpenseListWidget({
    super.key,
    required this.expenses,
    required this.onExpenseChanged,
  });

  @override
  State<ExpenseListWidget> createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {
  final ExpenseManager _expenseManager = ExpenseManager();

  Map<String, List<Expense>> _groupExpensesByDate() {
    final Map<String, List<Expense>> grouped = {};

    for (var expense in widget.expenses) {
      final dateKey = DateFormat('yyyy-MM-dd').format(expense.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(expense);
    }

    // Sort by date descending
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _expenseManager.deleteExpense(expense.id);
      widget.onExpenseChanged();
    }
  }

  Future<void> _editExpense(Expense expense) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(expense: expense),
      ),
    );

    if (result == true) {
      widget.onExpenseChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first expense to get started',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final groupedExpenses = _groupExpensesByDate();

    return ListView.builder(
      itemCount: groupedExpenses.length,
      itemBuilder: (context, index) {
        final dateKey = groupedExpenses.keys.elementAt(index);
        final expenses = groupedExpenses[dateKey]!;
        final date = DateTime.parse(dateKey);
        final isToday =
            DateFormat('yyyy-MM-dd').format(DateTime.now()) == dateKey;
        final isYesterday =
            DateFormat(
              'yyyy-MM-dd',
            ).format(DateTime.now().subtract(const Duration(days: 1))) ==
            dateKey;

        String dateLabel;
        if (isToday) {
          dateLabel = 'Today';
        } else if (isYesterday) {
          dateLabel = 'Yesterday';
        } else {
          dateLabel = DateFormat('EEEE, MMM dd, yyyy').format(date);
        }

        final dailyTotal = expenses.fold<double>(
          0.0,
          (sum, expense) => sum + expense.amount,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '\$${dailyTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            ...expenses.map((expense) => _buildExpenseCard(expense)),
            const Divider(height: 1),
          ],
        );
      },
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(expense.category),
          child: Icon(
            _getCategoryIcon(expense.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                expense.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        subtitle: expense.note.isNotEmpty
            ? Text(expense.note, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editExpense(expense);
            } else if (value == 'delete') {
              _deleteExpense(expense);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
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
