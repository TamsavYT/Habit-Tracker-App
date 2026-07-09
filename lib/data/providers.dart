import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'models/habit.dart';
import 'models/habit_log.dart';
import 'models/periodic_reminder.dart';
import 'repositories/habit_repository.dart';
import 'repositories/reminder_repository.dart';

/// Overridden in main.dart once Isar.open() resolves.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden in main.dart');
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.watch(isarProvider));
});

final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(habitRepositoryProvider).watchActiveHabits();
});

final habitLogsProvider = StreamProvider.family<List<HabitLog>, int>((ref, habitId) {
  return ref.watch(habitRepositoryProvider).watchLogsForHabit(habitId);
});

final habitByIdProvider = FutureProvider.family<Habit?, int>((ref, id) {
  return ref.watch(habitRepositoryProvider).getById(id);
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(isarProvider));
});

final periodicRemindersProvider = StreamProvider<List<PeriodicReminder>>((ref) {
  return ref.watch(reminderRepositoryProvider).watchAll();
});
