import 'package:isar/isar.dart';

part 'habit.g.dart';

enum FrequencyType { daily, weekly, custom }

@collection
class Habit {
  Id id = Isar.autoIncrement;

  late String name;

  /// Codepoint of a Phosphor icon, stored so it survives serialization.
  late int iconCodePoint;

  /// ARGB hex value, e.g. 0xFF7C5CFF.
  late int colorValue;

  @Enumerated(EnumType.name)
  late FrequencyType frequencyType;

  /// Used when frequencyType == custom. 1 = Monday ... 7 = Sunday.
  List<int> customDays = [];

  /// Minutes since midnight for the reminder, null = no reminder.
  int? reminderMinutes;

  String category = 'General';

  @Index()
  late DateTime createdAt;

  bool archived = false;

  int currentStreak = 0;
  int bestStreak = 0;

  @Index()
  DateTime? lastCompletedDate;

  /// Manual drag-to-reorder position within a category. Existing habits
  /// default to 0, so ties fall back to [createdAt] ordering.
  int sortOrder = 0;
}
