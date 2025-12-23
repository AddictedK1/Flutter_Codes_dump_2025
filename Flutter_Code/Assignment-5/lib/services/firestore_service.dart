import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _transactionCollection =
      FirebaseFirestore.instance.collection("transactions");

  /// Add Transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionCollection.doc(transaction.id).set(transaction.toMap());
  }

  /// Get All Transactions (Stream)
  Stream<List<TransactionModel>> getTransactions() {
    return _transactionCollection
        .orderBy("date", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromMap(doc.data(), id: doc.id))
              .toList(),
        );
  }

  /// Delete Transaction
  Future<void> deleteTransaction(String id) async {
    await _transactionCollection.doc(id).delete();
  }
}
