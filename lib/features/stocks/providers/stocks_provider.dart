import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../models/article_model.dart';
import '../services/stocks_service.dart';

// Provider du service API
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider du service stocks
final stocksServiceProvider = Provider<StocksService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StocksServiceImpl(apiService);
});

// State notifier pour gérer les articles
class ArticlesStateNotifier extends StateNotifier<AsyncValue<List<ArticleModel>>> {
  final Ref ref;

  ArticlesStateNotifier(this.ref) : super(const AsyncValue.loading());

  /// Récupère les articles financiers
  Future<void> fetchFinancialArticles({String query = 'stocks'}) async {
    state = const AsyncValue.loading();
    try {
      final stocksService = ref.read(stocksServiceProvider);
      final articles = await stocksService.getFinancialArticles(query: query);
      state = AsyncValue.data(articles);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Récupère les articles tendance
  Future<void> fetchTrendingArticles() async {
    state = const AsyncValue.loading();
    try {
      final stocksService = ref.read(stocksServiceProvider);
      final articles = await stocksService.getTrendingArticles();
      state = AsyncValue.data(articles);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Filtre les articles par sentiment
  void filterBySentiment(String sentiment) {
    state.whenData((articles) {
      final filtered = articles.where((a) => a.sentiment == sentiment).toList();
      state = AsyncValue.data(filtered);
    });
  }

  /// Ajoute/retire un article des favoris
  void toggleFavorite(String articleId) {
    state.whenData((articles) {
      final updated = articles.map((a) {
        if (a.id == articleId) {
          return a.copyWith(isFavorite: !a.isFavorite);
        }
        return a;
      }).toList();
      state = AsyncValue.data(updated);
    });
  }
}

// Provider de l'état des articles
final articlesProvider =
    StateNotifierProvider<ArticlesStateNotifier, AsyncValue<List<ArticleModel>>>((ref) {
  return ArticlesStateNotifier(ref);
});

// Selecteurs pratiques
final filteredArticlesProvider = StateNotifierProvider.family<
    FilteredArticlesNotifier,
    AsyncValue<List<ArticleModel>>,
    String>((ref, sentiment) {
  return FilteredArticlesNotifier(ref, sentiment);
});

class FilteredArticlesNotifier extends StateNotifier<AsyncValue<List<ArticleModel>>> {
  final Ref ref;
  final String sentiment;

  FilteredArticlesNotifier(this.ref, this.sentiment) : super(const AsyncValue.loading()) {
    _filterArticles();
  }

  void _filterArticles() {
    ref.watch(articlesProvider).whenData((articles) {
      if (sentiment == 'all') {
        state = AsyncValue.data(articles);
      } else {
        final filtered = articles.where((a) => a.sentiment == sentiment).toList();
        state = AsyncValue.data(filtered);
      }
    });
  }
}

// Selector pour articles favoris
final favoriteArticlesProvider = Provider<AsyncValue<List<ArticleModel>>>((ref) {
  return ref.watch(articlesProvider).whenData((articles) {
    return articles.where((a) => a.isFavorite).toList();
  });
});

// Selector pour statistiques sentiment
final sentimentStatsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  return ref.watch(articlesProvider).whenData((articles) {
    final stats = <String, int>{
      'positive': 0,
      'negative': 0,
      'neutral': 0,
    };
    for (var article in articles) {
      stats[article.sentiment] = (stats[article.sentiment] ?? 0) + 1;
    }
    return stats;
  });
});
