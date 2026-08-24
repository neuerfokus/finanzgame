import 'package:flutter/material.dart';

/// Design tokens for Finanzgame UI.
///
/// All widgets reference these constants — never hardcode colors, spacing or
/// radii directly.
abstract final class FgColors {
  static const backgroundDeep = Color(0xFF0E0B1A);
  static const backgroundPrimary = Color(0xFF1A1530);
  static const backgroundElevated = Color(0xFF2A1F4A);
  static const primary = Color(0xFFFFC107);
  static const onPrimary = Color(0xFF000000);
  static const secondary = Color(0xFF7B61FF);
  static const success = Color(0xFF4ED96A);
  static const info = Color(0xFF5BC0EB);
  static const alert = Color(0xFFFF6B9D);
  static const neutral = Color(0xFF888888);

  /// Barrierefreiheit: gedämpfter, aber WCAG-AA-tauglicher Grauton für
  /// Sekundär-/Hilfetext auf dunklen Panels (#888 neutral fiel mit 4.25:1
  /// knapp durch — dieser liegt bei ~6:1 auf backgroundElevated).
  static const onSurfaceMuted = Color(0xFFB4B4B4);
  static const onSurface = Color(0xFFE8E8E8);
  static const outline = Color(0xFF000000);
  static const shadow = Color(0xFF000000);
}

abstract final class FgSpacing {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
}

abstract final class FgRadius {
  static const tight = 4.0;
  static const card = 8.0;
  static const tile = 14.0;
}

abstract final class FgTypography {
  /// Pixel font family. Used for displays, numbers, and pixel-style labels.
  /// Asset declared in pubspec.yaml. Falls back to platform default if
  /// asset missing.
  static const String pixelFamily = 'KenneyPixel';

  /// Body font family (spec-32). Both Kenney sans-serifs are all-caps
  /// display fonts — unreadable for paragraphs. Fall back to the platform
  /// default (Roboto on Android) so mixed-case body text is legible.
  static const String? bodyFamily = null;

  // Spec-43 follow-up: Schrift weiter bumpen (Sohn-Feedback "noch zu klein").
  // display 30→34, displayLarge 48→54, pixelLabel 18→22.
  // body 20/18/15 → 23/21/17.
  static const display = TextStyle(
    fontFamily: pixelFamily,
    fontSize: 34,
    color: FgColors.primary,
    height: 1.1,
  );

  static const displayLarge = TextStyle(
    fontFamily: pixelFamily,
    fontSize: 54,
    color: FgColors.primary,
    height: 1.0,
  );

  static const pixelLabel = TextStyle(
    fontFamily: pixelFamily,
    fontSize: 22,
    color: FgColors.onSurface,
    height: 1.2,
  );

  static const bodyL = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 23,
    color: FgColors.onSurface,
    height: 1.4,
  );

  static const bodyM = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 21,
    color: FgColors.onSurface,
    height: 1.4,
  );

  static const bodyS = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 17,
    color: FgColors.onSurfaceMuted,
    height: 1.3,
  );
}

/// Chart color convention (spec-26 / spec-38): up = pure green, down = pure
/// red. Spec-38 P0-5: alert (pink) was too ambiguous in sleep-dialog charts;
/// switched to saturated red so direction is unmistakable.
abstract final class FgChart {
  static const up = Color(0xFF22C55E); // pure green
  static const down = Color(0xFFE53935); // pure red
  static const neutral = FgColors.neutral;
}
