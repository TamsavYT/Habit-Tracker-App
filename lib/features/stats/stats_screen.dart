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
                  Text('Completion rate', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  FutureBuilder<_CompletionRates>(
                    future: _completionRates(repo, habits),
                    builder: (context, ratesSnapshot) {
                      final rates = ratesSnapshot.data;
                      if (rates == null) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _RateCard(label: 'Last 30 days', rate: rates.overall30),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _RateCard(label: 'Last 90 days', rate: rates.overall90),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...habits.map((h) {
                            final perHabit = rates.perHabit[h.id]!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GlassCard(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(h.name, style: Theme.of(context).textTheme.titleMedium),
                                    ),
                                    Text(
                                      '${(perHabit.$1 * 100).round()}% / 30d',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${(perHabit.$2 * 100).round()}% / 90d',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
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

  /// Completion rate = completed / scheduled days within the window, so
  /// custom-day habits aren't penalized for days they're not due on.
  Future<_CompletionRates> _completionRates(HabitRepository repo, List<Habit> habits) async {
    final today = dateOnly(DateTime.now());
    final perHabit = <int, (double, double)>{};
    var scheduled30 = 0, completed30 = 0, scheduled90 = 0, completed90 = 0;

    for (final habit in habits) {
      final logs = await repo.logsForHabit(habit.id);
      final completedDates = logs.map((l) => dateOnly(l.date)).toSet();

      (int, int) rateCounts(int windowDays) {
        var sched = 0, comp = 0;
        for (var i = 0; i < windowDays; i++) {
          final d = today.subtract(Duration(days: i));
          if (!isScheduledDay(habit, d)) continue;
          sched++;
          if (completedDates.contains(d)) comp++;
        }
        return (sched, comp);
      }

      final (sched30, comp30) = rateCounts(30);
      final (sched90, comp90) = rateCounts(90);
      perHabit[habit.id] = (
        sched30 == 0 ? 0.0 : comp30 / sched30,
        sched90 == 0 ? 0.0 : comp90 / sched90,
      );
      scheduled30 += sched30;
      completed30 += comp30;
      scheduled90 += sched90;
      completed90 += comp90;
    }

    return _CompletionRates(
      overall30: scheduled30 == 0 ? 0.0 : completed30 / scheduled30,
      overall90: scheduled90 == 0 ? 0.0 : completed90 / scheduled90,
      perHabit: perHabit,
    );
  }
}

class _CompletionRates {
  _CompletionRates({required this.overall30, required this.overall90, required this.perHabit});
  final double overall30;
  final double overall90;
  final Map<int, (double, double)> perHabit;
}

class _RateCard extends StatelessWidget {
  const _RateCard({required this.label, required this.rate});
  final String label;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${(rate * 100).round()}%',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
