/// Shared sentiment analysis model used across features
class SentimentModel {
  final String sentiment;
  final double score;
  final String label;

  SentimentModel({
    required this.sentiment,
    required this.score,
    required this.label,
  });

  factory SentimentModel.fromScore(double score) {
    if (score > 0.3) {
      return SentimentModel(
        sentiment: 'positive',
        score: score,
        label: 'Bullish',
      );
    } else if (score < -0.3) {
      return SentimentModel(
        sentiment: 'negative',
        score: score,
        label: 'Bearish',
      );
    } else {
      return SentimentModel(
        sentiment: 'neutral',
        score: score,
        label: 'Neutral',
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'sentiment': sentiment,
    'score': score,
    'label': label,
  };

  factory SentimentModel.fromJson(Map<String, dynamic> json) {
    return SentimentModel(
      sentiment: json['sentiment'] as String,
      score: (json['score'] as num).toDouble(),
      label: json['label'] as String,
    );
  }
}
