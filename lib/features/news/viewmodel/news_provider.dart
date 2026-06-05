import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        title: json['title'] ?? '',
        description: json['description'] ?? 'Sem descrição disponível.',
        url: json['url'] ?? '',
        source: json['source']?['name'] ?? 'Desconhecido',
      );
}

class NewsNotifier extends StateNotifier<AsyncValue<List<NewsArticle>>> {
  NewsNotifier() : super(const AsyncValue.loading()) {
    fetchNews();
  }

  Future<void> fetchNews() async {
    state = const AsyncValue.loading();
    try {
      final response = await http.get(Uri.parse(
          'https://gnews.io/api/v4/search?q=financas&lang=pt&country=br&max=5&apikey=demo'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = (data['articles'] as List)
            .map((a) => NewsArticle.fromJson(a))
            .toList();
        state = AsyncValue.data(articles);
      } else {
        state = AsyncValue.data(_fallbackNews());
      }
    } catch (_) {
      state = AsyncValue.data(_fallbackNews());
    }
  }

  List<NewsArticle> _fallbackNews() => [
        NewsArticle(
          title: 'Como organizar suas finanças pessoais',
          description: 'Dicas práticas para controlar gastos e aumentar a poupança mensal.',
          url: '',
          source: 'Dicas Financeiras',
        ),
        NewsArticle(
          title: 'Investimentos para iniciantes',
          description: 'Tesouro Direto, CDB e Fundos: entenda as diferenças e como começar.',
          url: '',
          source: 'Guia de Investimentos',
        ),
        NewsArticle(
          title: 'Reserva de emergência: quanto guardar?',
          description: 'Especialistas recomendam de 3 a 6 meses de despesas guardadas.',
          url: '',
          source: 'Educação Financeira',
        ),
        NewsArticle(
          title: 'Cartão de crédito: vilão ou aliado?',
          description: 'Saiba como usar o cartão de forma inteligente e evitar dívidas.',
          url: '',
          source: 'Finanças Pessoais',
        ),
        NewsArticle(
          title: 'Planejamento financeiro para 2025',
          description: 'Como definir metas financeiras realistas e alcançá-las ao longo do ano.',
          url: '',
          source: 'Planejamento',
        ),
      ];
}

final newsProvider =
    StateNotifierProvider<NewsNotifier, AsyncValue<List<NewsArticle>>>((ref) {
  return NewsNotifier();
});