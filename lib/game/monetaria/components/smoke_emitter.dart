import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Spec-40 B: Permanente Rauchsäule am Vulkan.
///
/// Erzeugt alle 200 ms einen grauen Rauchpartikel, der nach oben steigt
/// und ausblendet. Deterministisches Random pro Tick.
class SmokeEmitter extends PositionComponent {
  SmokeEmitter({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(8),
          anchor: Anchor.center,
          priority: 5,
        );

  static final math.Random _rng = math.Random(7);
  double _accum = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _accum += dt;
    while (_accum >= 0.2) {
      _accum -= 0.2;
      _emit();
    }
  }

  void _emit() {
    final drift = (_rng.nextDouble() - 0.5) * 10;
    final size = 4.0 + _rng.nextDouble() * 4;
    final shade = 90 + _rng.nextInt(50);
    parent?.add(
      ParticleSystemComponent(
        position: position,
        priority: priority,
        particle: AcceleratedParticle(
          lifespan: 2.0,
          acceleration: Vector2(0, -8),
          speed: Vector2(drift, -30 - _rng.nextDouble() * 10),
          child: ComputedParticle(
            renderer: (canvas, particle) {
              final p = 1 - particle.progress;
              final paint = Paint()
                ..color = Color.fromARGB(
                  (180 * p).toInt(),
                  shade,
                  shade,
                  shade,
                );
              canvas.drawCircle(Offset.zero, size + particle.progress * 6, paint);
            },
          ),
        ),
      ),
    );
  }
}
