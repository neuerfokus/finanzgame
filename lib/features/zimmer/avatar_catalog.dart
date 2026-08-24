/// Spec-41 A: Avatar-Glyph-Katalog für Avatar-Shop.
class AvatarSpec {
  const AvatarSpec({
    required this.glyph,
    required this.xpCost,
    required this.minLevel,
    this.name = '',
  });

  final String glyph;
  final int xpCost;
  final int minLevel;
  final String name;

  bool isFreeDefault() => glyph == '🧒';
}

/// **Warum hier weibliche Figuren stehen (2026-08):** der Katalog hatte 18
/// Einträge — zwei davon explizit männlich („Blonder Junge", „Junge braun"),
/// den Rest Tiere und Fantasy. Keine einzige weibliche Figur. CLAUDE.md
/// versprach zwar „in Settings auf neutral/weiblich umstellbar", diese
/// Einstellung existierte aber nie.
///
/// Ein Mädchen konnte das Spiel also spielen, fand aber keine Figur, die wie
/// sie aussieht. Für eine App, die Finanzwissen vermitteln soll, ist das ein
/// überflüssiges Signal, wer hier gemeint ist — gerade weil Geldanlage real
/// ein Feld ist, aus dem Frauen sich häufiger heraushalten.
///
/// Bewusst KEINE Geschlechts-Einstellung, sondern einfach mehr Auswahl: die
/// weiblichen Figuren stehen zu denselben Kosten neben ihren männlichen
/// Pendants (👧 neben 👦, 🦸‍♀️ neben 🦸, 🧙‍♀️ neben 🧙). Niemand zahlt mehr
/// für seine Figur, und niemand muss vorher etwas über sich angeben.
abstract final class AvatarCatalog {
  static const all = <AvatarSpec>[
    AvatarSpec(glyph: '🧒', xpCost: 0, minLevel: 0, name: 'Default'),
    AvatarSpec(glyph: '👱', xpCost: 0, minLevel: 0, name: 'Blonder Junge'),
    AvatarSpec(glyph: '👱‍♀️', xpCost: 0, minLevel: 0, name: 'Blondes Mädchen'),
    AvatarSpec(glyph: '👦', xpCost: 50, minLevel: 0, name: 'Junge braun'),
    AvatarSpec(glyph: '👧', xpCost: 50, minLevel: 0, name: 'Mädchen braun'),
    AvatarSpec(glyph: '🐱', xpCost: 100, minLevel: 0, name: 'Kätzchen'),
    AvatarSpec(glyph: '🦸', xpCost: 200, minLevel: 0, name: 'Superheld'),
    AvatarSpec(glyph: '🦸‍♀️', xpCost: 200, minLevel: 0, name: 'Superheldin'),
    AvatarSpec(glyph: '🦊', xpCost: 300, minLevel: 0, name: 'Fuchs'),
    AvatarSpec(glyph: '🧙', xpCost: 400, minLevel: 0, name: 'Zauberer'),
    AvatarSpec(glyph: '🧙‍♀️', xpCost: 400, minLevel: 0, name: 'Zauberin'),
    AvatarSpec(glyph: '🐼', xpCost: 500, minLevel: 0, name: 'Panda'),
    AvatarSpec(glyph: '🥷', xpCost: 600, minLevel: 0, name: 'Ninja'),
    AvatarSpec(glyph: '🐧', xpCost: 700, minLevel: 0, name: 'Pinguin'),
    AvatarSpec(glyph: '🤖', xpCost: 800, minLevel: 0, name: 'Robot'),
    AvatarSpec(glyph: '🐸', xpCost: 900, minLevel: 10, name: 'Frosch'),
    AvatarSpec(glyph: '👾', xpCost: 1000, minLevel: 10, name: 'Alien'),
    AvatarSpec(glyph: '🐯', xpCost: 1200, minLevel: 20, name: 'Tiger'),
    // v29: hoehere Stufen passen zum neuen 60-Level-System.
    AvatarSpec(glyph: '🦁', xpCost: 2000, minLevel: 30, name: 'Loewe'),
    AvatarSpec(glyph: '🦉', xpCost: 3000, minLevel: 40, name: 'Eule'),
    AvatarSpec(glyph: '🐉', xpCost: 5000, minLevel: 50, name: 'Drache'),
    AvatarSpec(glyph: '🦄', xpCost: 8000, minLevel: 60, name: 'Einhorn'),
  ];

  static AvatarSpec? byGlyph(String g) {
    for (final s in all) {
      if (s.glyph == g) return s;
    }
    return null;
  }
}
