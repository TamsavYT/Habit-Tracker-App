import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/router/app_router.dart';

class _Slide {
  const _Slide(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}

const _slides = [
  _Slide(
    Icons.track_changes,
    'Build habits that stick',
    'Track daily, weekly, or custom routines with a system built for consistency.',
  ),
  _Slide(
    Icons.local_fire_department,
    'Watch your streaks grow',
    'Every completed day fuels your streak flame. Miss a day, start again — no guilt.',
  ),
  _Slide(
    Icons.show_chart,
    'See your progress clearly',
    'Heatmaps and stats show exactly how far you\'ve come.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final slide = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: scheme.primary.withValues(alpha: 0.12),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.primary.withValues(alpha: 0.3),
                                blurRadius: 40,
                                spreadRadius: -6,
                              ),
                            ],
                          ),
                          child: Icon(slide.icon, size: 64, color: scheme.primary),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? scheme.primary : scheme.onSurface.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_page == _slides.length - 1) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                  child: Text(_page == _slides.length - 1 ? 'Get Started' : 'Next'),
                ),
              ),
            ),
            TextButton(
              onPressed: _finish,
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
