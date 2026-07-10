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

/// Streak lengths that trigger a one-time celebration when crossed upward.
const milestoneStreaks = <int>[7, 30, 100];

int _compareHabitOrder(Habit a, Habit b) {
  final bySortOrder = a.sortOrder.compareTo(b.sortOrder);
  if (bySortOrder != 0) return bySortOrder;
  return a.createdAt.compareTo(b.createdAt);
}

class HabitRepository {
  HabitRepository(this._isar);
  final Isar _isar;

  Stream<List<Habit>> watchActiveHabits() {
    return _isar.habits
        .filter()
        .archivedEqualTo(false)
        .watch(fireImmediately: true)
        .map((list) => list..sort(_compareHabitOrder));
  }

  Future<List<Habit>> allActiveHabits() => _isar.habits
      .filter()
      .archivedEqualTo(false)
      .findAll()
      .then((list) => list..sort(_compareHabitOrder));

  /// Persists a new relative order for [orderedHabits] in one write
  /// transaction. Callers pass habits already in their desired order
  /// (e.g. after a drag-to-reorder within a category group).
  Future<void> updateSortOrder(List<Habit> orderedHabits) async {
    await _isar.writeTxn(() async {
      for (var i = 0; i < orderedHabits.length; i++) {
        orderedHabits[i].sortOrder = i;
        await _isar.habits.put(orderedHabits[i]);
      }
    });
  }

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
  /// Returns the milestone value (7, 30, 100...) if this toggle just pushed
  /// [Habit.currentStreak] up past a milestone, otherwise null.
  Future<int?> toggleCompletion(int habitId, DateTime date) async {
    final d = dateOnly(date);
    return _isar.writeTxn(() async {
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

      return _recomputeStreak(habitId);
    });
  }

  Future<int?> _recomputeStreak(int habitId) async {
    final habit = await _isar.habits.get(habitId);
    if (habit == null) return null;
    final previousStreak = habit.currentStreak;

    final logs = await _isar.habitLogs
        .filter()
        .habitIdEqualTo(habitId)
        .sortByDateDesc()
        .findAll();

    if (logs.isEmpty) {
      habit.currentStreak = 0;
      habit.lastCompletedDate = null;
      await _isar.habits.put(habit);
      return null;
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

    if (current > previousStreak && milestoneStreaks.contains(current)) {
      return current;
    }
    return null;
  }
}
