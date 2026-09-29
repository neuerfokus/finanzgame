import 'package:flutter/material.dart';

import 'design_tokens.dart';

/// App-Theme abhängig von der Lesbarkeits-Einstellung (Drift v40).
///
/// Der zentrale Hebel: `FgTypography.bodyL/M/S` setzen KEINE Schriftfamilie
/// und erben sie deshalb vom [DefaultTextStyle], den Material aus
/// `textTheme.bodyMedium` ableitet. Bis v39 stand hier global
/// `fontFamily: KenneyPixel` — damit war jeder Fließtext Pixel-Schrift, und
/// genau das fanden Tester anstrengend zu lesen.
///
/// - [readableFont] true: Fließtext-Rollen (body*, label* → Buttons, Listen,
///   Dialog-Inhalte, Eingaben) behalten die Systemschrift (Roboto auf
///   Android). Überschriften-Rollen (display*, headline*, title* → AppBar,
///   Dialog-Titel, Tabs) bleiben Pixel.
/// - [readableFont] false: Pixel überall, der bisherige Look.
///
/// HUD, Geldbeträge und `FgTypography.display*`/`pixelLabel` setzen die
/// Pixel-Familie selbst und sind von der Einstellung unabhängig.
ThemeData buildFgTheme({required bool readableFont}) {
  final base = ThemeData.dark();
  final colored = base.textTheme.apply(
    bodyColor: FgColors.onSurface,
    displayColor: FgColors.onSurface,
  );
  final TextTheme textTheme;
  if (readableFont) {
    TextStyle? px(TextStyle? s) =>
        s?.copyWith(fontFamily: FgTypography.pixelFamily);
    textTheme = colored.copyWith(
      displayLarge: px(colored.displayLarge),
      displayMedium: px(colored.displayMedium),
      displaySmall: px(colored.displaySmall),
      headlineLarge: px(colored.headlineLarge),
      headlineMedium: px(colored.headlineMedium),
      headlineSmall: px(colored.headlineSmall),
      titleLarge: px(colored.titleLarge),
      titleMedium: px(colored.titleMedium),
      titleSmall: px(colored.titleSmall),
    );
  } else {
    textTheme = colored.apply(fontFamily: FgTypography.pixelFamily);
  }
  return base.copyWith(
    scaffoldBackgroundColor: FgColors.backgroundDeep,
    colorScheme: const ColorScheme.dark(
      primary: FgColors.primary,
      secondary: FgColors.secondary,
      surface: FgColors.backgroundElevated,
    ),
    textTheme: textTheme,
  );
}
