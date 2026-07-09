import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/router/app_router.dart';
import '../../core/utils/date_utils.dart';
import '../../data/providers.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/habit_icon.dart';
import '../../shared/widgets/streak_flame.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  const HabitDetailScreen({super.key, required this.habitId});
  final int habitId;

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habitAsync = ref.watch(habitByIdProvider(widget.habitId));
    final logsAsync = ref.watch(habitLogsProvider(widget.habitId));
    final repo = ref.watch(habitRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.habitForm, extra: widget.habitId),
          ),
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            onPressed: () async {
              await repo.archiveHabit(widget.habitId);
              if (context.mounted) context.pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete habit?'),
                  content: const Text('This permanently removes the habit and all its history.'),
                  actions: [
                    TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => context.pop(true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) {
                await repo.deleteHabit(widget.habitId);
                if (context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
      body: habitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (habit) {
          if (habit == null) return const Center(child: Text('Habit not found'));
          final color = Color(habit.colorValue);

          return logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
            data: (logs) {
              final completedDates = logs.map((l) => dateOnly(l.date)).toSet();

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          habitIconFromCodePoint(habit.iconCodePoint),
                          color: color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(habit.name, style: Theme.of(context).textTheme.headlineSmall),
                            Text(habit.category, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GlassCard(
                          child: Column(
                            children: [
                              StreakFlame(streak: habit.currentStreak, size: 24),
                              const SizedBox(height: 4),
                              Text('Current streak', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassCard(
                          child: Column(
                            children: [
                              Icon(Icons.emoji_events, color: color, size: 24),
                              const SizedBox(height: 4),
                              Text('${habit.bestStreak} best', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassCard(
                          child: Column(
                            children: [
                              Icon(Icons.check_circle, color: color, size: 24),
                              const SizedBox(height: 4),
                              Text('${logs.length} total', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GlassCard(
                    child: TableCalendar(
                      firstDay: DateTime.now().subtract(const Duration(days: 365)),
                      lastDay: DateTime.now().add(const Duration(days: 30)),
                      focusedDay: _focusedDay,
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      onPageChanged: (day) => setState(() => _focusedDay = day),
                      onDaySelected: (selected, focused) async {
                        if (selected.isAfter(DateTime.now())) return;
                        await repo.toggleCompletion(widget.habitId, selected);
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final done = completedDates.contains(dateOnly(day));
                          if (!done) return null;
                          return Center(
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Text('${day.day}', style: const TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                        todayBuilder: (context, day, focusedDay) {
                          final done = completedDates.contains(dateOnly(day));
                          return Center(
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: done ? color : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: color, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: TextStyle(color: done ? Colors.white : color),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
