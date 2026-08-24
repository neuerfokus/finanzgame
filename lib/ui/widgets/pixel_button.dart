import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/design_tokens.dart';

/// Pixel-art button with thick outline + drop shadow.
///
/// Tap → 100ms scale-pop (1.0 → 0.95 → 1.0) via flutter_animate.
class PixelButton extends StatefulWidget {
  const PixelButton({
    required this.label,
    required this.onPressed,
    this.background = FgColors.primary,
    this.foreground = FgColors.onPrimary,
    this.icon,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final IconData? icon;

  /// Barrierefreiheit: gesprochenes Label für TalkBack. Nötig wenn [label]
  /// nur ein Emoji ist (z.B. '⏩', '🔄') — sonst liest der Screenreader den
  /// rohen Emoji-Namen vor. Default = [label].
  final String? semanticLabel;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

/// WCAG-Kontrast-Helfer: liefert eine lesbare Vordergrundfarbe für [bg],
/// falls [wanted] zu schwach kontrastiert (Schwelle 3:1 — Button-Text ist
/// large, ≥18.66px). Heilt zentral alle Aufrufer, die versehentlich helle
/// Schrift auf hellen Buttons setzen (z.B. onSurface auf success/info).
Color readableForeground(Color bg, Color wanted) {
  double lum(Color c) => c.computeLuminance();
  double ratio(Color a, Color b) {
    final l1 = lum(a), l2 = lum(b);
    final hi = l1 > l2 ? l1 : l2;
    final lo = l1 > l2 ? l2 : l1;
    return (hi + 0.05) / (lo + 0.05);
  }

  if (ratio(wanted, bg) >= 3.0) return wanted;
  // Schwacher Kontrast → Schwarz oder Weiß, je nachdem was besser passt.
  return ratio(Colors.black, bg) >= ratio(Colors.white, bg)
      ? Colors.black
      : Colors.white;
}

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final bg = enabled ? widget.background : FgColors.neutral;
    final fg = readableForeground(bg, widget.foreground);

    final core = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FgSpacing.l,
        vertical: FgSpacing.m,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: FgColors.outline, width: 3),
        boxShadow: const [
          BoxShadow(color: FgColors.shadow, offset: Offset(3, 3)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: fg, size: 16),
            const SizedBox(width: FgSpacing.s),
          ],
          // Welle-8: Flexible damit langer Label-Text umbricht statt
          // rechts rauszuragen (Quest-Antworten waren betroffen).
          Flexible(
            child: Text(
              widget.label,
              style: FgTypography.bodyL.copyWith(color: fg),
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    // Barrierefreiheit: explizite Button-Rolle + sprechendes Label
    // (sonst liest TalkBack rohe Emoji-Namen). Inneren Text aus dem
    // Semantics-Baum ausschließen, damit nichts doppelt vorgelesen wird.
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel ?? widget.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onPressed,
          child: core
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
