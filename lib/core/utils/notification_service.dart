import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name.identifier));
    } catch (_) {
      // Falls back to UTC (tz.local's default) if the platform lookup fails.
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);

    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  /// Schedules a repeating daily reminder for [habitId] at [minutesSinceMidnight].
  static Future<void> scheduleHabitReminder({
    required int habitId,
    required String habitName,
    required int minutesSinceMidnight,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      minutesSinceMidnight ~/ 60,
      minutesSinceMidnight % 60,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      habitId,
      'Time for "$habitName"',
      'Keep your streak alive today.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit Reminders',
          channelDescription: 'Daily reminders to complete your habits',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelHabitReminder(int habitId) => _plugin.cancel(habitId);

  static const _periodicSlotBase = 100000;
  static const _maxSlotsPerReminder = 200;

  static int _periodicNotificationId(int reminderId, int slotIndex) =>
      _periodicSlotBase + reminderId * _maxSlotsPerReminder + slotIndex;

  /// Schedules one repeating daily notification per time slot inside
  /// [startMinutes, endMinutes] spaced by [intervalMinutes]. Each slot is a
  /// separate OS alarm since flutter_local_notifications has no native
  /// "every N minutes within a window" primitive.
  static Future<void> schedulePeriodicReminder({
    required int reminderId,
    required String label,
    required int startMinutes,
    required int endMinutes,
    required int intervalMinutes,
  }) async {
    await cancelPeriodicReminder(reminderId);

    final slots = <int>[];
    for (var m = startMinutes; m <= endMinutes; m += intervalMinutes) {
      slots.add(m);
    }

    final now = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < slots.length && i < _maxSlotsPerReminder; i++) {
      final minutes = slots[i];
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        minutes ~/ 60,
        minutes % 60,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      await _plugin.zonedSchedule(
        _periodicNotificationId(reminderId, i),
        label,
        'Time to $label.',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'periodic_reminders',
            'Periodic Reminders',
            channelDescription: 'Recurring reminders within a time window',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> cancelPeriodicReminder(int reminderId) async {
    for (var i = 0; i < _maxSlotsPerReminder; i++) {
      await _plugin.cancel(_periodicNotificationId(reminderId, i));
    }
  }
}
