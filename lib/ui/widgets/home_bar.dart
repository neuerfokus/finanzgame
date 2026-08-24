import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Bottom navigation bar with pixel glyphs ◀ ● ⚙.
///
/// Router-agnostic: pass [onBack], [onHome] and [onSettings] callbacks.
/// Spec-15: middle button is "Home" (pop to root); right button is the
/// "Settings" shortcut and is always enabled.
class HomeBar extends StatelessWidget {
  const HomeBar({
    this.showBack = true,
    this.onBack,
    this.onBackLongPress,
    this.onHome,
    this.onSettings,
    super.key,
  });

  final bool showBack;
  final VoidCallback? onBack;

  /// Spec-38 P1-12: Long-press jumps to springboard root (skip many pops).
  final VoidCallback? onBackLongPress;

  /// Tap target for the middle `●` glyph. When `null` the button renders
  /// disabled (used on the springboard root where there is nowhere to go
  /// home to).
  final VoidCallback? onHome;

  /// Tap target for the right `⚙` glyph. Always enabled in the UI;
  /// callers wire this to push the [SettingsPage] from anywhere.
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: FgColors.backgroundDeep,
        border: Border(top: BorderSide(color: FgColors.outline, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: FgSpacing.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Glyph(
            char: '◀',
            label: 'Zurück',
            enabled: showBack,
            onTap: onBack,
            onLongPress: onBackLongPress,
          ),
          _Glyph(
              char: '●',
              label: 'Startseite',
              enabled: onHome != null,
              onTap: onHome),
          _Glyph(
              char: '⚙',
              label: 'Einstellungen',
              enabled: true,
              onTap: onSettings),
        ],
      ),
    );
  }
}

class _Glyph extends StatelessWidget {
  const _Glyph({
    required this.char,
    required this.label,
    required this.enabled,
    this.onTap,
    this.onLongPress,
  });
  final String char;
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? FgColors.onSurface : FgColors.neutral;
    // Barrierefreiheit: Button-Rolle + sprechendes Label (sonst liest
    // TalkBack „nach links zeigendes Dreieck"). Tap-Target ≥ 48dp.
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? onTap : null,
          onLongPress: enabled ? onLongPress : null,
          child: Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: FgSpacing.l),
            alignment: Alignment.center,
            child: Text(
              char,
              style: FgTypography.bodyL.copyWith(color: color, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
