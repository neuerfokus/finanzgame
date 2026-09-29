/// Stufen der Schriftgröße in den Einstellungen (Drift v40).
///
/// Gespeichert wird der Prozentwert ([pct]) in `settings_table.text_scale_pct`.
/// Der Faktor wird in `MaterialApp.builder` mit der System-Schriftgröße
/// multipliziert — wer am Handy schon „groß" eingestellt hat, behält das.
enum TextScaleStufe {
  klein(90, 'Klein'),
  normal(100, 'Normal'),
  gross(120, 'Groß');

  const TextScaleStufe(this.pct, this.label);

  /// Speicherwert in Prozent.
  final int pct;

  /// Beschriftung in den Einstellungen.
  final String label;

  double get faktor => pct / 100.0;

  /// Unbekannte Werte (manipulierter oder künftiger Spielstand) → [normal].
  static TextScaleStufe fromPct(int pct) {
    for (final s in values) {
      if (s.pct == pct) return s;
    }
    return normal;
  }
}

/// Obergrenze für System-Schriftgröße × App-Stufe. Darüber zerbrechen die
/// festen Pixel-Layouts (Statusleiste, Kacheln) — lieber deckeln als
/// abgeschnittene Zeilen.
const double kMaxTextScale = 1.6;
