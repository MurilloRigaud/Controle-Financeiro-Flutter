import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthNotifier() : super(AuthState());

Future<bool> login(String email, String password) async {
  state = state.copyWith(isLoading: true, error: null);
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    
    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    String name = credential.user!.displayName ?? email.split('@').first;
    if (doc.exists && doc.data() != null && doc.data()!.containsKey('name')) {
      name = doc['name'];
    }

    final user = UserModel(
      id: 0,
      name: name,
      email: email,
      password: '',
      uid: credential.user!.uid,
    );
    state = state.copyWith(isLoading: false, user: user);
    return true;
  } on FirebaseAuthException catch (e) {
    String msg = 'Erro ao fazer login.';
    if (e.code == 'user-not-found') msg = 'Usuário não encontrado.';
    if (e.code == 'wrong-password') msg = 'Senha incorreta.';
    if (e.code == 'invalid-credential') msg = 'Email ou senha inválidos.';
    state = state.copyWith(isLoading: false, error: msg);
    return false;
  } catch (e) {
    state = state.copyWith(isLoading: false, error: 'Erro inesperado.');
    return false;
  }
}

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });
      final user = UserModel(
        id: 0,
        name: name,
        email: email,
        password: '',
        uid: credential.user!.uid,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao cadastrar.';
      if (e.code == 'email-already-in-use') msg = 'Email já cadastrado.';
      if (e.code == 'weak-password') msg = 'Senha muito fraca.';
      state = state.copyWith(isLoading: false, error: msg);
      return false;
    }
  }

  void logout() async {
    await _auth.signOut();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});