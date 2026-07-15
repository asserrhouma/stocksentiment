/// Modèle d'article avec sentiment
/// Ref: Atelier 8 - Sérialisation de données
class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;
  final String sentiment; // "positive", "negative", "neutral"
  final double sentimentScore; // -1.0 à 1.0
  final bool isFavorite;

  ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    this.sentiment = 'neutral',
    this.sentimentScore = 0.0,
    this.isFavorite = false,
  });

  /// Crée une instance à partir d'une Map
  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] ?? map['url'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['imageUrl'] ?? map['urlToImage'] ?? '',
      source: map['source'] is String
          ? map['source']
          : map['source']?['name'] ?? 'Unknown',
      publishedAt: map['publishedAt'] != null
          ? DateTime.parse(map['publishedAt'])
          : DateTime.now(),
      sentiment: map['sentiment'] ?? 'neutral',
      sentimentScore: (map['sentimentScore'] ?? 0.0).toDouble(),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  /// Crée une instance à partir de JSON
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel.fromMap(json);
  }

  /// Convertit l'instance en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'sentiment': sentiment,
      'sentimentScore': sentimentScore,
      'isFavorite': isFavorite,
    };
  }

  /// Convertit l'instance en JSON
  Map<String, dynamic> toJson() {
    return toMap();
  }

  /// Copie avec modifications
  ArticleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    String? source,
    DateTime? publishedAt,
    String? sentiment,
    double? sentimentScore,
    bool? isFavorite,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      sentiment: sentiment ?? this.sentiment,
      sentimentScore: sentimentScore ?? this.sentimentScore,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() =>
      'ArticleModel(id: $id, title: $title, sentiment: $sentiment, score: $sentimentScore)';
}
