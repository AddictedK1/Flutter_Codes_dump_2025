import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  double amount;
  String category;
  String type; // income / expense
  DateTime date;
  String note;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'type': type,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TransactionModel(
      id: id ?? (map['id'] as String? ?? ''),
      amount: (map['amount'] is num)
          ? (map['amount'] as num).toDouble()
          : double.parse(map['amount'].toString()),
      category: map['category'] as String? ?? '',
      type: map['type'] as String? ?? 'expense',
      date: (map['date'] is Timestamp)
          ? (map['date'] as Timestamp).toDate()
          : DateTime.parse(map['date'].toString()),
      note: map['note'] as String? ?? '',
    );
  }
}
