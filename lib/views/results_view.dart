import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaction_viewmodel.dart';

class ResultsView extends StatelessWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionViewModel>();
    final total = vm.totalIncome + vm.totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Análise Financeira')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumo Geral',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _indicator('Receitas', vm.totalIncome, total, Colors.green),
            const SizedBox(height: 12),
            _indicator('Despesas', vm.totalExpense, total, Colors.red),
            const SizedBox(height: 24),
            const Text('Todas as Transações',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: vm.transactions.isEmpty
                  ? const Center(child: Text('Nenhuma transação registrada.'))
                  : ListView.builder(
                      itemCount: vm.transactions.length,
                      itemBuilder: (ctx, i) {
                        final t = vm.transactions[i];
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              t.isExpense
                                  ? Icons.remove_circle
                                  : Icons.add_circle,
                              color: t.isExpense ? Colors.red : Colors.green,
                            ),
                            title: Text(t.title),
                            subtitle: Text(
                                '${t.date.day}/${t.date.month}/${t.date.year}'),
                            trailing: Text(
                              '${t.isExpense ? '-' : '+'} R\$ ${t.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color:
                                    t.isExpense ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicator(
      String label, double value, double total, Color color) {
    final ratio = total == 0 ? 0.0 : value / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('R\$ ${value.toStringAsFixed(2)}',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: ratio,
          color: color,
          backgroundColor: color.withOpacity(0.2),
          minHeight: 12,
        ),
        Text('${(ratio * 100).toStringAsFixed(1)}% do total',
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}