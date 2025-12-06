import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sallay/core/theme/app_colors.dart';

class WeeklySummaryScreen extends StatelessWidget {
  const WeeklySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Prayer Compliance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 3),
                                FlSpot(1, 4),
                                FlSpot(2, 5),
                                FlSpot(3, 4),
                                FlSpot(4, 5),
                                FlSpot(5, 5),
                                FlSpot(6, 4),
                              ],
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(label: 'Total', value: '30'),
                        _StatItem(label: 'On Time', value: '85%'),
                        _StatItem(label: 'Streak', value: '5 Days'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
