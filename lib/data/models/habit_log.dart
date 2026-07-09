import 'package:isar/isar.dart';

part 'habit_log.g.dart';

@collection
class HabitLog {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('date')], unique: true, replace: true)
  late int habitId;

  /// Normalized to midnight (no time component) so date equality works.
  @Index()
  late DateTime date;

  bool completed = true;
}
