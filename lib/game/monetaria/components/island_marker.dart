import 'dart:async' as async;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design_tokens.dart';
import '../../../features/monetaria/island_identity.dart';
import '../state/monetaria_state.dart' show IslandId;

/// Visual island marker on the Monetaria map.
///
/// Spec-16: each island renders with a custom-painted primitive shape
/// (form-spec from [IslandIdentity]) tinted with its identity color plus
/// a 24-px emoji glyph overlay. Locked islands ignore the themed glyph
/// and render grey with 🔒 instead (spec-13).
///
/// Spec-23: when the asset bundle is available the primitive is replaced
/// with a Kenney pirate-pack `tile_NN.png` sprite. Tests without a
/// binding never hit the asset load and keep seeing the polygon fallback.
/// Labels are split into a larger glyph above the sprite and a
/// contrast box (black 80%) around the name below the sprite.
class IslandMarker extends PositionComponent with TapCallbacks {
  IslandMarker({
    required this.id,
    required this.label,
    required this.unlocked,
    required this.onSelected,
    required Vector2 worldPosition,
    this.onLockedTap,
    this.onLongPressed,
    this.decorGlyphs = const <String>[],
  }) : super(
          position: worldPosition,
          size: Vector2.all(_diameter),
          anchor: Anchor.center,
        );

  // Spec-39/41: AI-composite-PNGs brauchen mehr Platz damit die Details
  // (Sparkasse, Sparschwein, Vulkan-Rauch, Schiffe) lesbar bleiben.
  // Spec-43 follow-up: Marker von 160 → 200 px für bessere Lesbarkeit
  // der detaillierten AI-Composite-Bilder.
  static const double _diameter = 200;
  static const Color _lockedGrey = Color(0xFF808890);

  /// Spec-39: per-IslandId Composite-PNG. Wenn vorhanden, ersetzt es das
  /// Basis-Tile + Decorations und rendert die User-Referenz-Vision exakt.
  /// Dateien legt der User unter `assets/images/islands_composite/`.
  /// Erwartet sind 256×256 px transparente PNGs.
  static const Map<String, String> _islandComposite = {
    IslandId.heimathafen: 'islands_composite/heimathafen.png',
    IslandId.sparInsel: 'islands_composite/spar_insel.png',
    IslandId.etfInsel: 'islands_composite/etf_insel.png',
    IslandId.vulkan: 'islands_composite/vulkan.png',
    IslandId.goldmine: 'islands_composite/goldmine.png',
    IslandId.aktienArchipel: 'islands_composite/aktien_archipel.png',
    IslandId.inflationAtoll: 'islands_composite/inflation_atoll.png',
    IslandId.mischwald: 'islands_composite/mischwald.png',
    IslandId.wohnviertel: 'islands_composite/wohnviertel.png',
  };

  /// Per-IslandForm pirate-pack tile mapping (spec-23). Tiles live in
  /// `assets/images/islands/`. Picked from the 30 available `tile_NN.png`
  /// files; swap to a more form-appropriate index here when better art
  /// becomes available.
  /// spec-37: switched from pirate-pack 2D tiles to Kenney
  /// isometric-landscape PNGs (sharper, klar erkennbar).
  static const Map<IslandForm, String> _formSprite = {
    IslandForm.housePentagon: 'iso/house.png',
    IslandForm.hill: 'iso/grass_small.png',
    IslandForm.wave: 'iso/water.png',
    IslandForm.flatOval: 'iso/sand.png',
    IslandForm.trianglePeak: 'iso/rock.png',
    IslandForm.volcano: 'iso/rock.png',
    IslandForm.tree: 'iso/tree.png',
  };

  final String id;
  final String label;
  final bool unlocked;
  final void Function(IslandMarker island) onSelected;

  /// Welle-8 Round 17: Tap auf gesperrte Insel — zeigt Unlock-Hinweis.
  final void Function(IslandMarker island)? onLockedTap;

  /// Spec-43 Stage 3: optional Long-Press callback (öffnet Decor-Editor).
  final void Function(IslandMarker island)? onLongPressed;

  /// Spec-43 Stage 3: bis zu 3 Decor-Glyphs als Mini-Stack unter dem Label.
  final List<String> decorGlyphs;

