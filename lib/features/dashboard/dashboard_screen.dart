import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../stocks/providers/stocks_provider.dart';

/// Dashboard screen displaying market sentiment analysis with charts
/// Ref: Project criteria - Data visualization with fl_chart
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load articles on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(articlesProvider.notifier).fetchFinancialArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final articlesAsync = ref.watch(articlesProvider);
    final statsAsync = ref.watch(sentimentStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Market Sentiment'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
      ),
      body: articlesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
        data: (articles) => statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
          ),
          data: (stats) => _buildDashboard(articles, stats),
        ),
      ),
    );
  }

  Widget _buildDashboard(List<dynamic> articles, Map<String, dynamic> stats) {
    final totalArticles = articles.length;
    final bullishCount = stats['bullish'] as int? ?? 0;
    final bearishCount = stats['bearish'] as int? ?? 0;
    final neutralCount = stats['neutral'] as int? ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Stats
          _buildStatsCards(bullishCount, bearishCount, neutralCount, totalArticles),
          const SizedBox(height: 32),

          // Sentiment Distribution Pie Chart
          const Text(
            'Sentiment Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: _buildPieChart(bullishCount, bearishCount, neutralCount),
          ),
          const SizedBox(height: 32),

          // Bar Chart - Sentiment Counts
          const Text(
            'Sentiment Count Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: _buildBarChart(bullishCount, bearishCount, neutralCount),
          ),
          const SizedBox(height: 32),

          // Summary Section
          _buildSummary(totalArticles, bullishCount, bearishCount, neutralCount),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int bullish, int bearish, int neutral, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('Bullish', bullish, Colors.green, Icons.trending_up),
        _buildStatCard('Bearish', bearish, Colors.red, Icons.trending_down),
        _buildStatCard('Neutral', neutral, Colors.orange, Icons.trending_flat),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 100,
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(int bullish, int bearish, int neutral) {
    final total = bullish + bearish + neutral;
    if (total == 0) {
      return const Center(child: Text('No data available'));
    }

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: bullish.toDouble(),
            title: 'Bullish\n$bullish',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: bearish.toDouble(),
            title: 'Bearish\n$bearish',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: neutral.toDouble(),
            title: 'Neutral\n$neutral',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildBarChart(int bullish, int bearish, int neutral) {
    final maxValue = [bullish, bearish, neutral].reduce((a, b) => a > b ? a : b).toDouble();

    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: bullish.toDouble(),
                color: Colors.green,
                width: 40,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: bearish.toDouble(),
                color: Colors.red,
                width: 40,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: neutral.toDouble(),
                color: Colors.orange,
                width: 40,
              ),
            ],
          ),
        ],
        maxY: maxValue > 0 ? maxValue : 10,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const titles = ['Bullish', 'Bearish', 'Neutral'];
                return Text(titles[value.toInt()]);
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(int total, int bullish, int bearish, int neutral) {
    String sentiment = 'Neutral';
    Color color = Colors.orange;

    if (bullish > bearish && bullish > neutral) {
      sentiment = 'Bullish';
      color = Colors.green;
    } else if (bearish > bullish && bearish > neutral) {
      sentiment = 'Bearish';
      color = Colors.red;
    }

    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Market Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Articles: $total'),
                Text(
                  'Overall Sentiment: $sentiment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Bullish: $bullish | Bearish: $bearish | Neutral: $neutral',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
