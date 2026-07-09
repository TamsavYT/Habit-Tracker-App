import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.glowColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = Theme.of(context).dividerColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Theme.of(context).cardTheme.color?.withValues(alpha: isDark ? 0.6 : 0.85),
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
                boxShadow: glowColor != null
                    ? [
                        BoxShadow(
                          color: glowColor!.withValues(alpha: 0.35),
                          blurRadius: 24,
                          spreadRadius: -4,
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