  async.Timer? _longPressTimer;
  bool _longPressFired = false;

  late final IslandIdentity _identity;

  @override
  Future<void> onLoad() async {
    _identity = islandIdentityFor(id);
    final fill = unlocked ? _identity.color : _lockedGrey;

    // Spec-38 P3-4: ellipse-shadow under each island for iso depth.
    //
    // priority MUSS unter der Insel-Grafik liegen (die steht auf -1). Flame
    // zeichnet nach priority aufsteigend, Hoeheres kommt obendrauf — die
    // Reihenfolge der add()-Aufrufe entscheidet also nichts, sobald ein
    // Bauteil eine eigene priority setzt. Ohne die -2 lag die unscharfe
    // schwarze Scheibe UEBER der Insel: sie reicht von 0,50 bis 1,40
    // Durchmesser, verdunkelte damit die untere Haelfte jeder Insel und sah
    // aus wie ein Schatten, der auf die Insel faellt statt unter sie.
    add(
      CircleComponent(
        radius: _diameter * 0.45,
        position: Vector2(_diameter / 2, _diameter * 0.95),
        anchor: Anchor.center,
        priority: -2,
        paint: Paint()
          ..color = const Color(0xFF000000).withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      ),
    );

    // Primitive shape first — deterministic test visual + fallback when
    // the sprite asset cannot resolve.
    final fallback = _IslandShape(
      form: _identity.form,
      fill: fill,
      size: _diameter,
    );
    add(fallback);

    // Glyph above the island art (emoji line). Slightly larger than the
    // old overlay so it stays readable when overlapping the sprite.
    final glyph = unlocked ? _identity.glyph : '🔒';
    add(
      TextComponent(
        text: glyph,
        textRenderer: TextPaint(
          style: FgTypography.pixelLabel.copyWith(
            color: FgColors.onSurface,
            fontSize: 40,
          ),
        ),
        anchor: Anchor.bottomCenter,
        position: Vector2(_diameter / 2, -4),
      ),
    );

    // Label box below the island — black 90 % bg + bold white text + gold
    // border for high contrast against the bright water tile (spec-28).
    add(
      _LabelBox(
        text: label,
        anchorTopCenter: Vector2(_diameter / 2, _diameter + 6),
      ),
    );

    // Spec-43 Stage 3: Decor-Mini-Stack unter Label.
    if (decorGlyphs.isNotEmpty) {
      final shown = decorGlyphs.take(3).toList();
      final text = shown.join(' ');
      add(
        TextComponent(
          text: text,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          anchor: Anchor.topCenter,
          position: Vector2(_diameter / 2, _diameter + 56),
        ),
      );
    }

    if (!_canLoadAssets) return;

    final paint = Paint();
    if (!unlocked) {
      paint.colorFilter = const ColorFilter.matrix(<double>[
        0.33, 0.33, 0.33, 0, 0,
        0.33, 0.33, 0.33, 0, 0,
        0.33, 0.33, 0.33, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    }

    // Spec-39: zuerst versuchen wir das echte Composite-PNG für diese Insel.
    // Wenn vorhanden, ersetzt es ALLES (Basis-Tile + Deko) — die User-
    // Referenz-Vision in einem Sprite. Fallback: Kenney-Tile + Decorations.
    final compositePath = _islandComposite[id];
    if (compositePath != null) {
      try {
        final sprite = await Sprite.load(compositePath);
        add(
          SpriteComponent(
            sprite: sprite,
            size: Vector2.all(_diameter),
            anchor: Anchor.topLeft,
            paint: paint,
            priority: -1,
          ),
        );
        fallback.removeFromParent();
        return;
      } on Object {
        // Composite fehlt → fall through to legacy tile + decorations.
      }
    }

    final assetPath = _formSprite[_identity.form];
    if (assetPath == null) return;
    try {
      final sprite = await Sprite.load(assetPath);
      add(
        SpriteComponent(
          sprite: sprite,
          size: Vector2.all(_diameter),
          anchor: Anchor.topLeft,
          paint: paint,
          priority: -1,
        ),
      );
      fallback.removeFromParent();
      await _loadDecorations(paint);
    } on Object {
      // Keep fallback polygon.
    }
  }

  /// Spec-39: pro Insel-ID Liste von (asset, x-offset, y-offset, size).
  /// Coordinates relativ zum Top-Left des Tiles. Composite-Vision:
  /// jede Insel = Hauptgebäude/Element + 1–3 Deko-Sprites.
  static const Map<String, List<(String, double, double, double)>>
      _decorations = {
    IslandId.sparInsel: [
      ('iso/house.png', 28, 12, 50), // Sparkasse
      ('iso/tree.png', 8, 32, 36),
    ],
    IslandId.etfInsel: [
      ('iso/house.png', 20, 8, 56), // Hochhaus
      ('iso/house.png', 50, 22, 40),
    ],
    IslandId.vulkan: [
      ('iso/rock.png', 28, 14, 52), // Vulkan-Kegel
      ('iso/house.png', 8, 50, 30),
    ],
    IslandId.goldmine: [
      ('iso/rock.png', 16, 12, 48),
      ('iso/house.png', 48, 36, 38), // Förderhaus
    ],
    IslandId.heimathafen: [
      ('iso/house.png', 18, 14, 44),
      ('iso/house.png', 46, 26, 38),
      ('iso/tree.png', 8, 56, 28),
    ],
    IslandId.mischwald: [
      ('iso/tree.png', 8, 14, 36),
      ('iso/tree.png', 32, 22, 40),
      ('iso/tree.png', 56, 14, 36),
      ('iso/house.png', 36, 56, 28),
    ],
    IslandId.aktienArchipel: [
      ('iso/house.png', 24, 14, 52), // Börse-Tempel
      ('iso/tree.png', 56, 36, 28),
    ],
    IslandId.wohnviertel: [
      ('iso/house.png', 8, 18, 38),
      ('iso/house.png', 40, 10, 42),
      ('iso/house.png', 32, 48, 36),
    ],
    IslandId.inflationAtoll: [
      ('iso/rock.png', 26, 14, 44),
      ('iso/rock.png', 50, 36, 32),
    ],
  };

  Future<void> _loadDecorations(Paint paint) async {
    final decos = _decorations[id];
    if (decos == null) return;
    for (final (asset, dx, dy, sz) in decos) {
      try {
        final s = await Sprite.load(asset);
        add(
          SpriteComponent(
            sprite: s,
            size: Vector2.all(sz),
            position: Vector2(dx, dy),
            anchor: Anchor.topLeft,
            paint: paint,
            priority: 0, // above base tile, below glyph
          ),
        );
      } on Object {
        // skip missing assets
      }
    }
  }

  /// Mirror of [Boat._canLoadAssets] — see boat.dart.
  bool get _canLoadAssets {
    try {
      ServicesBinding.instance;
      return true;
    } on Object {
      return false;
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    // Keep circular hit-test for simplicity — visually the shapes vary but
    // the touch target stays the same easy-to-tap circle.
    final center = size / 2;
    return point.distanceTo(center) <= _diameter / 2;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!unlocked) {
      _playLockedShake();
      onLockedTap?.call(this);
      return;
    }
    // Spec-43 Stage 3: 500 ms gedrückt = Long-Press → Editor.
    _longPressFired = false;
    if (onLongPressed != null) {
      _longPressTimer?.cancel();
      _longPressTimer = async.Timer(const Duration(milliseconds: 500), () {
        _longPressFired = true;
        onLongPressed!(this);
      });
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    _longPressTimer?.cancel();
    if (!unlocked || _longPressFired) return;
    onSelected(this);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _longPressTimer?.cancel();
  }

  @override
  void onRemove() {
    _longPressTimer?.cancel();
    super.onRemove();
  }

  void _playLockedShake() {
    // 6px back-and-forth for 250ms, 4 cycles.
    add(
      MoveByEffect(
        Vector2(6, 0),
        EffectController(
          duration: 0.06,
          alternate: true,
          repeatCount: 4,
        ),
      ),
    );
  }
}

/// Black-80% rounded rectangle with white pixel text inside. Sized to fit
/// its label with 4-px padding. Anchor.topCenter on [anchorTopCenter] so
/// callers can place it directly below the sprite.
class _LabelBox extends PositionComponent {
  _LabelBox({
    required this.text,
    required Vector2 anchorTopCenter,
  }) : super(
          position: anchorTopCenter,
          anchor: Anchor.topCenter,
        );

  final String text;

  // spec-43 v2: label noch größer + dickerer Rand für Lesbarkeit.
  static const double _padX = 14;
  static const double _padY = 8;
  static const double _radius = 8;
  static const Color _bg = Color(0xF0000000);
  static const Color _border = FgColors.primary;

  late final TextComponent _text;

  @override
  Future<void> onLoad() async {
    _text = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: FgTypography.pixelLabel.copyWith(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(_padX, _padY),
    );
    add(_text);
    // Size = text size + padding; cached after first layout pass.
    size = Vector2(
      _text.size.x + _padX * 2,
      _text.size.y + _padY * 2,
    );
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(_radius),
    );
    canvas.drawRRect(rect, Paint()..color = _bg);
    canvas.drawRRect(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = _border,
    );
  }
}

/// Custom-painted island silhouette. One paint call per form.
class _IslandShape extends PositionComponent {
  _IslandShape({
    required this.form,
    required this.fill,
    required double size,
  }) : super(size: Vector2.all(size), anchor: Anchor.topLeft);

  final IslandForm form;
  final Color fill;

  static const Color _outline = FgColors.outline;

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = _outline;

    final path = _buildPath();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, stroke);

    // Volcano gets a red molten tip on top of the base shape.
    if (form == IslandForm.volcano) {
      final tip = Path()
        ..moveTo(size.x * 0.40, size.y * 0.30)
        ..lineTo(size.x * 0.60, size.y * 0.30)
        ..lineTo(size.x * 0.50, size.y * 0.10)
        ..close();
      canvas.drawPath(tip, Paint()..color = const Color(0xFFFF4A2E));
      canvas.drawPath(tip, stroke);
    }
  }

