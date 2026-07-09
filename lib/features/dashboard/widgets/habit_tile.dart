import 'package:flutter/material.dart';

import '../../../data/models/habit.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/habit_icon.dart';
import '../../../shared/widgets/streak_flame.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.completedToday,
    required this.onToggle,
    required this.onTap,
  });

  final Habit habit;
  final bool completedToday;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.colorValue);

    final tile = AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: completedToday ? 0.5 : 1.0,
      child: GlassCard(
        onTap: onTap,
        glowColor: completedToday ? color : null,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                habitIconFromCodePoint(habit.iconCodePoint),
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  StreakFlame(streak: habit.currentStreak),
                ],
              ),
            ),
            // Once completed, the checkbox is locked — swipe right to undo instead.
            GestureDetector(
              onTap: completedToday ? null : onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completedToday ? color : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                ),
                child: completedToday
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: completedToday
          ? Dismissible(
              key: ValueKey('habit-${habit.id}-${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (_) async {
                onToggle();
                return false;
              },
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.undo, color: color),
                    const SizedBox(width: 8),
                    Text('Undo', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              child: tile,
            )
          : tile,
    );
  }
}
