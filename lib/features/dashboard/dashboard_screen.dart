import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';

import '../../core/router/app_router.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/habit.dart';
import '../../data/providers.dart';
import '../../shared/widgets/completion_ring.dart';
import 'widgets/habit_tile.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push(AppRoutes.stats),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.habitForm),
        child: const Icon(Icons.add),
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (habits) {
          if (habits.isEmpty) {
            return _EmptyState();
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              _TodayHeader(habits: habits, today: today),
              const SizedBox(height: 24),
              Text('Today', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ...habits.map((habit) {
                return _HabitTileConnected(habit: habit, today: today);
              }),
            ],
          );
        },
      ),
    );
  }
}

class _TodayHeader extends ConsumerWidget {
  const _TodayHeader({required this.habits, required this.today});
  final List<Habit> habits;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = habits.where((h) {
      final logsAsync = ref.watch(habitLogsProvider(h.id));
      return logsAsync.maybeWhen(
        data: (logs) => logs.any((l) => isSameDay(l.date, today)),
        orElse: () => false,
      );
    }).length;
    final total = habits.length;
    final progress = total == 0 ? 0.0 : done / total;

    return Row(
      children: [
        CompletionRing(progress: progress),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(today),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '$done of $total habits done',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HabitTileConnected extends ConsumerWidget {
  const _HabitTileConnected({required this.habit, required this.today});
  final Habit habit;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(habitLogsProvider(habit.id));
    final repo = ref.watch(habitRepositoryProvider);

    final completedToday = logsAsync.maybeWhen(
      data: (logs) => logs.any((l) => isSameDay(l.date, today)),
      orElse: () => false,
    );

    return HabitTile(
      habit: habit,
      completedToday: completedToday,
      onToggle: () => repo.toggleCompletion(habit.id, today),
      onTap: () => context.push(AppRoutes.habitDetail, extra: habit.id),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 20),
            Text('No habits yet', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first habit.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
