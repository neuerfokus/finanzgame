import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/design_tokens.dart';

/// 56×56 phone-springboard icon with pixel border + drop shadow.
///
/// Tap → 100ms scale-pop (1.0 → 0.95 → 1.0) via flutter_animate.
class AppIcon extends StatefulWidget {
  const AppIcon({
    required this.glyph,
    required this.label,
    required this.background,
    this.onTap,
    this.enabled = true,
    this.badge = false,
    super.key,
  });

  final String glyph;
  final String label;
  final Color background;
  final VoidCallback? onTap;
  final bool enabled;

  /// Spec-17: optional red-dot badge in the top-right corner of the tile.
  /// Used by Springboard to signal "Frage des Tages noch offen".
  final bool badge;

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (!widget.enabled || widget.onTap == null) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final iconBox = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: widget.enabled ? widget.background : FgColors.neutral,
        borderRadius: BorderRadius.circular(FgRadius.tile),
        border: Border.all(color: FgColors.outline, width: 2),
        boxShadow: const [
          BoxShadow(color: FgColors.shadow, offset: Offset(3, 3)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(widget.glyph, style: const TextStyle(fontSize: 26)),
    );

    final tile = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            iconBox,
            if (widget.badge)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: FgColors.alert,
                    shape: BoxShape.circle,
                    border: Border.all(color: FgColors.outline, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: FgSpacing.xs),
        Text(widget.label, style: FgTypography.pixelLabel),
      ],
    );

    // Barrierefreiheit: Button-Rolle + Label (Glyph ist nur ein Emoji →
    // ohne Label liest TalkBack den Emoji-Namen statt z.B. „Bank").
    // Badge-Hinweis mitsprechen, damit „Frage offen" hörbar ist.
    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.badge ? '${widget.label}, neue Aufgabe' : widget.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.enabled ? widget.onTap : null,
          child: tile
              .animate(target: _pressed ? 1.0 : 0.0)
              .scaleXY(
                begin: 1.0,
                end: 0.95,
                duration: 100.ms,
                curve: Curves.easeOutBack,
              ),
        ),
      ),
    );
  }
}
