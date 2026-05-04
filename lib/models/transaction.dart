class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isExpense;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.date,
  });
}