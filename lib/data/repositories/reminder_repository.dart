import 'package:isar/isar.dart';

import '../models/periodic_reminder.dart';

class ReminderRepository {
  ReminderRepository(this._isar);
  final Isar _isar;

  Stream<List<PeriodicReminder>> watchAll() {
    return _isar.periodicReminders.where().watch(fireImmediately: true);
  }

  Future<int> save(PeriodicReminder reminder) {
    return _isar.writeTxn(() => _isar.periodicReminders.put(reminder));
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() => _isar.periodicReminders.delete(id));
  }
}
