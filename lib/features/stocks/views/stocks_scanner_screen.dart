import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../stocks/models/article_model.dart';
import '../../stocks/providers/stocks_provider.dart';
import '../../stocks/widgets/article_list_widget.dart';
import '../../favorites/favorites_screen.dart';

/// Écran scanner de stocks avec analyse sentiment
/// Ref: Atelier 10 - Appels API & État asynchrone
class StocksScannerScreen extends ConsumerStatefulWidget {
  const StocksScannerScreen({super.key});

  @override
  ConsumerState<StocksScannerScreen> createState() => _StocksScannerScreenState();
}

class _StocksScannerScreenState extends ConsumerState<StocksScannerScreen> {
  String _selectedSentiment = 'all';

  @override
  void initState() {
    super.initState();
    // Charger les articles au démarrage
    Future.microtask(() {
      ref.read(articlesProvider.notifier).fetchFinancialArticles();
    });
  }

  /// Sauvegarde les articles favoris dans SharedPreferences
  /// Ref: Atelier 8 - Persistance avec SharedPreferences
  Future<void> _saveFavorites(List<ArticleModel> articles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = articles.where((a) => a.isFavorite).toList();
      
      final favoritesJson = jsonEncode(
        favorites.map((article) => article.toJson()).toList(),
      );
      
      await prefs.setString('favorite_articles', favoritesJson);
    } catch (e) {
      print('Erreur sauvegarde favoris: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final articlesState = ref.watch(articlesProvider);
    final filteredArticles = ref.watch(filteredArticlesProvider(_selectedSentiment));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.candlestick_chart, color: Colors.amber),
            SizedBox(width: 8),
            Text('StockSentiment'),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.star, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            tooltip: 'Mes favoris',
          ),
        ],
      ),
      body: articlesState.when(
        data: (articles) {
          return CustomScrollView(
            slivers: [
              // Filtre par sentiment
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildSentimentFilter('all', 'Tous', Colors.blue),
                        SizedBox(width: 8),
                        _buildSentimentFilter('positive', 'Bullish', Colors.green),
                        const SizedBox(width: 8),
                        _buildSentimentFilter('negative', 'Bearish', Colors.red),
                        const SizedBox(width: 8),
                        _buildSentimentFilter('neutral', 'Neutral', Colors.orange),
                      ],
                    ),
                  ),
                ),
              ),

              // Liste des articles
              filteredArticles.when(
                data: (filtered) {
                  if (filtered.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text('Aucun article trouvé'),
                      ),
                    );
                  }
                  
                  // Sauvegarde les favoris après chaque mise à jour
                  _saveFavorites(articles);
                  
                  return ArticleListWidget(articles: filtered);
                },
                loading: () => SliverFillRemaining(
                  child: LoadingWidget(message: 'Filtrage...'),
                ),
                error: (error, st) => SliverFillRemaining(
                  child: ErrorDisplayWidget(
                    message: error.toString(),
                    onRetry: () {
                      ref.refresh(articlesProvider);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => LoadingWidget(message: 'Chargement des articles...'),
        error: (error, st) => ErrorDisplayWidget(
          message: error.toString(),
          onRetry: () {
            ref.refresh(articlesProvider);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.refresh(articlesProvider);
        },
        tooltip: 'Actualiser',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildSentimentFilter(String value, String label, Color color) {
    final isSelected = _selectedSentiment == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedSentiment = value);
      },
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
