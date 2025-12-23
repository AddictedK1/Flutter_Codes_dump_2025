class Expense {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  // Convert expense to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  // Create expense from JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }

  // Create a copy with updated fields
  Expense copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}

// Available expense categories
class ExpenseCategory {
  static const String food = 'Food';
  static const String transport = 'Transport';
  static const String shopping = 'Shopping';

  static List<String> get categories => [food, transport, shopping];
}
