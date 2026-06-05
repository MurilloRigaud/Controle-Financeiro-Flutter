import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodel/transaction_provider.dart';

class ResultsView extends ConsumerWidget {
  const ResultsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final txNotifier = ref.read(transactionProvider.notifier);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final total = txNotifier.totalIncome + txNotifier.totalExpense;

    final byCategory = <String, double>{};
    for (final t in transactions.where((t) => t.isExpense)) {
      byCategory[t.category] = (byCategory[t.category] ?? 0) + t.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise Financeira'),
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resumo Geral',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _indicator('Receitas', txNotifier.totalIncome, total,
                Colors.green, currencyFormat),
            const SizedBox(height: 12),
            _indicator('Despesas', txNotifier.totalExpense, total,
                Colors.red, currencyFormat),
            const SizedBox(height: 24),
            if (byCategory.isNotEmpty) ...[
              const Text('Gastos por Categoria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...byCategory.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _indicator(e.key, e.value, txNotifier.totalExpense,
                        Colors.indigo, currencyFormat),
                  )),
              const SizedBox(height: 24),
            ],
            const Text('Todas as Transações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            transactions.isEmpty
                ? const Center(child: Text('Nenhuma transação registrada.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (ctx, i) {
                      final t = transactions[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            t.isExpense
                                ? Icons.remove_circle
                                : Icons.add_circle,
                            color: t.isExpense ? Colors.red : Colors.green,
                          ),
                          title: Text(t.title),
                          subtitle: Text(
                              '${t.category} • ${DateFormat('dd/MM/yyyy').format(t.date)}'),
                          trailing: Text(
                            '${t.isExpense ? '-' : '+'} ${currencyFormat.format(t.amount)}',
                            style: TextStyle(
                              color: t.isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _indicator(String label, double value, double total, Color color,
      NumberFormat fmt) {
    final ratio = total == 0 ? 0.0 : (value / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(fmt.format(value),
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            color: color,
            backgroundColor: color.withOpacity(0.15),
            minHeight: 10,
          ),
        ),
        Text('${(ratio * 100).toStringAsFixed(1)}% do total',
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}