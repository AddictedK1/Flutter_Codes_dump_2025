import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import 'add_transaction_screen.dart';

class ExpenseManagerHome extends StatefulWidget {
  const ExpenseManagerHome({super.key});

  @override
  State<ExpenseManagerHome> createState() => _ExpenseManagerHomeState();
}

class _ExpenseManagerHomeState extends State<ExpenseManagerHome> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedFilter = 'all'; // all, income, expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Manager'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Transactions'),
              ),
              const PopupMenuItem(value: 'income', child: Text('Income Only')),
              const PopupMenuItem(
                value: 'expense',
                child: Text('Expense Only'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          Expanded(child: _buildTransactionList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return FutureBuilder<Map<String, double>>(
      future: _getSummary(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final data = snapshot.data!;
        final balance = data['balance'] ?? 0;
        final income = data['income'] ?? 0;
        final expense = data['expense'] ?? 0;

        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Balance',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Income', income, Colors.green),
                    _buildSummaryItem('Expense', expense, Colors.red),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    Stream<List<TransactionModel>> stream;

    if (_selectedFilter == 'income') {
      stream = _firestoreService.getTransactionsByType('income');
    } else if (_selectedFilter == 'expense') {
      stream = _firestoreService.getTransactionsByType('expense');
    } else {
      stream = _firestoreService.getTransactions();
    }

    return StreamBuilder<List<TransactionModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No transactions yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return _buildTransactionCard(transactions[index]);
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    final isIncome = transaction.type == 'income';
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.category),
            Text(
              dateFormat.format(transaction.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (transaction.description != null &&
                transaction.description!.isNotEmpty)
              Text(
                transaction.description!,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onLongPress: () {
          _showDeleteDialog(transaction);
        },
      ),
    );
  }

  void _showDeleteDialog(TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: Text(
          'Are you sure you want to delete "${transaction.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (transaction.id != null) {
                await _firestoreService.deleteTransaction(transaction.id!);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transaction deleted')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<Map<String, double>> _getSummary() async {
    final balance = await _firestoreService.getBalance();
    final income = await _firestoreService.getTotalIncome();
    final expense = await _firestoreService.getTotalExpense();

    return {'balance': balance, 'income': income, 'expense': expense};
  }
}
