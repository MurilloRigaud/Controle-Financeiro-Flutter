import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLogin = true;
  String name = '';
  String email = '';
  String password = '';
  String errorMessage = '';

  final List<User> _registeredUsers = [];

  void toggleMode() {
    isLogin = !isLogin;
    errorMessage = '';
    notifyListeners();
  }

  bool authenticate(BuildContext context) {
    if (isLogin) {
      final user = _registeredUsers.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => User(name: '', email: '', password: ''),
      );
      if (user.email.isEmpty) {
        errorMessage = 'Email ou senha inválidos.';
        notifyListeners();
        return false;
      }
      return true;
    } else {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        errorMessage = 'Preencha todos os campos.';
        notifyListeners();
        return false;
      }
      _registeredUsers.add(User(name: name, email: email, password: password));
      isLogin = true;
      errorMessage = '';
      notifyListeners();
      return true;
    }
  }
}