import 'package:go_router/go_router.dart';

import '../../features/onboarding/onboarding_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/habit_form/habit_form_screen.dart';
import '../../features/habit_detail/habit_detail_screen.dart';
import '../../features/stats/stats_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/reminders/reminders_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const onboarding = '/onboarding';
  static const dashboard = '/';
  static const habitForm = '/habit-form';
  static const habitDetail = '/habit-detail';
  static const stats = '/stats';
  static const settings = '/settings';
  static const reminders = '/reminders';
}

GoRouter buildRouter(bool showOnboarding) {
  return GoRouter(
    initialLocation: showOnboarding ? AppRoutes.onboarding : AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.habitForm,
        builder: (context, state) => HabitFormScreen(habitId: state.extra as int?),
      ),
      GoRoute(
        path: AppRoutes.habitDetail,
        builder: (context, state) => HabitDetailScreen(habitId: state.extra as int),
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) => const RemindersScreen(),
      ),
    ],
  );
}
