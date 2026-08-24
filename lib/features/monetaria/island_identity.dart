import 'package:flutter/material.dart';

import '../../game/monetaria/state/monetaria_state.dart';

/// Spec-16: per-island identity — focus, asset class, one-liner, glyph, color.
/// Spec-17: extended with [lesson] — 3-5 sentence longform explanation
/// surfaced via the "Was ist das?" bottom-sheet on the island header.
///
/// Shown as a header panel on each island page and consumed by the Flame
/// [IslandMarker] for color + glyph. Kept as a plain const map so it can
/// be tree-shaken into release builds with zero cost.
final class IslandIdentity {
  const IslandIdentity({
    required this.label,
    required this.focus,
    required this.assetClass,
    required this.oneLiner,
    required this.lesson,
    required this.glyph,
    required this.color,
    required this.form,
  });

  final String label;
  final String focus;
  final String assetClass;
  final String oneLiner;

  /// Spec-17: longform (3-5 sentences) finance lesson for the island.
  /// Displayed in a bottom-sheet via the "Was ist das?" button.
  final String lesson;
  final String glyph;
  final Color color;
  final IslandForm form;
}

/// Renderable shape primitives for the Monetaria map.
///
/// Each value maps to a custom-painted polygon in `IslandMarker`.
enum IslandForm {
  housePentagon,
  hill,
  wave,
  flatOval,
  trianglePeak,
  volcano,
  tree,
}

