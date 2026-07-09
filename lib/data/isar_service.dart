import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/habit.dart';
import 'models/habit_log.dart';
import 'models/periodic_reminder.dart';

/// Opens the single Isar instance for the app. Every collection used
/// anywhere in the app MUST be registered in the `schemas` list below,
/// or Isar throws at runtime when that collection is first touched.
class IsarService {
  IsarService._();

  static Isar? _instance;

  static Future<Isar> open() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        HabitSchema,
        HabitLogSchema,
        PeriodicReminderSchema,
      ],
      directory: dir.path,
      name: 'nyra_habit_db',
    );
    return _instance!;
  }

  static Isar get instance {
    final i = _instance;
    if (i == null) {
      throw StateError('IsarService.open() must be awaited before use (see main.dart).');
    }
    return i;
  }
}
