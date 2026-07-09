import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(habitRepositoryProvider);
    final habits = await repo.allActiveHabits();
    final payload = [];
    for (final h in habits) {
      final logs = await repo.logsForHabit(h.id);
      payload.add({
        'name': h.name,
        'category': h.category,
        'iconCodePoint': h.iconCodePoint,
        'colorValue': h.colorValue,
        'frequencyType': h.frequencyType.name,
        'customDays': h.customDays,
        'currentStreak': h.currentStreak,
        'bestStreak': h.bestStreak,
        'logs': logs.map((l) => l.date.toIso8601String()).toList(),
      });
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/nyra_backup.json');
    await file.writeAsString(jsonEncode(payload));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark theme'),
            value: themeMode == ThemeMode.dark,
            onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Periodic reminders'),
            subtitle: const Text('Recurring nudges like "drink water every 30 min"'),
            onTap: () => context.push(AppRoutes.reminders),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Export data'),
            subtitle: const Text('Save a JSON backup of all habits'),
            onTap: () => _exportData(context, ref),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Habitus — Habit OS'),
            subtitle: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
