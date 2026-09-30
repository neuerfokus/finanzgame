import 'package:flutter/painting.dart';

import '../../../core/design_tokens.dart';

/// Schrift und Umbruch der Insel-Beschriftung auf der Monetaria-Karte.
///
/// Die Karte ist Flame, nicht Flutter: ihr Text erbt weder die Schriftfamilie
/// aus dem Theme noch den `TextScaler` aus dem `MaterialApp.builder`. Ohne
/// diese Funktion blieben die Inselnamen in Pixel-Schrift und fester Größe,
/// auch wenn in den Einstellungen „lesbare Schrift" und „Groß" gewählt sind
/// (Geräte-Test Build 194).
///
/// Die Inseln stehen 260 Welt-Pixel auseinander. Damit größere Schrift keine
/// Nachbar-Beschriftung überdeckt, bricht ein zu breiter Name am Bindestrich
/// um („Goldminen-" / „Insel") und wird erst danach, falls nötig, verkleinert.
class IslandLabelLayout {
  const IslandLabelLayout({
    required this.text,
    required this.style,
    required this.width,
    required this.height,
  });

  /// Anzuzeigender Text, ggf. mit Zeilenumbruch.
  final String text;
  final TextStyle style;

  /// Gemessene Textgröße in Welt-Pixeln (ohne Innenabstand der Box).
  final double width;
  final double height;
}

/// Grundgröße der Beschriftung in Welt-Pixeln bei Faktor 1,0.
const double kIslandLabelBaseSize = 38;

/// Breitester erlaubter Text (Inselabstand 260 minus Box-Innenabstand und
/// etwas Luft zum Nachbarn).
const double kIslandLabelMaxWidth = 220;

/// Obergrenze des Schriftfaktors, deckungsgleich mit `kMaxTextScale`.
const double kIslandLabelMaxScale = 1.6;

IslandLabelLayout layoutIslandLabel(
  String label, {
  required bool readableFont,
  required double scale,
  double maxWidth = kIslandLabelMaxWidth,
}) {
  final factor = scale.clamp(1.0, kIslandLabelMaxScale);
  var style = TextStyle(
    // null = Plattformschrift (Roboto auf Android), wie der Fließtext.
    fontFamily: readableFont ? null : FgTypography.pixelFamily,
    fontSize: kIslandLabelBaseSize * factor,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFFFFFFF),
    height: 1.15,
  );

  var text = label;
  var size = _measure(text, style);
  if (size.width > maxWidth) {
    final hyphen = label.indexOf('-');
    if (hyphen > 0 && hyphen < label.length - 1) {
      text = '${label.substring(0, hyphen + 1)}\n${label.substring(hyphen + 1)}';
      size = _measure(text, style);
    }
  }
  if (size.width > maxWidth) {
    style = style.copyWith(
      fontSize: (style.fontSize! * maxWidth / size.width).floorToDouble(),
    );
    size = _measure(text, style);
  }
  return IslandLabelLayout(
    text: text,
    style: style,
    width: size.width,
    height: size.height,
  );
}

Size _measure(String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
  )..layout();
  final size = painter.size;
  painter.dispose();
  return size;
}
