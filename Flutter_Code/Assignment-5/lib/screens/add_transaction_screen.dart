import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/firestore_service.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String selectedType = "expense";
  String selectedCategory = "Food";

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "Note"),
            ),

            DropdownButton<String>(
              value: selectedCategory,
              items: [
                "Food",
                "Shopping",
                "Salary",
                "Travel",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
            ),

            DropdownButton<String>(
              value: selectedType,
              items: [
                "income",
                "expense",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => selectedType = v!),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final text = _amountController.text.trim();
                final amount = double.tryParse(text);
                if (text.isEmpty || amount == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount'),
                    ),
                  );
                  return;
                }

                final transaction = TransactionModel(
                  id: const Uuid().v4(),
                  amount: amount,
                  category: selectedCategory,
                  type: selectedType,
                  date: DateTime.now(),
                  note: _noteController.text,
                );

                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await firestoreService.addTransaction(transaction);
                  if (mounted) navigator.pop();
                } catch (e) {
                  if (mounted)
                    messenger.showSnackBar(
                      SnackBar(content: Text('Failed adding transaction: $e')),
                    );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
