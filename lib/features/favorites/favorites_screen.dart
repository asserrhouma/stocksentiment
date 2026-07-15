import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../stocks/models/article_model.dart';
import '../stocks/widgets/article_list_widget.dart';

/// Écran des articles favoris avec persistance SharedPreferences
/// Ref: Atelier 8 - Persistance de données avec SharedPreferences
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  List<ArticleModel> _favoriteArticles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  /// Charge les articles favoris depuis SharedPreferences
  /// Ref: Atelier 8 - Récupération de données avec SharedPreferences
  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Récupère la liste JSON des favoris
      final favoritesJson = prefs.getString('favorite_articles') ?? '[]';
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      
      setState(() {
        _favoriteArticles = decoded
            .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement favoris: $e');
      setState(() => _isLoading = false);
    }
  }

  /// Sauvegarde les articles favoris dans SharedPreferences
  /// Ref: Atelier 8 - Sauvegarde de données avec SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convertit la liste en JSON et sauvegarde
      final favoritesJson = jsonEncode(
        _favoriteArticles.map((article) => article.toJson()).toList(),
      );
      
      await prefs.setString('favorite_articles', favoritesJson);
    } catch (e) {
      print('Erreur sauvegarde favoris: $e');
    }
  }

  /// Supprime un article des favoris
  Future<void> _removeFavorite(String articleId) async {
    setState(() {
      _favoriteArticles.removeWhere((article) => article.id == articleId);
    });
    
    await _saveFavorites();
    
    // Affiche un SnackBar de confirmation
    // Ref: Atelier 6 - Affichage de messages avec SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Article supprimé des favoris'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  /// Vide tous les favoris
  Future<void> _clearAllFavorites() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Vider les favoris ?'),
        content: Text('Cette action ne peut pas être annulée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _favoriteArticles.clear());
              _saveFavorites();
              Navigator.pop(ctx);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tous les favoris ont été supprimés'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Vider', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text('Mes favoris ⭐'),
          ],
        ),
        elevation: 0,
        actions: [
          if (_favoriteArticles.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: _clearAllFavorites,
              tooltip: 'Vider les favoris',
            ),
        ],
      ),
      body: _favoriteArticles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun favori pour le moment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez des articles à vos favoris',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = _favoriteArticles[index];
                return ArticleCardWidget(
                  article: article,
                  onFavoriteTap: () => _removeFavorite(article.id),
                  isFavorite: true,
                );
              },
            ),
    );
  }
}

/// Widget pour afficher une carte d'article avec option de suppression
class ArticleCardWidget extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const ArticleCardWidget({super.key, 
    required this.article,
    required this.onFavoriteTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: InkWell(
        onTap: () {
          // Ouvrir l'article en détail si souhaité
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.image),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  // Description
                  Text(
                    article.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 12),
                  // Footer avec sentiment et bouton favori
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Source et date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.source,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              _getRelativeDate(article.publishedAt),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Sentiment badge
                      _getSentimentBadge(article.sentiment),
                      SizedBox(width: 8),
                      // Bouton favori
                      IconButton(
                        onPressed: onFavoriteTap,
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_outline,
                          color: isFavorite ? Colors.amber : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'À l\'instant';
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays}j';
    } else {
      return date.toString().split(' ')[0];
    }
  }

  Widget _getSentimentBadge(String sentiment) {
    Color bgColor;
    Color textColor;
    String icon;

    switch (sentiment.toLowerCase()) {
      case 'positive':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = '↑';
        break;
      case 'negative':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = '↓';
        break;
      default:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = '→';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$icon ${sentiment.capitalize()}',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
