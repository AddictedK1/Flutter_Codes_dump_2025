import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'transactions';

  // Get transactions stream
  Stream<List<TransactionModel>> getTransactions() {
    return _firestore
        .collection(_collectionName)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get transactions by type (income/expense)
  Stream<List<TransactionModel>> getTransactionsByType(String type) {
    return _firestore
        .collection(_collectionName)
        .where('type', isEqualTo: type)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Add transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestore.collection(_collectionName).add(transaction.toMap());
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id != null) {
      await _firestore
          .collection(_collectionName)
          .doc(transaction.id)
          .update(transaction.toMap());
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }

  // Get total income
  Future<double> getTotalIncome() async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .where('type', isEqualTo: 'income')
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }
    return total;
  }

  // Get total expense
  Future<double> getTotalExpense() async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .where('type', isEqualTo: 'expense')
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }
    return total;
  }

  // Get balance (income - expense)
  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }
}
