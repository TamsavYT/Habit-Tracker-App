import 'package:flutter/material.dart';

/// Curated Material icon choices for habits. Storing codePoints from the
/// built-in MaterialIcons font (no extra font family needed) means we never
/// need `fontFamily`/`fontPackage`, which also keeps icon tree-shaking happy.
const habitIconChoices = <IconData>[
  Icons.fitness_center,
  Icons.menu_book,
  Icons.water_drop,
  Icons.bedtime,
  Icons.edit,
  Icons.favorite,
  Icons.psychology,
  Icons.eco,
  Icons.directions_bike,
  Icons.music_note,
  Icons.code,
  Icons.savings,
];

IconData habitIconFromCodePoint(int codePoint) {
  return IconData(codePoint, fontFamily: 'MaterialIcons');
}
