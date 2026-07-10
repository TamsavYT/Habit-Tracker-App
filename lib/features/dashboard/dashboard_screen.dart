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

          final categories = habits.map((h) => h.category).toSet().toList()..sort();
          final selectedCategory = ref.watch(selectedCategoryProvider);
          final filtered = selectedCategory == null
              ? habits
              : habits.where((h) => h.category == selectedCategory).toList();

          final grouped = <String, List<Habit>>{};
          for (final habit in filtered) {
            grouped.putIfAbsent(habit.category, () => []).add(habit);
          }
          final groupNames = grouped.keys.toList()..sort();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            children: [
              _TodayHeader(habits: filtered, today: today),
              const SizedBox(height: 20),
              if (categories.length > 1) ...[
                _CategoryFilterRow(categories: categories, selected: selectedCategory),
                const SizedBox(height: 16),
              ],
              Text('Today', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              for (final name in groupNames) ...[
                if (groupNames.length > 1) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 4),
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
                _CategoryHabitList(habits: grouped[name]!, today: today),
                const SizedBox(height: 8),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilterRow extends ConsumerWidget {
  const _CategoryFilterRow({required this.categories, required this.selected});
  final List<String> categories;
  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _CategoryChip(
            label: 'All',
            selected: selected == null,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state = null,
          ),
          for (final category in categories) ...[
            const SizedBox(width: 8),
            _CategoryChip(
              label: category,
              selected: selected == category,
              onTap: () => ref.read(selectedCategoryProvider.notifier).state = category,
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: scheme.primary.withValues(alpha: 0.25),
      labelStyle: TextStyle(color: selected ? scheme.primary : null, fontWeight: FontWeight.w600),
      side: BorderSide(color: selected ? scheme.primary : Theme.of(context).dividerColor),
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

/// Reorder is scoped within a single category group rather than gated behind
/// the category filter — grouping is always on, so this keeps drag-to-reorder
/// available in every view without extra state to track "is filtering".
class _CategoryHabitList extends ConsumerWidget {
  const _CategoryHabitList({required this.habits, required this.today});
  final List<Habit> habits;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      onReorderItem: (oldIndex, newIndex) async {
        final reordered = [...habits];
        final moved = reordered.removeAt(oldIndex);
        reordered.insert(newIndex, moved);
        await ref.read(habitRepositoryProvider).updateSortOrder(reordered);
      },
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Row(
          key: ValueKey('habit-${habit.id}'),
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 12),
                child: Icon(
                  Icons.drag_indicator,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
            Expanded(child: _HabitTileConnected(habit: habit, today: today)),
          ],
        );
      },
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
      onToggle: () async {
        final milestone = await repo.toggleCompletion(habit.id, today);
        if (milestone != null && context.mounted) {
          _celebrateMilestone(context, habit.name, milestone);
        }
      },
      onTap: () => context.push(AppRoutes.habitDetail, extra: habit.id),
    );
  }

  void _celebrateMilestone(BuildContext context, String habitName, int milestone) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          '🔥 $milestone-day streak on $habitName!',
          style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w600),
        ),
      ),
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