const Map<String, IslandIdentity> kIslandIdentities = {
  IslandId.heimathafen: IslandIdentity(
    label: 'Heimathafen',
    focus: 'Tutorial / Hilfe',
    assetClass: '—',
    oneLiner: 'Dein Startpunkt — Hilfe, Quests und der Kapitän.',
    lesson:
        'Hier startest du deine Reise durch Monetaria. Der Kapitän erklärt '
        'dir Schritt für Schritt, wie Geld funktioniert: sparen, anlegen, '
        'mit Risiko umgehen. Du musst nichts auswendig lernen — du probierst '
        'aus, machst Fehler und siehst direkt, was passiert. Jede Insel zeigt '
        'dir ein anderes Stück echter Finanzwelt.',
    glyph: '🏠',
    color: Color(0xFFB07A4A),
    form: IslandForm.housePentagon,
  ),
  IslandId.sparInsel: IslandIdentity(
    label: 'Spar-Insel',
    focus: 'Sparen + Geduld',
    assetClass: 'Pflanzen',
    oneLiner: 'Pflanzen wachsen über Tage — geduldig sein lohnt sich.',
    lesson:
        'Sparen heißt: Du legst Geld zur Seite, statt es sofort auszugeben. '
        'Auf der Spar-Insel pflanzt du Samen, die über mehrere Tage wachsen — '
        'genau wie echtes Geld auf einem Sparkonto durch Zinsen wächst. '
        'Je länger du wartest, desto größer die Ernte. Wer zu früh erntet, '
        'bekommt weniger. Geduld ist der wichtigste Trick beim Sparen.',
    glyph: '🌱',
    color: Color(0xFF4ED96A),
    form: IslandForm.hill,
  ),
  IslandId.etfInsel: IslandIdentity(
    label: 'ETF-Insel',
    focus: 'Diversifikation + Volatilität',
    assetClass: 'ETFs',
    oneLiner: 'Welt-Korb gegen Tech-Korb — Streuung dämpft Wellen.',
    lesson:
        'Ein ETF ist ein Korb aus vielen Aktien. Statt eine einzelne Firma '
        'zu wählen, kaufst du einen Anteil an vielen auf einmal. Vorteil: '
        'weniger Risiko, weil ein Verlust einer Firma durch andere '
        'ausgeglichen wird. Der Preis schwankt mit dem Wetter — gutes Wetter '
        'gleich Aufschwung, Sturm gleich Kursrutsch. Wer breit streut, '
        'schläft ruhiger.',
    glyph: '📈',
    color: Color(0xFF5BC0EB),
    form: IslandForm.wave,
  ),
  IslandId.inflationAtoll: IslandIdentity(
    label: 'Inflations-Atoll',
    focus: 'Inflation + Kaufkraft',
    assetClass: 'Wunschartikel',
    oneLiner: 'Preise driften — heute günstig, morgen teurer.',
    lesson:
        'Inflation bedeutet: Dinge werden mit der Zeit teurer. Ein Brot '
        'kostet heute vielleicht 3 €, in zehn Jahren 4 €. Dein Geld verliert '
        'an Kaufkraft, wenn es nur herumliegt. Deshalb reicht reines Sparen '
        'oft nicht — du brauchst Anlagen, die mindestens so stark wachsen '
        'wie die Inflation. Auf dem Atoll siehst du, wie deine Wunschliste '
        'jeden Tag etwas teurer wird.',
    glyph: '💰',
    color: Color(0xFFE6C56A),
    form: IslandForm.flatOval,
  ),
  IslandId.aktienArchipel: IslandIdentity(
    label: 'Aktien-Archipel',
    focus: 'Einzelaktien-Risiko',
    assetClass: 'Aktien',
    oneLiner: 'Einzelne Firmen — hohe Chancen, hohe Risiken.',
    lesson:
        'Eine Aktie ist ein winziger Anteil an einer einzelnen Firma. Läuft '
        'die Firma gut, gewinnt deine Aktie an Wert — geht es ihr schlecht, '
        'verliert sie. Das nennt man Konzentrationsrisiko: Du setzt viel auf '
        'wenige Karten. Im Spiel sind alle Firmen erfunden (SnipeShot AG, '
        'DropTok Inc.), aber die Mechanik ist echt. Einzelaktien können mehr '
        'Rendite bringen als ETFs — kosten dich aber auch öfter Nerven.',
    glyph: '📊',
    color: Color(0xFFE05A5A),
    form: IslandForm.trianglePeak,
  ),
  IslandId.vulkan: IslandIdentity(
    label: 'Vulkan-Insel',
    focus: 'Crash-Lehre + Krypto-Volatilität',
    assetClass: 'Krypto',
    oneLiner: 'Krypto-Coins am Vulkan — Eruption gleich Crash, doppelt heftig.',
    lesson:
        'Zwei Klassen am Vulkan: Bitcoin (volatil aber etabliert) und das '
        'Krypto-Casino (Pump-and-Dump-Müll). Bitcoin schwankt mal ±4% am '
        'Tag, Krypto-Casino bis ±12% — beim Crash zusätzlich 50-80% auf '
        'einmal. Die wichtigste Regel: investiere nie mehr, als du bereit '
        'bist komplett zu verlieren. Wer in Panik verkauft, lockt den '
        'Verlust ein — wer durchhält, sieht manchmal nach Monaten die '
        'Erholung. Der Vulkan zeigt dir, wie sich das anfühlt.',
    glyph: '₿',
    color: Color(0xFF8B2E2E),
    form: IslandForm.volcano,
  ),
  IslandId.goldmine: IslandIdentity(
    label: 'Goldminen-Insel',
    focus: 'Edelmetalle + Inflations-Hedge',
    assetClass: 'Gold / Silber / Platin',
    oneLiner: 'Sicherer Hafen — wächst leise mit der Inflation mit.',
    lesson:
        'Gold und Silber halten ihren Wert über Zeit. Wenn Geld weniger wert '
        'wird (Inflation), steigen ihre Preise — Gold etwas stärker, Silber '
        'etwas schwächer. Sie schwanken pro Tag weniger als Aktien oder '
        'Krypto, wachsen dafür aber auch langsamer. Klassischer „sicherer '
        'Hafen": wenn die Märkte crashen, bleiben Edelmetalle stabil. '
        'Deshalb mischen viele Anleger einen kleinen Gold-Anteil ins '
        'Portfolio.',
    glyph: '🪙',
    color: Color(0xFFE5B847),
    form: IslandForm.trianglePeak,
  ),
  IslandId.mischwald: IslandIdentity(
    label: 'Sammlerinsel',
    focus: 'Sammlerobjekte + Sachwerte',
    assetClass: 'Sachwerte',
    oneLiner: 'Oldtimer, Diamanten, Gemälde — wachsen langsam aber stabil.',
    lesson:
        'Sachwerte wie Oldtimer, Diamanten, Gemälde oder Briefmarken sind '
        'Real-Assets. Sie wachsen jährlich um 3–8 % im Wert. Vorteile: '
        'inflationsgeschützt, kein Crash-Risiko. Nachteile: niedrige '
        'Liquidität (Verkauf kostet 10 % Händlerspread) und hohe Einstiegs-'
        'preise. Klassiker für reiche Sammler — nicht zum Spekulieren.',
    glyph: '🌲',
    color: Color(0xFF808890),
    form: IslandForm.tree,
  ),
  IslandId.wohnviertel: IslandIdentity(
    label: 'Wohnviertel',
    focus: 'Immobilien + passive Mieteinnahmen',
    assetClass: 'Immobilien',
    oneLiner: 'Kaufe Immobilien — kassiere monatlich Miete.',
    lesson:
        'Immobilien sind eine eigene Anlageklasse: einmal kaufen, dann '
        'monatlich Miete kassieren („passives Einkommen"). Zusätzlich '
        'steigt der Wert über die Jahre langsam an (Wertsteigerung). '
        'Nachteile: sehr teuer beim Einstieg und schwer zu verkaufen, '
        'wenn man Geld braucht. Klassisch erst dann sinnvoll, wenn ein '
        'Notgroschen + ETF-Portfolio bereits stehen.',
    glyph: '🏠',
    color: Color(0xFFA0522D),
    form: IslandForm.housePentagon,
  ),
};

/// Convenience accessor with a defensive fallback for unknown ids.
IslandIdentity islandIdentityFor(String id) =>
    kIslandIdentities[id] ??
    const IslandIdentity(
      label: '?',
      focus: '—',
      assetClass: '—',
      oneLiner: '—',
      lesson: '—',
      glyph: '❓',
      color: Color(0xFF808890),
      form: IslandForm.hill,
    );
