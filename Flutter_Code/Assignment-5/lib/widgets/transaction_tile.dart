import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../screens/transaction_detail_screen.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.category),
      subtitle: Text(transaction.note),
      trailing: Text(
        "${transaction.type == "income" ? "+" : "-"} ₹${transaction.amount}",
        style: TextStyle(
          color: transaction.type == "income" ? Colors.green : Colors.red,
        ),
      ),
      onLongPress: () {
        // Navigate to details on long press
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => TransactionDetailScreen(transaction: transaction),
          ),
        );
      },
    );
  }
}
