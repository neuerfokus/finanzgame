import 'package:flutter/widgets.dart';

/// Multipliziert die System-Schriftgröße mit der App-Stufe
/// (`TextScaleStufe`: 0,9 / 1,0 / 1,2).
///
/// Bewusst kein `TextScaler.linear(system * faktor)`: Android 14 skaliert
/// nichtlinear (große Schrift wächst weniger stark als kleine). Diese Klasse
/// behält die Kurve des Systems und setzt nur den Faktor obendrauf.
@immutable
class FgTextScaler extends TextScaler {
  const FgTextScaler(this.base, this.faktor);

  final TextScaler base;
  final double faktor;

  @override
  double scale(double fontSize) => base.scale(fontSize) * faktor;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.textScaleFactor * faktor;

  @override
  bool operator ==(Object other) =>
      other is FgTextScaler && other.base == base && other.faktor == faktor;

  @override
  int get hashCode => Object.hash(base, faktor);

  @override
  String toString() => 'FgTextScaler($base × $faktor)';
}

/// System-Skalierung × App-Faktor, gedeckelt auf [max].
TextScaler combineTextScale(TextScaler system, double faktor, double max) {
  final combined = faktor == 1.0 ? system : FgTextScaler(system, faktor);
  return combined.clamp(maxScaleFactor: max);
}
