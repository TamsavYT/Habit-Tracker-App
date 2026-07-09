import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../core/utils/date_utils.dart';
import '../../data/models/habit.dart';
import '../../data/providers.dart';
import '../../data/repositories/habit_repository.dart';
import '../../shared/widgets/glass_card.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final repo = ref.watch(habitRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (habits) {
          if (habits.isEmpty) {
            return const Center(child: Text('No habits yet'));
          }

          final today = dateOnly(DateTime.now());
          final last7 = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));

          return FutureBuilder<Map<DateTime, int>>(
            future: _weeklyCompletion(repo, habits, last7),
            builder: (context, snapshot) {
              final data = snapshot.data ?? {for (final d in last7) d: 0};
              final maxY = habits.length.toDouble().clamp(1.0, double.infinity);

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text('Last 7 days', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          maxY: maxY,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= last7.length) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      DateFormat('E').format(last7[idx]),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(last7.length, (i) {
                            final count = data[last7[i]] ?? 0;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: count.toDouble(),
                                  width: 18,
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Best streaks', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  ...(() {
                    final sorted = [...habits]..sort((a, b) => b.bestStreak.compareTo(a.bestStreak));
                    return sorted.map((h) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          child: Row(
                            children: [
                              Expanded(child: Text(h.name, style: Theme.of(context).textTheme.titleMedium)),
                              Text('${h.bestStreak} days', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      );
                    });
                  })(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<DateTime, int>> _weeklyCompletion(
      HabitRepository repo, List<Habit> habits, List<DateTime> days) async {
    final result = {for (final d in days) d: 0};
    for (final habit in habits) {
      final logs = await repo.logsForHabit(habit.id);
      for (final log in logs) {
        final d = dateOnly(log.date);
        if (result.containsKey(d)) {
          result[d] = result[d]! + 1;
        }
      }
    }
    return result;
  }
}
