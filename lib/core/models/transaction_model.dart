class TransactionModel {
  final String? firestoreId;
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final String type;
  final String category;
  final DateTime date;

  TransactionModel({
    this.firestoreId,
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  bool get isExpense => type == 'expense';

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'amount': amount,
        'type': type,
        'category': category,
        'date': date.toIso8601String(),
      };

  Map<String, dynamic> toFirestoreMap() => {
        'title': title,
        'amount': amount,
        'type': type,
        'category': category,
        'date': date.toIso8601String(),
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        firestoreId: map['id']?.toString(),
        userId: map['user_id'] ?? 0,
        title: map['title'],
        amount: (map['amount'] as num).toDouble(),
        type: map['type'],
        category: map['category'],
        date: DateTime.parse(map['date']),
      );

  TransactionModel copyWith({
    String? firestoreId,
    int? id,
    int? userId,
    String? title,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
  }) =>
      TransactionModel(
        firestoreId: firestoreId ?? this.firestoreId,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        category: category ?? this.category,
        date: date ?? this.date,
      );
}