import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/design_tokens.dart';

/// Feuert einen einmaligen Konfetti-Burst als Overlay über der ganzen App
/// ab und räumt ihn nach [duration] selbst wieder weg. Praktisch für
/// Feier-Momente aus `ref.listen`-Callbacks (Level-Up, Trophäe), wo kein
/// eigener Stack zur Verfügung steht. No-op wenn kein Overlay erreichbar.
void burstConfettiOverlay(
  BuildContext context, {
  int seed = 0,
  int particleCount = 24,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => IgnorePointer(
      child: ConfettiBurst(seed: seed, particleCount: particleCount),
    ),
  );
  overlay.insert(entry);
  Future<void>.delayed(duration, () {
    if (entry.mounted) entry.remove();
  });
}

/// One-shot confetti burst from the center of its box. 24 colored squares
/// shoot in random radial directions and fade out over ~1.2s. Cheap, no
/// extra dependency.
class ConfettiBurst extends StatelessWidget {
  const ConfettiBurst({this.seed = 0, this.particleCount = 24, super.key});

  final int seed;
  final int particleCount;

  static const _palette = [
    FgColors.primary,
    FgColors.secondary,
    FgColors.success,
    FgColors.info,
    FgColors.alert,
  ];

  @override
  Widget build(BuildContext context) {
    final rng = math.Random(seed);
    return IgnorePointer(
      child: Stack(
        children: [
          for (var i = 0; i < particleCount; i++)
            _Particle(
              angle: rng.nextDouble() * math.pi * 2,
              speed: 60 + rng.nextDouble() * 80,
              color: _palette[rng.nextInt(_palette.length)],
              delay: (rng.nextInt(120)).ms,
            ),
        ],
      ),
    );
  }
}

class _Particle extends StatelessWidget {
  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.delay,
  });

  final double angle;
  final double speed;
  final Color color;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final dx = math.cos(angle) * speed;
    final dy = math.sin(angle) * speed;
    return Center(
      child: Container(width: 6, height: 6, color: color)
          .animate(delay: delay)
          .moveX(begin: 0, end: dx, duration: 900.ms, curve: Curves.easeOut)
          .moveY(begin: 0, end: dy, duration: 900.ms, curve: Curves.easeOut)
          .fadeOut(begin: 1.0, delay: 600.ms, duration: 600.ms),
    );
  }
}
