import 'package:isar/isar.dart';

part 'periodic_reminder.g.dart';

@collection
class PeriodicReminder {
  Id id = Isar.autoIncrement;

  late String label;

  /// Minutes since midnight, window start (inclusive).
  late int startMinutes;

  /// Minutes since midnight, window end (inclusive).
  late int endMinutes;

  late int intervalMinutes;

  bool enabled = true;
}
