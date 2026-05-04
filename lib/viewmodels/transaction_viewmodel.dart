import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionViewModel extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  double get totalBalance => _transactions.fold(
      0, (sum, t) => t.isExpense ? sum - t.amount : sum + t.amount);

  double get totalIncome => _transactions
      .where((t) => !t.isExpense)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.isExpense)
      .fold(0, (sum, t) => sum + t.amount);

  void addTransaction(String title, double amount, bool isExpense) {
    _transactions.insert(
      0,
      Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        isExpense: isExpense,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}