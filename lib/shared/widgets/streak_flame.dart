import 'package:flutter/material.dart';

class StreakFlame extends StatelessWidget {
  const StreakFlame({super.key, required this.streak, this.size = 16});

  final int streak;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) return const SizedBox.shrink();

    final intensity = (streak / 30).clamp(0.2, 1.0);
    final color = Color.lerp(const Color(0xFFFFB800), const Color(0xFFFF4D4D), intensity)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department, color: color, size: size),
        const SizedBox(width: 4),
        Text(
          '$streak',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