  Path _buildPath() {
    final w = size.x;
    final h = size.y;
    final p = Path();
    switch (form) {
      case IslandForm.housePentagon:
        p
          ..moveTo(w * 0.15, h * 0.45)
          ..lineTo(w * 0.50, h * 0.10)
          ..lineTo(w * 0.85, h * 0.45)
          ..lineTo(w * 0.85, h * 0.90)
          ..lineTo(w * 0.15, h * 0.90)
          ..close();
      case IslandForm.hill:
        p
          ..moveTo(w * 0.05, h * 0.85)
          ..quadraticBezierTo(w * 0.50, h * 0.10, w * 0.95, h * 0.85)
          ..close();
      case IslandForm.wave:
        p
          ..moveTo(w * 0.05, h * 0.85)
          ..cubicTo(
            w * 0.20, h * 0.30,
            w * 0.50, h * 0.95,
            w * 0.70, h * 0.45,
          )
          ..cubicTo(
            w * 0.85, h * 0.20,
            w * 0.95, h * 0.55,
            w * 0.95, h * 0.85,
          )
          ..close();
      case IslandForm.flatOval:
        p.addOval(
          Rect.fromLTWH(w * 0.05, h * 0.55, w * 0.90, h * 0.35),
        );
      case IslandForm.trianglePeak:
        p
          ..moveTo(w * 0.10, h * 0.90)
          ..lineTo(w * 0.50, h * 0.10)
          ..lineTo(w * 0.90, h * 0.90)
          ..close();
      case IslandForm.volcano:
        p
          ..moveTo(w * 0.10, h * 0.90)
          ..lineTo(w * 0.35, h * 0.30)
          ..lineTo(w * 0.65, h * 0.30)
          ..lineTo(w * 0.90, h * 0.90)
          ..close();
      case IslandForm.tree:
        final trunk = Rect.fromLTWH(w * 0.45, h * 0.65, w * 0.10, h * 0.25);
        p
          ..moveTo(w * 0.20, h * 0.65)
          ..lineTo(w * 0.50, h * 0.10)
          ..lineTo(w * 0.80, h * 0.65)
          ..close()
          ..addRect(trunk);
    }
    return p;
  }
}
