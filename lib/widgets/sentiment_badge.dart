import 'package:flutter/material.dart';

/// Reusable sentiment badge widget displayed globally
class SentimentBadge extends StatelessWidget {
  final String sentiment;
  final double score;
  final bool compact;

  const SentimentBadge({
    Key? key,
    required this.sentiment,
    required this.score,
    this.compact = false,
  }) : super(key: key);

  Color _getColor() {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getLabel() {
    switch (sentiment.toLowerCase()) {
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
    final color = _getColor();
    final label = _getLabel();

    if (compact) {
      return Chip(
        label: Text(label),
        backgroundColor: color.withOpacity(0.2),
        labelStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        side: BorderSide(color: color.withOpacity(0.5)),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sentiment.toLowerCase() == 'positive'
                ? Icons.trending_up
                : sentiment.toLowerCase() == 'negative'
                    ? Icons.trending_down
                    : Icons.trending_flat,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
