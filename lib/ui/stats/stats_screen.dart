import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:sallay/core/localization/locales.dart';
import 'package:sallay/core/services/storage_service.dart';
import 'package:sallay/data/models/prayer_log.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final StorageService _storageService = StorageService();
  List<PrayerLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _logs = _storageService.getPrayerLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.stats.getString(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 32),
            Text(
              AppLocale.weeklyProgress.getString(context),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final date = DateTime.now().subtract(
                            Duration(days: 6 - value.toInt()),
                          );
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat.E().format(date)[0],
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _getBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final now = DateTime.now();
    final List<BarChartGroupData> groups = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final count = _logs.where((log) {
        return log.timestamp.year == date.year &&
            log.timestamp.month == date.month &&
            log.timestamp.day == date.day &&
            log.status == 'done';
      }).length;

      groups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 18,
              borderRadius: BorderRadius.circular(6),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 5,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      );
    }
    return groups;
  }

  Widget _buildSummaryCard() {
    final totalPrayers = _logs.where((l) => l.status == 'done').length;
    final streak = _calculateStreak();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surfaceContainer,
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            Icons.history,
            AppLocale.totalPrayers.getString(context),
            "$totalPrayers",
          ),
          Container(
            height: 40,
            width: 1,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          _buildStatItem(
            Icons.local_fire_department,
            AppLocale.currentStreak.getString(context),
            "$streak",
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
                  iconColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateStreak() {
    if (_logs.isEmpty) return 0;

    // Get unique days with at least one prayer
    final daysWithPrayer =
        _logs
            .where((l) => l.status == 'done')
            .map(
              (l) => DateTime(
                l.timestamp.year,
                l.timestamp.month,
                l.timestamp.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a)); // Sort descending (newest first)

    if (daysWithPrayer.isEmpty) return 0;

    int streak = 0;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if the most recent day is today or yesterday to start the streak
    if (daysWithPrayer.first.isBefore(
      todayDate.subtract(const Duration(days: 1)),
    )) {
      return 0;
    }

    // Iterate backwards to count consecutive days
    DateTime currentCheck = daysWithPrayer.first;
    for (int i = 0; i < daysWithPrayer.length; i++) {
      if (i == 0) {
        streak++;
        continue;
      }

      final prevDate = daysWithPrayer[i];
      if (currentCheck
          .subtract(const Duration(days: 1))
          .isAtSameMomentAs(prevDate)) {
        streak++;
        currentCheck = prevDate;
      } else {
        break;
      }
    }

    return streak;
  }
}
