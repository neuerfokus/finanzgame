import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';
import '../../../domain/plant/plant.dart';
import '../../../features/audio/sound_service.dart';

/// One plant plot on the Spar-Insel.
///
/// Visual states:
///  - empty → brown tilled rect
///  - growing → green rect, height tracks `currentStage / stages`
///  - ready → bright pulsing rect
///
/// Sprite-based replacement deferred until plant tileset lands.
class PlantPlot extends PositionComponent with TapCallbacks {
  PlantPlot({
    required this.plotIndex,
    required Vector2 worldPosition,
    required this.onEmptyTap,
    required this.onReadyTap,
    Vector2? tileSize,
  }) : super(
          position: worldPosition,
          size: tileSize ?? Vector2(64, 64),
          anchor: Anchor.center,
        );

  static final math.Random _rng = math.Random(42);

  final int plotIndex;
  final void Function(int plotIndex) onEmptyTap;
  final void Function(int plotIndex) onReadyTap;

  Plant? _plant;

  // Children references for cheap repaints.
  late final RectangleComponent _soil;
  RectangleComponent? _growth;
  RectangleComponent? _readyGlow;
  TextComponent? _emojiOverlay;

  @override
  Future<void> onLoad() async {
    _soil = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF5A3A1F),
      anchor: Anchor.topLeft,
    );
    add(_soil);
    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = FgColors.outline,
        anchor: Anchor.topLeft,
      ),
    );
  }

  void setPlant(Plant? plant) {
    _plant = plant;
    _growth?.removeFromParent();
    _growth = null;
    _readyGlow?.removeFromParent();
    _readyGlow = null;
    _emojiOverlay?.removeFromParent();
    _emojiOverlay = null;
    if (plant == null) return;

    final spec = PlantKinds.spec(plant.kind);
    // Spec-38 follow-up: Minimum-Höhe 16px für stage 0 damit Spieler
    // sofort sieht dass gepflanzt wurde. Vorher 4px → unsichtbar.
    final fraction = (plant.currentStage / spec.stages).clamp(0.0, 1.0);
    final baseH = (size.y - 8) * fraction;
    final h = baseH < 16 ? 16.0 : baseH;
    final color = plant.status == PlantStatus.ready
        ? FgColors.primary
        : FgColors.success;

    _growth = RectangleComponent(
      size: Vector2(size.x - 16, h.clamp(16, size.y - 8).toDouble()),
      position: Vector2(8, size.y - 4 - h.clamp(16, size.y - 8).toDouble()),
      paint: Paint()..color = color,
      anchor: Anchor.topLeft,
    );
    add(_growth!);

    // Spec-38: Emoji-Overlay zeigt Pflanzenart sofort erkennbar.
    // Welle-7: Skaliert mit cell-Größe (adaptive grid kann 2×2 bis 3×4).
    final emojiSize = (size.y * 0.5).clamp(28.0, 120.0);
    _emojiOverlay = TextComponent(
      text: plant.kind.emoji,
      textRenderer: TextPaint(
        style: TextStyle(fontSize: emojiSize),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(_emojiOverlay!);

    if (plant.status == PlantStatus.ready) {
      _readyGlow = RectangleComponent(
        size: size,
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = FgColors.primary.withValues(alpha: 0.6),
        anchor: Anchor.topLeft,
      );
      add(_readyGlow!);
      _readyGlow!.add(
        ScaleEffect.by(
          Vector2.all(1.06),
          EffectController(
            duration: 0.4,
            alternate: true,
            infinite: true,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    final p = _plant;
    if (p == null) {
      onEmptyTap(plotIndex);
      return;
    }
    if (p.status == PlantStatus.ready) {
      onReadyTap(plotIndex);
    }
  }

  /// Plays harvest particles + a brief shake + SFX. The yield-pop number is
  /// handled by the Flutter HUD via `CashState` reactivity.
  Future<void> playHarvestJuice() async {
    SoundService.instance.playSfx(AudioKey.harvest);
    // Particle burst.
    final particles = ParticleSystemComponent(
      position: size / 2,
      particle: Particle.generate(
        count: 16,
        lifespan: 0.7,
        generator: (i) {
          final angle = (i / 16) * math.pi * 2;
          final speed = 80 + _rng.nextDouble() * 60;
          return AcceleratedParticle(
            acceleration: Vector2(0, 180),
            speed: Vector2(math.cos(angle), math.sin(angle)) * speed,
            child: CircleParticle(
              radius: 3,
              paint: Paint()..color = FgColors.success,
            ),
          );
        },
      ),
    );
    add(particles);

    // Shake.
    add(
      MoveByEffect(
        Vector2(4, 0),
        EffectController(
          duration: 0.05,
          alternate: true,
          repeatCount: 4,
        ),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));
  }
}
