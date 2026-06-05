import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  // ── USERS ──────────────────────────────────────────────
  Future<int> insertUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);
    final existing = users.any((u) => u['email'] == user['email']);
    if (existing) throw Exception('Email já cadastrado');
    final id = DateTime.now().millisecondsSinceEpoch;
    user['id'] = id;
    users.add(user);
    await prefs.setString('users', jsonEncode(users));
    return id;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);
    try {
      return users.firstWhere((u) => u['email'] == email);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers(prefs);
    try {
      return users.firstWhere(
          (u) => u['email'] == email && u['password'] == password);
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _getUsers(SharedPreferences prefs) async {
    final raw = prefs.getString('users');
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  // ── TRANSACTIONS ───────────────────────────────────────
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await _getTransactions(prefs);
    final id = DateTime.now().millisecondsSinceEpoch;
    transaction['id'] = id;
    transactions.add(transaction);
    await prefs.setString('transactions', jsonEncode(transactions));
    return id;
  }

  Future<List<Map<String, dynamic>>> getTransactionsByUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await _getTransactions(prefs);
    final filtered = transactions
        .where((t) => t['user_id'] == userId)
        .toList()
      ..sort((a, b) => b['date'].compareTo(a['date']));
    return filtered;
  }

  Future<int> updateTransaction(Map<String, dynamic> transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await _getTransactions(prefs);
    final index = transactions.indexWhere((t) => t['id'] == transaction['id']);
    if (index != -1) {
      transactions[index] = transaction;
      await prefs.setString('transactions', jsonEncode(transactions));
      return 1;
    }
    return 0;
  }

  Future<int> deleteTransaction(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await _getTransactions(prefs);
    transactions.removeWhere((t) => t['id'] == id);
    await prefs.setString('transactions', jsonEncode(transactions));
    return 1;
  }

  Future<List<Map<String, dynamic>>> _getTransactions(
      SharedPreferences prefs) async {
    final raw = prefs.getString('transactions');
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }
}