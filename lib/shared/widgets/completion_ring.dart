import 'package:flutter/material.dart';

class CompletionRing extends StatelessWidget {
  const CompletionRing({
    super.key,
    required this.progress,
    this.size = 96,
    this.strokeWidth = 10,
  });

  final double progress; // 0..1
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0, 1)),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: value,
                  strokeWidth: strokeWidth,
                  trackColor: scheme.onSurface.withValues(alpha: 0.08),
                  startColor: scheme.primary,
                  endColor: scheme.secondary,
                ),
              );
            },
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0, 1)),
            duration: const Duration(milliseconds: 600),
            builder: (context, value, _) => Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.startColor,
    required this.endColor,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color startColor;
  final Color endColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = Paint()
      ..shader = SweepGradient(
        colors: [startColor, endColor],
        startAngle: -1.5708,
        endAngle: -1.5708 + 6.2832 * progress,
        transform: const GradientRotation(-1.5708),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -1.5708, 6.2832 * progress, false, sweep);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress;
}
