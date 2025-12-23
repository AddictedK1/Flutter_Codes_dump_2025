import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? id;
  final String title;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String? description;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': Timestamp.fromDate(date),
      'description': description,
    };
  }

  // Create from Firestore document
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] ?? 'expense',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'],
    );
  }

  // Copy with method for updates
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? description,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
