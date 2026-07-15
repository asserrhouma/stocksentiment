import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article_model.dart';
import '../providers/stocks_provider.dart';

/// Liste d'articles réutilisable
/// Ref: Atelier 6 - Widgets réutilisables
class ArticleListWidget extends ConsumerWidget {
  final List<ArticleModel> articles;

  const ArticleListWidget({
    required this.articles,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final article = articles[index];
          return ArticleCardWidget(
            article: article,
            onFavorite: () {
              ref.read(articlesProvider.notifier).toggleFavorite(article.id);
            },
          );
        },
        childCount: articles.length,
      ),
    );
  }
}

/// Carte article individuelle
class ArticleCardWidget extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onFavorite;

  const ArticleCardWidget({
    required this.article,
    required this.onFavorite,
    super.key,
  });

  Color _getSentimentColor() {
    switch (article.sentiment) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getSentimentIcon() {
    switch (article.sentiment) {
      case 'positive':
        return Icons.trending_up;
      case 'negative':
        return Icons.trending_down;
      default:
        return Icons.trending_flat;
    }
  }

  String _getSentimentLabel() {
    switch (article.sentiment) {
      case 'positive':
        return 'Bullish';
      case 'negative':
        return 'Bearish';
      default:
        return 'Neutral';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // TODO: Naviguer vers les détails
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: article.imageUrl.isNotEmpty
                  ? Image.network(
                      article.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 60),
                      ),
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 60),
                    ),
            ),

            // Contenu
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),

                  // Description
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 12),

                  // Sentiment badge et source
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getSentimentColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getSentimentColor()),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getSentimentIcon(),
                              size: 16,
                              color: _getSentimentColor(),
                            ),
                            SizedBox(width: 4),
                            Text(
                              _getSentimentLabel(),
                              style: TextStyle(
                                color: _getSentimentColor(),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          article.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: onFavorite,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Source et date
                  Row(
                    children: [
                      Text(
                        article.source,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Spacer(),
                      Text(
                        _formatDate(article.publishedAt),
                        style: Theme.of(context).textTheme.bodySmall,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 1) {
      return 'À l\'instant';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays}j';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
