import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Manager")),
      body: StreamBuilder(
        stream: firestoreService.getTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionTile(transaction: transactions[index]);
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/add"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
