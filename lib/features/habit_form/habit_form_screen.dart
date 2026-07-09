import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/notification_service.dart';
import '../../data/models/habit.dart';
import '../../data/providers.dart';
import '../../shared/widgets/habit_icon.dart';

const _iconChoices = habitIconChoices;

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class HabitFormScreen extends ConsumerStatefulWidget {
  const HabitFormScreen({super.key, this.habitId});
  final int? habitId;

  @override
  ConsumerState<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends ConsumerState<HabitFormScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'General');
  IconData _selectedIcon = _iconChoices.first;
  Color _selectedColor = AppColors.habitPalette.first;
  FrequencyType _frequency = FrequencyType.daily;
  final Set<int> _customDays = {};
  TimeOfDay? _reminderTime;
  bool _loaded = false;
  Habit? _editing;

  @override
  void initState() {
    super.initState();
    if (widget.habitId != null) {
      _loadExisting(widget.habitId!);
    } else {
      _loaded = true;
    }
  }

  Future<void> _loadExisting(int id) async {
    final repo = ref.read(habitRepositoryProvider);
    final habit = await repo.getById(id);
    if (habit == null || !mounted) return;
    setState(() {
      _editing = habit;
      _nameController.text = habit.name;
      _categoryController.text = habit.category;
      _selectedIcon = habitIconFromCodePoint(habit.iconCodePoint);
      _selectedColor = Color(habit.colorValue);
      _frequency = habit.frequencyType;
      _customDays.addAll(habit.customDays);
      if (habit.reminderMinutes != null) {
        _reminderTime = TimeOfDay(
          hour: habit.reminderMinutes! ~/ 60,
          minute: habit.reminderMinutes! % 60,
        );
      }
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final repo = ref.read(habitRepositoryProvider);
    final habit = _editing ?? (Habit()..createdAt = DateTime.now());

    habit
      ..name = name
      ..category = _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim()
      ..iconCodePoint = _selectedIcon.codePoint
      ..colorValue = _selectedColor.toARGB32()
      ..frequencyType = _frequency
      ..customDays = _customDays.toList()
      ..reminderMinutes = _reminderTime == null ? null : _reminderTime!.hour * 60 + _reminderTime!.minute;

    final id = await repo.saveHabit(habit);

    if (_reminderTime != null) {
      await NotificationService.scheduleHabitReminder(
        habitId: id,
        habitName: name,
        minutesSinceMidnight: _reminderTime!.hour * 60 + _reminderTime!.minute,
      );
    } else {
      await NotificationService.cancelHabitReminder(id);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(_editing == null ? 'New Habit' : 'Edit Habit')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Habit name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 24),
          Text('Icon', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _iconChoices.map((icon) {
              final selected = icon.codePoint == _selectedIcon.codePoint;
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = icon),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected ? _selectedColor.withValues(alpha: 0.2) : Colors.transparent,
                    border: Border.all(color: selected ? _selectedColor : Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: selected ? _selectedColor : null),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppColors.habitPalette.map((color) {
              final selected = color.toARGB32() == _selectedColor.toARGB32();
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: selected ? Border.all(color: Colors.white, width: 3) : null,
                    boxShadow: selected
                        ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 12)]
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Frequency', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<FrequencyType>(
            segments: const [
              ButtonSegment(value: FrequencyType.daily, label: Text('Daily')),
              ButtonSegment(value: FrequencyType.weekly, label: Text('Weekly')),
              ButtonSegment(value: FrequencyType.custom, label: Text('Custom')),
            ],
            selected: {_frequency},
            onSelectionChanged: (s) => setState(() => _frequency = s.first),
          ),
          if (_frequency == FrequencyType.custom) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final day = i + 1;
                final selected = _customDays.contains(day);
                return FilterChip(
                  label: Text(_weekdayLabels[i]),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    if (v) {
                      _customDays.add(day);
                    } else {
                      _customDays.remove(day);
                    }
                  }),
                );
              }),
            ),
          ],
          const SizedBox(height: 24),
          Text('Reminder', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_outlined),
            title: Text(_reminderTime == null ? 'No reminder' : _reminderTime!.format(context)),
            trailing: _reminderTime != null
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _reminderTime = null),
                  )
                : null,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _reminderTime ?? TimeOfDay.now(),
              );
              if (time != null) setState(() => _reminderTime = time);
            },
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _save,
            child: Text(_editing == null ? 'Create Habit' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
