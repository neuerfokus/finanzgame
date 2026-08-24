import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design_tokens.dart';

/// Player boat sailing between islands.
///
/// Spec-16: rendered as a small custom-painted caravel — trapezoid hull,
/// mast and triangle sail. If `assets/images/phone/boat.png` is available
/// at runtime the sprite replaces the painted fallback, but the fallback
/// is always added first so tests (which run without an asset bundle)
/// see a deterministic visual.
class Boat extends PositionComponent {
  Boat({required Vector2 homePort})
      : super(
          position: homePort.clone(),
          size: Vector2.all(_size),
          anchor: Anchor.center,
        );

  // spec-39: galleon vergrößert auf 96 px — passt zur AURORA-Referenz mit
  // 3 Masten und Heck-Aufbau.
  static const double _size = 96;
  static const double _travelSeconds = 1.5;
  // Spec-39: User-Referenz "AURORA"-Galleone. Erwartet 256×192 px PNG mit
  // transparentem Hintergrund. Fallback bleibt das alte `phone/boat.png`,
  // dann CustomPaint-Galleone wenn beides fehlt.
  static const String _spritePath = 'ships/aurora.png';
  static const String _spritePathLegacy = 'phone/boat.png';

  _CaravelShape? _fallback;
  SpriteComponent? _sprite;

  @override
  Future<void> onLoad() async {
    // Fallback first — guarantees a visible boat even if the sprite asset
    // never resolves (offline, tests, missing pubspec entry).
    _fallback = _CaravelShape(size: _size);
    add(_fallback!);

    // Try to upgrade to the Kenney pirate-pack sprite. Any failure
    // (no asset bundle in tests, missing file, decode error) is swallowed
    // and the fallback remains in place.
    if (!_canLoadAssets) return;
    Sprite? sprite;
    for (final path in [_spritePath, _spritePathLegacy]) {
      try {
        sprite = await Sprite.load(path);
        break;
      } on Object {
        // Try next path.
      }
    }
    if (sprite == null) return; // Keep CustomPaint fallback
    // Spec-43 v6: Kreis-BG entfernt (User-Feedback "ovales BG-Element
    // hässlich"). Schiff rendert mit nativem PNG-Alpha auf Map-Wasser.
    _sprite = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.topLeft,
    );
    add(_sprite!);
    _fallback?.removeFromParent();
    _fallback = null;
  }

  /// Returns true when the asset bundle is available. In `flutter_test`
  /// runs that do not call `TestWidgetsFlutterBinding.ensureInitialized()`
  /// the rootBundle access throws — we want to skip the sprite load
  /// entirely in that case rather than rely on the Flame async-error
  /// reporter, which marks the test as failed even when we catch the
  /// exception locally.
  bool get _canLoadAssets {
    try {
      // Triggers the binding check used by PlatformAssetBundle.load;
      // throws when no WidgetsBinding has been initialized.
      ServicesBinding.instance;
      return true;
    } on Object {
      return false;
    }
  }

  /// Animate to [destination] over [_travelSeconds].
  /// Resolves once the move-effect completes.
  Future<void> travelTo(Vector2 destination) {
    final completer = Completer<void>();
    add(
      MoveToEffect(
        destination,
        EffectController(duration: _travelSeconds, curve: Curves.easeInOut),
        onComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    return completer.future;
  }
}

/// Spec-39 custom-painted galleon "AURORA": 3-master mit Bug-, Haupt- und
/// Heckmast, weißen Segeln, Heck-Aufbau und Schatten. Approximation der
/// User-Referenz aus 2026-05-20 — wird ersetzt sobald ein echtes
/// Sprite-PNG verfügbar ist.
class _CaravelShape extends PositionComponent {
  _CaravelShape({required double size})
      : super(size: Vector2.all(size), anchor: Anchor.topLeft);

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final hullDark = Paint()..color = const Color(0xFF5A2E12);
    final hullLight = Paint()..color = const Color(0xFF8B5A2B);
    final deck = Paint()..color = const Color(0xFFA77442);
    final sailPaint = Paint()..color = const Color(0xFFF5EFDD);
    final mastPaint = Paint()..color = const Color(0xFF3A2410);
    final shadow = Paint()
      ..color = const Color(0xFF000000).withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = FgColors.outline;

    // Water shadow ellipse unter dem Rumpf.
    canvas.drawOval(
      Rect.fromLTWH(w * 0.05, h * 0.92, w * 0.9, h * 0.08),
      shadow,
    );

    // Rumpf — Unterteil dunkel, Deck heller.
    final hull = Path()
      ..moveTo(w * 0.05, h * 0.62)
      ..lineTo(w * 0.95, h * 0.62)
      ..lineTo(w * 0.85, h * 0.92)
      ..lineTo(w * 0.15, h * 0.92)
      ..close();
    canvas.drawPath(hull, hullDark);
    canvas.drawPath(hull, stroke);

    // Deck-Linie als helleres Trapez auf den oberen Rumpf.
    final deckPath = Path()
      ..moveTo(w * 0.08, h * 0.62)
      ..lineTo(w * 0.92, h * 0.62)
      ..lineTo(w * 0.88, h * 0.70)
      ..lineTo(w * 0.12, h * 0.70)
      ..close();
    canvas.drawPath(deckPath, hullLight);

    // Heck-Aufbau (Achterdeck) rechts.
    final stern = Path()
      ..moveTo(w * 0.70, h * 0.50)
      ..lineTo(w * 0.95, h * 0.55)
      ..lineTo(w * 0.93, h * 0.66)
      ..lineTo(w * 0.70, h * 0.62)
      ..close();
    canvas.drawPath(stern, deck);
    canvas.drawPath(stern, stroke);

    // Drei Masten: Bug (links), Haupt (mitte), Heck (rechts).
    final mastPositions = [w * 0.28, w * 0.50, w * 0.72];
    for (final mx in mastPositions) {
      canvas.drawRect(
        Rect.fromLTWH(mx - w * 0.015, h * 0.10, w * 0.03, h * 0.55),
        mastPaint,
      );
    }

    // Drei rechteckige Hauptsegel pro Mast (eingekreuzt, klassisch Galleon).
    final sailRects = [
      Rect.fromLTWH(w * 0.18, h * 0.18, w * 0.22, h * 0.30),
      Rect.fromLTWH(w * 0.40, h * 0.13, w * 0.22, h * 0.35),
      Rect.fromLTWH(w * 0.62, h * 0.18, w * 0.22, h * 0.30),
    ];
    for (final r in sailRects) {
      canvas.drawRect(r, sailPaint);
      canvas.drawRect(r, stroke);
    }

    // Bug-Klüverbaum (diagonale Linie nach links unten).
    final bowsprit = Paint()
      ..color = const Color(0xFF3A2410)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.05, h * 0.62),
      Offset(w * 0.00, h * 0.55),
      bowsprit,
    );

    // Kleines Flaggen-Dreieck am Heckmast.
    final flag = Path()
      ..moveTo(w * 0.72, h * 0.08)
      ..lineTo(w * 0.82, h * 0.11)
      ..lineTo(w * 0.72, h * 0.14)
      ..close();
    canvas.drawPath(flag, Paint()..color = const Color(0xFFE53935));
  }
}
