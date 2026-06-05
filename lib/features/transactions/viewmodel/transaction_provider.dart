import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/transaction_model.dart';
import '../../auth/viewmodel/auth_provider.dart';

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  TransactionNotifier(this._ref) : super([]);

  String? get _uid => _ref.read(authProvider).user?.uid;

  Future<void> loadTransactions() async {
    if (_uid == null) return;
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();
    state = snapshot.docs
        .map((doc) => TransactionModel.fromMap({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> addTransaction(TransactionModel t) async {
    if (_uid == null) return;
    final doc = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .add(t.toFirestoreMap());
    state = [t.copyWith(firestoreId: doc.id), ...state];
  }

  Future<void> updateTransaction(TransactionModel t) async {
    if (_uid == null || t.firestoreId == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .doc(t.firestoreId)
        .update(t.toFirestoreMap());
    state = state.map((e) => e.firestoreId == t.firestoreId ? t : e).toList();
  }

  Future<void> deleteTransaction(String firestoreId) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .doc(firestoreId)
        .delete();
    state = state.where((e) => e.firestoreId != firestoreId).toList();
  }

  double get totalBalance => state.fold(
      0, (sum, t) => t.isExpense ? sum - t.amount : sum + t.amount);

  double get totalIncome =>
      state.where((t) => !t.isExpense).fold(0, (sum, t) => sum + t.amount);

  double get totalExpense =>
      state.where((t) => t.isExpense).fold(0, (sum, t) => sum + t.amount);
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  return TransactionNotifier(ref);
});