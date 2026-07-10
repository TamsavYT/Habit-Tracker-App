import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/notification_service.dart';
import '../../data/models/periodic_reminder.dart';
import '../../data/providers.dart';
import '../../shared/widgets/glass_card.dart';

void _showScheduleError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Couldn't schedule reminder — check notification permissions"),
    ),
  );
}

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(periodicRemindersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Periodic Reminders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, ref),
        child: const Icon(Icons.add),
      ),
      body: remindersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (reminders) {
          if (reminders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No periodic reminders yet.\nAdd one for things like "drink water every 30 min, 9am-9pm".',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: reminders.map((r) => _ReminderTile(reminder: r)).toList(),
          );
        },
      ),
    );
  }

  void _openForm(BuildContext context, WidgetRef ref, [PeriodicReminder? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ReminderForm(existing: existing),
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({required this.reminder});
  final PeriodicReminder reminder;

  String _fmt(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${m.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(reminderRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => _ReminderForm(existing: reminder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.label, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Every ${reminder.intervalMinutes} min, ${_fmt(reminder.startMinutes)} – ${_fmt(reminder.endMinutes)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Switch(
              value: reminder.enabled,
              onChanged: (v) async {
                reminder.enabled = v;
                await repo.save(reminder);
                try {
                  if (v) {
                    await NotificationService.schedulePeriodicReminder(
                      reminderId: reminder.id,
                      label: reminder.label,
                      startMinutes: reminder.startMinutes,
                      endMinutes: reminder.endMinutes,
                      intervalMinutes: reminder.intervalMinutes,
                    );
                  } else {
                    await NotificationService.cancelPeriodicReminder(reminder.id);
                  }
                } catch (_) {
                  if (context.mounted) _showScheduleError(context);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await NotificationService.cancelPeriodicReminder(reminder.id);
                await repo.delete(reminder.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderForm extends ConsumerStatefulWidget {
  const _ReminderForm({this.existing});
  final PeriodicReminder? existing;

  @override
  ConsumerState<_ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends ConsumerState<_ReminderForm> {
  late final _labelController = TextEditingController(text: widget.existing?.label ?? '');
  late TimeOfDay _start = widget.existing == null
      ? const TimeOfDay(hour: 9, minute: 0)
      : TimeOfDay(hour: widget.existing!.startMinutes ~/ 60, minute: widget.existing!.startMinutes % 60);
  late TimeOfDay _end = widget.existing == null
      ? const TimeOfDay(hour: 21, minute: 0)
      : TimeOfDay(hour: widget.existing!.endMinutes ~/ 60, minute: widget.existing!.endMinutes % 60);
  late int _interval = widget.existing?.intervalMinutes ?? 30;

  Future<void> _save() async {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;

    final startMinutes = _start.hour * 60 + _start.minute;
    final endMinutes = _end.hour * 60 + _end.minute;
    if (endMinutes <= startMinutes) return;

    final reminder = widget.existing ?? PeriodicReminder();
    reminder
      ..label = label
      ..startMinutes = startMinutes
      ..endMinutes = endMinutes
      ..intervalMinutes = _interval
      ..enabled = true;

    final repo = ref.read(reminderRepositoryProvider);
    final id = await repo.save(reminder);

    try {
      await NotificationService.schedulePeriodicReminder(
        reminderId: id,
        label: label,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        intervalMinutes: _interval,
      );
    } catch (_) {
      if (mounted) _showScheduleError(context);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existing == null ? 'New Reminder' : 'Edit Reminder',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(labelText: 'What to remind (e.g. Drink water)'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Start'),
                  subtitle: Text(_start.format(context)),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: _start);
                    if (t != null) setState(() => _start = t);
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('End'),
                  subtitle: Text(_end.format(context)),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: _end);
                    if (t != null) setState(() => _end = t);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Repeat every $_interval minutes', style: Theme.of(context).textTheme.bodyMedium),
          Slider(
            value: _interval.toDouble(),
            min: 10,
            max: 180,
            divisions: 17,
            label: '$_interval min',
            onChanged: (v) => setState(() => _interval = v.round()),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: _save, child: const Text('Save Reminder')),
          ),
        ],
      ),
    );
  }
}
