import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.isLogin ? 'Login' : 'Cadastro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!vm.isLogin)
              TextField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (v) => vm.name = v,
              ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (v) => vm.email = v,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Senha'),
              onChanged: (v) => vm.password = v,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (vm.errorMessage.isNotEmpty)
              Text(vm.errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (vm.authenticate(context)) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(vm.isLogin ? 'Entrar' : 'Cadastrar'),
            ),
            TextButton(
              onPressed: vm.toggleMode,
              child: Text(vm.isLogin
                  ? 'Não tem conta? Cadastre-se'
                  : 'Já tem conta? Faça login'),
            ),
          ],
        ),
      ),
    );
  }
}