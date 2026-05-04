import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaction_viewmodel.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  void _showAddDialog(BuildContext context, TransactionViewModel vm) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isExpense = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Nova Transação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  const Text('Despesa?'),
                  Switch(
                    value: isExpense,
                    onChanged: (v) => setState(() => isExpense = v),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (titleController.text.isNotEmpty && amount > 0) {
                  vm.addTransaction(titleController.text, amount, isExpense);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, '/results'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.indigo,
            width: double.infinity,
            child: Column(
              children: [
                const Text('Saldo Total',
                    style: TextStyle(color: Colors.white70)),
                Text(
                  'R\$ ${vm.totalBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _summaryCard(
                        'Receitas', vm.totalIncome, Colors.greenAccent),
                    _summaryCard(
                        'Despesas', vm.totalExpense, Colors.redAccent),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: vm.transactions.isEmpty
                ? const Center(child: Text('Nenhuma transação ainda.'))
                : ListView.builder(
                    itemCount: vm.transactions.length,
                    itemBuilder: (ctx, i) {
                      final t = vm.transactions[i];
                      return ListTile(
                        leading: Icon(
                          t.isExpense
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t.isExpense ? Colors.red : Colors.green,
                        ),
                        title: Text(t.title),
                        subtitle: Text(
                            '${t.date.day}/${t.date.month}/${t.date.year}'),
                        trailing: Text(
                          'R\$ ${t.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: t.isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, vm),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summaryCard(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text('R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}