import 'package:flutter/material.dart';

/// Global sentiment indicator widget - visual sentiment representation
class SentimentIndicator extends StatelessWidget {
  final double score;
  final double size;
  final bool showLabel;

  const SentimentIndicator({
    Key? key,
    required this.score,
    this.size = 40,
    this.showLabel = true,
  }) : super(key: key);

  Color _getColor() {
    if (score > 0.3) return Colors.green;
    if (score < -0.3) return Colors.red;
    return Colors.orange;
  }

  IconData _getIcon() {
    if (score > 0.3) return Icons.trending_up;
    if (score < -0.3) return Icons.trending_down;
    return Icons.trending_flat;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getColor().withOpacity(0.2),
            border: Border.all(
              color: _getColor(),
              width: 2,
            ),
          ),
          child: Icon(
            _getIcon(),
            color: _getColor(),
            size: size * 0.6,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Text(
            '${(score * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getColor(),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
