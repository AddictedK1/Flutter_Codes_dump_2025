import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  String _selectedType = 'expense';
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = [
    'Food',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills',
    'Healthcare',
    'Education',
    'Other',
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Gift',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 20),
              _buildTitleField(),
              const SizedBox(height: 16),
              _buildAmountField(),
              const SizedBox(height: 16),
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Income'),
                value: 'income',
                groupValue: _selectedType,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _selectedCategory = _incomeCategories[0];
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Expense'),
                value: 'expense',
                groupValue: _selectedType,
                activeColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _selectedCategory = _expenseCategories[0];
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'Enter transaction title',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: 'Enter amount',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.currency_rupee),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(value) <= 0) {
          return 'Amount must be greater than 0';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = _selectedType == 'income'
        ? _incomeCategories
        : _expenseCategories;

    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.category),
      ),
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
    );
  }

  Widget _buildDatePicker() {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(dateFormat.format(_selectedDate)),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Enter description',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.notes),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Add Transaction',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      try {
        final transaction = TransactionModel(
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          type: _selectedType,
          category: _selectedCategory,
          date: _selectedDate,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
        );

        await _firestoreService.addTransaction(transaction);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
