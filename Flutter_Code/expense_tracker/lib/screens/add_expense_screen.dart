import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../services/expense_manager.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense; // If provided, we're editing

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final ExpenseManager _expenseManager = ExpenseManager();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      // Editing existing expense
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    final note = _noteController.text.trim();

    if (widget.expense == null) {
      // Adding new expense
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        note: note,
      );
      await _expenseManager.addExpense(expense);
    } else {
      // Updating existing expense
      final updatedExpense = widget.expense!.copyWith(
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        note: note,
      );
      await _expenseManager.updateExpense(widget.expense!.id, updatedExpense);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  hintText: 'Enter amount',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ExpenseCategory.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(category), size: 20),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note Field
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Add a note',
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'Update Expense' : 'Add Expense'),
                ),
              ),
            ],
          ),
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
}
