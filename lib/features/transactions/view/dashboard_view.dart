import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/transaction_model.dart';
import '../viewmodel/transaction_provider.dart';
import '../../auth/viewmodel/auth_provider.dart';
import '../../news/view/news_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'expense';
  String _selectedCategory = 'Alimentação';
  TransactionModel? _editingTransaction;

  final List<String> _categories = [
    'Alimentação', 'Transporte', 'Saúde', 'Educação',
    'Lazer', 'Moradia', 'Salário', 'Outros'
  ];

  final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showTransactionSheet({TransactionModel? transaction}) {
    _editingTransaction = transaction;
    if (transaction != null) {
      _titleController.text = transaction.title;
      _amountController.text = transaction.amount.toStringAsFixed(2).replaceAll('.', ',');
      _selectedType = transaction.type;
      _selectedCategory = transaction.category;
    } else {
      _titleController.clear();
      _amountController.clear();
      _selectedType = 'expense';
      _selectedCategory = 'Alimentação';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24, right: 24, top: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _editingTransaction == null ? 'Nova Transação' : 'Editar Transação',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe a descrição' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Valor (R\$)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o valor';
                    final parsed = double.tryParse(
                        v.replaceAll('.', '').replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) return 'Valor inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'income',
                              label: Text('Receita'),
                              icon: Icon(Icons.arrow_upward)),
                          ButtonSegment(
                              value: 'expense',
                              label: Text('Despesa'),
                              icon: Icon(Icons.arrow_downward)),
                        ],
                        selected: {_selectedType},
                        onSelectionChanged: (v) =>
                            setSheetState(() => _selectedType = v.first),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setSheetState(() => _selectedCategory = v!),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _saveTransaction(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3949AB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _editingTransaction == null ? 'Adicionar' : 'Salvar',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTransaction(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(authProvider).user!.id!;
    final amount = double.parse(
        _amountController.text.replaceAll('.', '').replaceAll(',', '.'));

    if (_editingTransaction != null) {
      await ref.read(transactionProvider.notifier).updateTransaction(
            _editingTransaction!.copyWith(
              title: _titleController.text.trim(),
              amount: amount,
              type: _selectedType,
              category: _selectedCategory,
            ),
          );
    } else {
      await ref.read(transactionProvider.notifier).addTransaction(
            TransactionModel(
              userId: userId,
              title: _titleController.text.trim(),
              amount: amount,
              type: _selectedType,
              category: _selectedCategory,
              date: DateTime.now(),
            ),
          );
    }
    if (ctx.mounted) Navigator.pop(ctx);
  }

  void _confirmDelete(TransactionModel t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir transação'),
        content: Text('Deseja excluir "${t.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              ref.read(transactionProvider.notifier).deleteTransaction(t.firestoreId!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final txNotifier = ref.read(transactionProvider.notifier);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${user?.name.split(' ').first ?? ''}!'),
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, '/results'),
          ),
          IconButton(
            icon: const Icon(Icons.newspaper),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NewsView())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Text('Saldo Total',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(
                  currencyFormat.format(txNotifier.totalBalance),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _summaryCard('Receitas', txNotifier.totalIncome,
                        Colors.greenAccent, Icons.arrow_upward),
                    _summaryCard('Despesas', txNotifier.totalExpense,
                        Colors.redAccent, Icons.arrow_downward),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('Nenhuma transação ainda.',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: transactions.length,
                    itemBuilder: (ctx, i) {
                      final t = transactions[i];
                      return Dismissible(
                        key: Key(t.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (_) async {
                          _confirmDelete(t);
                          return false;
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: t.isExpense
                                ? Colors.red[50]
                                : Colors.green[50],
                            child: Icon(
                              t.isExpense
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color:
                                  t.isExpense ? Colors.red : Colors.green,
                            ),
                          ),
                          title: Text(t.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              '${t.category} • ${DateFormat('dd/MM/yyyy').format(t.date)}'),
                          trailing: Text(
                            currencyFormat.format(t.amount),
                            style: TextStyle(
                              color: t.isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () => _showTransactionSheet(transaction: t),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTransactionSheet(),
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova Transação'),
      ),
    );
  }

  Widget _summaryCard(
      String label, double value, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        Text(currencyFormat.format(value),
            style:
                TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}