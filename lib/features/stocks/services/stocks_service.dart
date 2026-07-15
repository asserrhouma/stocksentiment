import '../../../core/api/api_service.dart';
import '../models/article_model.dart';

/// Service pour récupérer les données financières
abstract class StocksService {
  /// Récupère les articles financiers
  Future<List<ArticleModel>> getFinancialArticles({
    required String query,
    int pageSize = 20,
  });

  /// Récupère les articles en tendance
  Future<List<ArticleModel>> getTrendingArticles();

  /// Récupère les détails d'un article
  Future<ArticleModel> getArticleDetails(String articleId);
}

/// Implémentation du service avec appel API réel
class StocksServiceImpl implements StocksService {
  final ApiService _apiService;
  bool _isLoading = false;

  StocksServiceImpl(this._apiService);

  static const String _newsApiKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: '',
  );
  static const String _newsApiUrl = 'https://newsapi.org/v2/everything';

  @override
  Future<List<ArticleModel>> getFinancialArticles({
    required String query,
    int pageSize = 20,
  }) async {
    try {
      _isLoading = true;

      // Utilisation de l'ApiService injecté
      final data = await _apiService.get(
        _newsApiUrl,
        queryParameters: {
          'q': query,
          'sortBy': 'publishedAt',
          'language': 'fr',
          'pageSize': pageSize,
          'apiKey': _newsApiKey,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final articles = _parseArticles(data);
      _isLoading = false;
      return articles;
    } catch (e) {
      print('Erreur récupération articles: $e');
      _isLoading = false;
      rethrow;
    }
  }

  @override
  Future<List<ArticleModel>> getTrendingArticles() async {
    try {
      _isLoading = true;

      final data = await _apiService.get(
        _newsApiUrl,
        queryParameters: {
          'q': 'stock market trending',
          'sortBy': 'popularity',
          'language': 'fr',
          'pageSize': 10,
          'apiKey': _newsApiKey,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final articles = _parseArticles(data);
      _isLoading = false;
      return articles;
    } catch (e) {
      print('Erreur récupération tendances: $e');
      _isLoading = false;
      rethrow;
    }
  }

  @override
  Future<ArticleModel> getArticleDetails(String articleId) async {
    try {
      final articles = await getFinancialArticles(query: 'stocks', pageSize: 1);
      return articles.isNotEmpty ? articles.first : _createMockArticle();
    } catch (e) {
      print('Erreur récupération détails: $e');
      rethrow;
    }
  }

  /// Parse la réponse JSON de NewsAPI
  List<ArticleModel> _parseArticles(Map<String, dynamic> data) {
    final List<dynamic> articles = data['articles'] ?? [];

    return articles
        .map((json) {
          try {
            return ArticleModel(
              id: json['url'] ?? 'article_${DateTime.now().millisecondsSinceEpoch}',
              title: json['title'] ?? 'Sans titre',
              description: json['description'] ?? json['content'] ?? '',
              url: json['url'] ?? '',
              imageUrl: json['urlToImage'] ?? '',
              source: json['source']?['name'] ?? 'Source inconnue',
              publishedAt: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
              sentiment: _analyzeSentiment(json['title'] ?? ''),
              sentimentScore: _calculateSentimentScore(json['title'] ?? ''),
              isFavorite: false,
            );
          } catch (e) {
            print('Erreur parsing article: $e');
            return null;
          }
        })
        .whereType<ArticleModel>()
        .toList();
  }

  /// Analyse simple du sentiment basée sur les mots-clés
  String _analyzeSentiment(String text) {
    final textLower = text.toLowerCase();
    final positiveWords = ['hausse', 'gain', 'profit', 'montée', 'rebond', 'optimisme', 'succès', 'croissance', 'bonne', 'forte'];
    final negativeWords = ['baisse', 'perte', 'déclin', 'effondrement', 'chute', 'pessimisme', 'faible', 'problème', 'crise', 'risque'];

    int positiveCount = positiveWords.where((word) => textLower.contains(word)).length;
    int negativeCount = negativeWords.where((word) => textLower.contains(word)).length;

    if (positiveCount > negativeCount) return 'positive';
    if (negativeCount > positiveCount) return 'negative';
    return 'neutral';
  }

  double _calculateSentimentScore(String text) {
    final sentiment = _analyzeSentiment(text);
    if (sentiment == 'positive') return 0.7;
    if (sentiment == 'negative') return -0.7;
    return 0.0;
  }

  ArticleModel _createMockArticle() {
    return ArticleModel(
      id: '1',
      title: 'Article de démonstration',
      description: 'Ceci est un article de démonstration.',
      url: 'https://example.com',
      imageUrl: 'https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=800',
      source: 'Demo Source',
      publishedAt: DateTime.now(),
      sentiment: 'neutral',
      sentimentScore: 0.0,
      isFavorite: false,
    );
  }
}
