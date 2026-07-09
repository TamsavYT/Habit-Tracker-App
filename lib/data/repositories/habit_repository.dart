import 'package:isar/isar.dart';

import '../../core/utils/date_utils.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';

/// Whether [habit] is scheduled to run on [date] at all. Daily/weekly habits
/// are scheduled every day; custom habits only on their configured weekdays
/// (1 = Monday ... 7 = Sunday, matching [DateTime.weekday]).
bool isScheduledDay(Habit habit, DateTime date) {
  if (habit.frequencyType != FrequencyType.custom) return true;
  if (habit.customDays.isEmpty) return true;
  return habit.customDays.contains(date.weekday);
}

class HabitRepository {
  HabitRepository(this._isar);
  final Isar _isar;

  Stream<List<Habit>> watchActiveHabits() {
    return _isar.habits
        .filter()
        .archivedEqualTo(false)
        .watch(fireImmediately: true)
        .map((list) => list..sort((a, b) => a.createdAt.compareTo(b.createdAt)));
  }

  Future<List<Habit>> allActiveHabits() =>
      _isar.habits.filter().archivedEqualTo(false).findAll();

  Future<Habit?> getById(int id) => _isar.habits.get(id);

  Future<int> saveHabit(Habit habit) {
    return _isar.writeTxn(() => _isar.habits.put(habit));
  }

  Future<void> archiveHabit(int id) async {
    final habit = await _isar.habits.get(id);
    if (habit == null) return;
    habit.archived = true;
    await _isar.writeTxn(() => _isar.habits.put(habit));
  }

  Future<void> deleteHabit(int id) async {
    await _isar.writeTxn(() async {
      await _isar.habits.delete(id);
      final logs = await _isar.habitLogs.filter().habitIdEqualTo(id).findAll();
      await _isar.habitLogs.deleteAll(logs.map((l) => l.id).toList());
    });
  }

  Stream<List<HabitLog>> watchLogsForHabit(int habitId) {
    return _isar.habitLogs.filter().habitIdEqualTo(habitId).watch(fireImmediately: true);
  }

  Future<List<HabitLog>> logsForHabit(int habitId) =>
      _isar.habitLogs.filter().habitIdEqualTo(habitId).findAll();

  Future<HabitLog?> logForDate(int habitId, DateTime date) {
    final d = dateOnly(date);
    return _isar.habitLogs
        .filter()
        .habitIdEqualTo(habitId)
        .dateEqualTo(d)
        .findFirst();
  }

  /// Toggles completion for a given day and recomputes the cached streak.
  Future<void> toggleCompletion(int habitId, DateTime date) async {
    final d = dateOnly(date);
    await _isar.writeTxn(() async {
      final existing = await _isar.habitLogs
          .filter()
          .habitIdEqualTo(habitId)
          .dateEqualTo(d)
          .findFirst();

      if (existing != null) {
        await _isar.habitLogs.delete(existing.id);
      } else {
        final log = HabitLog()
          ..habitId = habitId
          ..date = d
          ..completed = true;
        await _isar.habitLogs.put(log);
      }

      await _recomputeStreak(habitId);
    });
  }

  Future<void> _recomputeStreak(int habitId) async {
    final habit = await _isar.habits.get(habitId);
    if (habit == null) return;

    final logs = await _isar.habitLogs
        .filter()
        .habitIdEqualTo(habitId)
        .sortByDateDesc()
        .findAll();

    if (logs.isEmpty) {
      habit.currentStreak = 0;
      habit.lastCompletedDate = null;
      await _isar.habits.put(habit);
      return;
    }

    final dates = logs.map((l) => l.date).toSet();

    // Previous scheduled day before [d], skipping days the habit isn't due on.
    // Capped so a misconfigured (empty) custom schedule can't loop forever.
    DateTime prevScheduledDay(DateTime d) {
      var day = d.subtract(const Duration(days: 1));
      for (var i = 0; i < 7 && !isScheduledDay(habit, day); i++) {
        day = day.subtract(const Duration(days: 1));
      }
      return day;
    }

    var cursor = dateOnly(DateTime.now());
    var current = 0;

    // Allow the streak to still count if today isn't logged yet but yesterday was.
    if (isScheduledDay(habit, cursor) && !dates.contains(cursor)) {
      cursor = prevScheduledDay(cursor);
    }
    while (dates.contains(cursor)) {
      current++;
      cursor = prevScheduledDay(cursor);
    }

    // Compute best streak across full history, only over scheduled days so
    // an off-schedule completion (or a skipped non-scheduled day) can't
    // wrongly extend or break a custom habit's run.
    final sorted = dates.toList()..sort();
    var best = 0;
    var run = 0;
    DateTime? prev;
    for (final d in sorted) {
      if (prev != null && prevScheduledDay(d) == prev) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
      prev = d;
    }

    habit.currentStreak = current;
    habit.bestStreak = best > habit.bestStreak ? best : habit.bestStreak;
    habit.lastCompletedDate = logs.first.date;
    await _isar.habits.put(habit);
  }
}
