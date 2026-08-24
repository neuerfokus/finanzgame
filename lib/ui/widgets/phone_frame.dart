import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../features/settings/settings_page.dart';
import 'coach_overlay.dart';
import 'home_bar.dart';
import 'status_bar.dart';

/// Pixel-art phone chrome: StatusBar + AppName header + body + HomeBar.
///
/// Spec-15:
/// - Middle `●` defaults to `Navigator.popUntil((r) => r.isFirst)` so any
///   pushed screen can return to the springboard. Pass `onHome: null` from
///   the springboard root to disable it there.
/// - Right `⚙` defaults to pushing the [SettingsPage]; override with
///   [onSettings] if the embedding screen wants different behaviour.
/// - Spec-38 P1-12: Long-press `◀` jumps directly to springboard root.
///   Useful from deeply-nested pages where multiple pops are tedious.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    required this.appName,
    required this.child,
    this.showBack = true,
    this.onBack,
    this.onHome = _kUseDefault,
    this.onSettings,
    this.coachId,
    this.coachTitle,
    this.coachMessage,
    super.key,
  });

  final String appName;
  final Widget child;
  final bool showBack;
  final VoidCallback? onBack;

  /// Pass `null` to disable the middle button (used on the springboard).
  /// Pass a real callback to override. The sentinel `_kUseDefault` means
  /// "use the pop-to-root default".
  final VoidCallback? onHome;
  final VoidCallback? onSettings;

  /// Welle-8 Round 15: optionaler First-Steps-Coach. Wenn coachId + Title
  /// + Message gesetzt sind, zeigt die PhoneFrame ein Hint-Overlay solange
  /// der Spieler ihn nicht weggetippt hat.
  final String? coachId;
  final String? coachTitle;
  final String? coachMessage;

  static void _kUseDefault() {}

  @override
  Widget build(BuildContext context) {
    final effectiveHome = identical(onHome, _kUseDefault)
        ? () => Navigator.of(context).popUntil((r) => r.isFirst)
        : onHome;
    // spec-25: reliable back fallback. If caller passes no [onBack] and the
    // route can be popped, do it; otherwise fall through to popUntil-root.
    final effectiveBack = onBack ??
        () {
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.pop();
          } else {
            nav.popUntil((r) => r.isFirst);
          }
        };
    final effectiveSettings = onSettings ??
        () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsPage(),
              ),
            );

    final scaffold = Scaffold(
      backgroundColor: FgColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBar(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: FgSpacing.l,
                vertical: FgSpacing.s,
              ),
              decoration: const BoxDecoration(
                color: FgColors.backgroundDeep,
                border: Border(
                  bottom: BorderSide(color: FgColors.outline, width: 2),
                ),
              ),
              child: Text(appName, style: FgTypography.pixelLabel),
            ),
            Expanded(child: child),
            HomeBar(
              showBack: showBack,
              onBack: effectiveBack,
              onBackLongPress: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
              onHome: effectiveHome,
              onSettings: effectiveSettings,
            ),
          ],
        ),
      ),
    );
    final cId = coachId;
    final cTitle = coachTitle;
    final cMsg = coachMessage;
    if (cId == null || cTitle == null || cMsg == null) return scaffold;
    return CoachOverlay(
      coachId: cId,
      title: cTitle,
      message: cMsg,
      child: scaffold,
    );
  }
}
