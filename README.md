# Habitus — Habit OS

Minimalistic, futuristic habit tracker built with Flutter. Local-only storage (Isar), no accounts, no cloud.

## Stack

- State: `flutter_riverpod`
- Storage: `isar` (local NoSQL, code-generated schemas)
- Routing: `go_router`
- Charts: `fl_chart`
- Calendar heatmap: `table_calendar`
- Notifications: `flutter_local_notifications`
- Fonts: Space Grotesk (headings) + Inter (body) via `google_fonts`
- Icons: Material Icons (`phosphor_flutter` was tried first but is currently incompatible with Flutter's newer `IconData` API — see Known Issues)

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # regenerate Isar schemas after editing lib/data/models/*.dart
flutter run
```

## Building a release APK

Habit icons are referenced dynamically (`IconData(codePoint, ...)` built from a stored int), so Flutter's icon tree-shaker can't prove which glyphs are used at compile time. Always build with:

```bash
flutter build apk --release --no-tree-shake-icons
```

## Project structure

```
lib/
  core/        theme, router, notification service, date utils
  data/        Isar models, repositories, Riverpod providers, IsarService (schema registration)
  features/    onboarding, dashboard, habit_form, habit_detail, stats, settings
  shared/      reusable widgets (glass card, streak flame, completion ring, habit icon picker)
```

## Known issues / follow-ups

- `phosphor_flutter@2.1.0` (latest on pub.dev) subclasses `IconData`, which is now a `final` class in current Flutter — it fails to compile. Swapped to Material Icons; revisit if phosphor_flutter ships a fix.
- `isar@3.1.0+1` / `isar_flutter_libs` predate AGP's mandatory `namespace` and `compileSdk` requirements. `android/build.gradle.kts` patches this in a `subprojects` block — remove that patch if you upgrade to a newer Isar release that fixes it upstream.
- `test/widget_test.dart` is a placeholder — the app requires a live Isar instance at boot, so a real widget test needs a fake/in-memory Isar override wired through `ProviderScope.overrides`.
