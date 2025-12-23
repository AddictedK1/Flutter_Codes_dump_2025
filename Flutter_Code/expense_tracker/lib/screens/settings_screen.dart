import 'package:flutter/material.dart';
import '../services/expense_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ExpenseManager _expenseManager = ExpenseManager();
  final TextEditingController _budgetController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final budget = await _expenseManager.getMonthlyBudget();
    setState(() {
      _budgetController.text = budget > 0 ? budget.toString() : '';
      _isLoading = false;
    });
  }

  Future<void> _saveBudget() async {
    final budgetText = _budgetController.text.trim();
    if (budgetText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a budget amount')),
      );
      return;
    }

    final budget = double.tryParse(budgetText);
    if (budget == null || budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    await _expenseManager.setMonthlyBudget(budget);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget saved successfully')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Budget',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set your monthly budget to track your expenses',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget Amount',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your monthly budget',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveBudget,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Budget'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
