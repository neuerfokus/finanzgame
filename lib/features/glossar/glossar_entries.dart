/// spec-35 phase N + Welle-8: Glossar mit Quest- + Quiz-Topic-Bindung.
/// Sortiert in der UI: zuerst gelernte Topics, dann offene, dann
/// untopiced. Welle-8 Round 14: Definitionen für 12-Jährige vereinfacht.
class GlossarEntry {
  const GlossarEntry({
    required this.term,
    required this.definition,
    this.example,
    this.topic = '',
  });

  final String term;
  final String definition;
  final String? example;
  /// Welle-8: Topic-Tag aus quiz_topics.dart. Bestimmt Lern-Status.
  final String topic;
}

const List<GlossarEntry> kGlossar = [
  // Übersicht aller Inseln — vorher nur im Hilfe-Dialog des Heimathafens
  // versteckt. Im Glossar ist sie durchsuchbar und wiederfindbar. Namen
  // exakt wie die Marker auf der Karte (kIslandSpecs).
  GlossarEntry(
    term: 'Inseln von Monetaria',
    definition: 'Spar-Insel — Pflanzen anbauen und ernten.\n'
        'ETF-Insel — Aktien-Körbe kaufen (viele Firmen auf einmal).\n'
        'Aktien-Archipel — einzelne Aktien handeln.\n'
        'Sammlerinsel — Bäume pflanzen für tägliches Holz-Einkommen, dazu '
        'Sammlerobjekte (Oldtimer, Gemälde, Briefmarken).\n'
        'Inflations-Atoll — deine Wunschliste; du siehst, wie Preise steigen.\n'
        'Goldminen-Insel — Gold und Silber als Schutz vor Inflation.\n'
        'Vulkan-Insel — Krypto, extrem riskant.\n'
        'Wohnviertel — Häuser kaufen und vermieten.\n'
        'Heimathafen — bringt dich zurück ins Hauptmenü.',
    example: 'Verschlossene Inseln öffnen sich, wenn du genug XP gesammelt '
        'und die passende Quest gelernt hast. Tippe eine verschlossene Insel '
        'an, dann sagt sie dir, was ihr noch fehlt.',
    topic: 'grundlagen',
  ),
  GlossarEntry(
    term: 'Aktie',
    definition:
        'Ein winziger Anteil an einer Firma. Wenn du eine Aktie kaufst, '
        'gehört dir ein kleines Stück. Geht es der Firma gut, wird deine '
        'Aktie mehr wert. Geht es schlecht, weniger.',
    example: '1 Aktie von WeltTec kostet 80 €.',
    topic: 'aktien',
  ),
  GlossarEntry(
    term: 'Bitcoin',
    definition:
        'Die bekannteste Digital-Währung. Es gibt nur 21 Millionen Stück '
        '— nicht mehr. Der Preis schwankt extrem: heute hoch, morgen '
        'tief. Nie alles Geld reinstecken.',
    topic: 'bitcoin',
  ),
  GlossarEntry(
    term: 'Crash',
    definition:
        'Ein Absturz an der Börse. Die Preise fallen plötzlich stark — '
        'oft 20 bis 50 %. Es war noch jeder Crash danach wieder vorbei, '
        'das hat aber manchmal Jahre gedauert.',
    topic: 'psychologie',
  ),
  GlossarEntry(
    term: 'Dispo (Konto-Schulden)',
    definition:
        'Wenn dein Konto im Minus ist, leihst du dir Geld von der Bank. '
        'Dafür zahlst du jeden Tag Zinsen — etwa 10 % im Jahr. Wird '
        'schnell teuer, deshalb möglichst vermeiden.',
    topic: 'schulden',
  ),
  GlossarEntry(
    term: 'Diversifikation (Streuen)',
    definition:
        'Dein Geld auf viele verschiedene Anlagen verteilen. Wie wenn '
        'du dein Mittagessen in mehrere Tüten packst — fällt eine runter, '
        'hast du noch die anderen.',
    topic: 'diversifikation',
  ),
  GlossarEntry(
    term: 'Dividende',
    definition:
        'Wenn eine Firma Gewinn macht, schenkt sie einen Teil davon den '
        'Aktionären. Meist einmal im Jahr. Du musst nichts tun — das Geld '
        'kommt einfach.',
    example: 'Du hast 10 Aktien, jede zahlt 1 € Dividende = 10 € im Jahr.',
    topic: 'dividende',
  ),
  GlossarEntry(
    term: 'Einzelaktie',
    definition:
        'Wenn du nur EINE Firma kaufst, statt viele. Geht die Firma '
        'pleite, ist fast dein ganzes Geld weg. Für Einsteiger gilt: '
        'lieber breit streuen — zum Beispiel über einen ETF.',
    topic: 'einzelaktie',
  ),
  GlossarEntry(
    term: 'ETF',
    definition:
        'Ein Korb mit vielen Aktien gleichzeitig. Mit einem Kauf bist du '
        'an hunderten Firmen beteiligt. Geht eine pleite — egal, die '
        'anderen tragen weiter.',
    example: 'Ein Welt-ETF enthält oft mehr als 1500 Firmen.',
    topic: 'etf',
  ),
  GlossarEntry(
    term: 'Gold / Edelmetalle',
    definition:
        'Ein echter Sachwert. Bringt keine Zinsen + keine Dividende, '
        'behält aber seit Jahrhunderten oft seinen Wert. Wird gerne '
        'gekauft, wenn Geld unsicher wird (Krise, hohe Inflation).',
    example: '1 Gramm Gold ≈ 130 € (Stand 2026).',
    topic: 'edelmetalle',
  ),
  GlossarEntry(
    term: 'Immobilie',
    definition:
        'Ein Haus oder eine Wohnung als Geld-Anlage. Du bekommst Miete '
        'jeden Monat, und der Wert steigt meistens langsam. Aber: sehr '
        'teuer beim Einstieg.',
    topic: 'immobilie',
  ),
  GlossarEntry(
    term: 'Inflation',
    definition:
        'Geld wird mit der Zeit weniger wert. Ein Brot, das heute 3 € '
        'kostet, kostet in 10 Jahren vielleicht 4 €. Wer sein Geld nur '
        'rumliegen lässt, kann sich dann weniger leisten.',
    topic: 'inflation',
  ),
  GlossarEntry(
    term: 'Freistellungsauftrag',
    definition:
        'Ein einmaliger Auftrag an deine Bank: "Die ersten 1000 € Gewinne '
        'aus Aktien/ETFs pro Jahr bitte NICHT versteuern." Sonst zieht '
        'die Bank automatisch 25 % ab — auch wenn du eigentlich nichts '
        'zahlen müsstest. Stell ihn ein, sobald du anfängst zu '
        'investieren.',
    topic: 'steuer',
  ),
  GlossarEntry(
    term: 'Kapitalertragssteuer',
    definition:
        'Die Steuer auf Gewinne aus Geldanlagen. Verkaufst du z. B. eine '
        'Aktie mit Gewinn, zieht der Staat 25 % davon ab. Die ersten '
        '1000 € Gewinn pro Jahr sind aber steuerfrei.',
    topic: 'steuer',
  ),
  GlossarEntry(
    term: 'Steuerklasse',
    definition:
        'Sechs Stufen, die dem Arbeitgeber sagen, wie viel Lohnsteuer er dir '
        'jeden Monat vom Gehalt abzieht. Wichtig: die kannst du dir NICHT '
        'aussuchen — sie ergibt sich aus deinem Leben. Ledig ohne Kind ist '
        'Klasse I, und das gilt für dich, solange du keine Familie gegründet '
        'hast. Klasse III und V gibt es nur für Ehepaare (einer zahlt weniger, '
        'der andere mehr), Klasse II für Alleinerziehende, Klasse VI für einen '
        'zweiten Job nebenher. Am Jahresende rechnet das Finanzamt sowieso '
        'genau nach: zu viel gezahlte Steuer bekommst du zurück, zu wenig '
        'gezahlte musst du nachzahlen. Die Klasse ändert also vor allem, WANN '
        'du zahlst, nicht wie viel am Ende.',
    topic: 'steuer',
  ),
  GlossarEntry(
    term: 'Notgroschen',
    definition:
        'Eine Reserve für plötzliche Ausgaben — kaputtes Handy, '
        'überraschende Reparatur. Faustregel: etwa 3 Monatsausgaben auf '
        'einem Sparkonto. Erst Notgroschen, dann investieren.',
    topic: 'notgroschen',
  ),
  GlossarEntry(
    term: 'Passives Einkommen',
    definition:
        'Geld, das von alleine kommt — ohne dass du dafür arbeiten '
        'musst. Beispiele: Dividenden, Miete, Zinsen.',
    topic: 'dividende',
  ),
  GlossarEntry(
    term: 'Portfolio',
    definition:
        'Die Summe aller deiner Anlagen zusammen — Cash, Sparkonto, '
        'ETFs, Aktien, Krypto, Immobilien. Wie ein Rucksack mit allem, '
        'was du besitzt.',
    topic: 'diversifikation',
  ),
  GlossarEntry(
    term: 'Rendite',
    definition:
        'Wie viel Gewinn deine Anlage gemacht hat, in Prozent. '
        '10 € Gewinn auf 100 € Einsatz = 10 % Rendite.',
    topic: 'grundlagen',
  ),
  GlossarEntry(
    term: 'Risiko',
    definition:
        'Die Gefahr, dass eine Anlage an Wert verliert. Hohes Risiko '
        'heißt: große Chancen, aber auch große Verluste möglich.',
    topic: 'grundlagen',
  ),
  GlossarEntry(
    term: 'Sparen',
    definition:
        'Geld jetzt nicht ausgeben, sondern für später beiseite legen. '
        'Die wichtigste Geld-Gewohnheit — erst Notgroschen, dann Wünsche, '
        'dann langfristig anlegen.',
    topic: 'sparen',
  ),
  GlossarEntry(
    term: 'Sparplan',
    definition:
        'Du legst JEDEN Monat automatisch denselben Betrag in einen '
        'ETF. Mal teurer, mal billiger — gleicht sich aus. Macht dich '
        'unabhängig vom richtigen Einstiegs-Zeitpunkt.',
    example: 'Jeden Monat 25 € in den Welt-ETF.',
    topic: 'sparplan',
  ),
  GlossarEntry(
    term: 'TER (ETF-Kosten)',
    definition:
        'Die jährlichen Kosten eines ETFs in Prozent. Unter 0,30 % gilt '
        'als günstig, über 1,5 % als teuer. Kleine Unterschiede summieren '
        'sich über Jahrzehnte stark.',
    topic: 'etf',
  ),
  GlossarEntry(
    term: 'Volatilität',
    definition:
        'Wie stark der Preis schwankt. Krypto schwankt extrem — heute '
        '+10 %, morgen -15 %. Ein Sparbuch schwankt gar nicht. ETFs '
        'liegen dazwischen.',
    topic: 'volatilitaet',
  ),
  GlossarEntry(
    term: 'Wertsteigerung',
    definition:
        'Wenn eine Anlage mit der Zeit mehr wert wird. Immobilien '
        'steigen z. B. oft 2-3 % pro Jahr im Wert.',
    topic: 'immobilie',
  ),
  GlossarEntry(
    term: 'Wunschliste',
    definition:
        'Sachen, die du dir leisten willst. Im Spiel zeigt das '
        'Inflations-Atoll, wie deine Wünsche mit der Zeit teurer werden.',
    topic: 'inflation',
  ),
  GlossarEntry(
    term: 'Zinseszins',
    definition:
        'Zinsen auf Zinsen. Du bekommst Zinsen auf dein Geld — und im '
        'nächsten Jahr auch auf die schon erhaltenen Zinsen. Wer früh '
        'startet, profitiert am meisten. Zeit ist wichtiger als Betrag.',
    example:
        '100 € mit 5 %/Jahr werden in 40 Jahren etwa 700 € — ohne dass '
        'du einen Cent nachzahlst.',
    topic: 'zinsen',
  ),
  // Welle-8 Round 25: Alltags-Finanzen.
  GlossarEntry(
    term: 'Girokonto',
    definition:
        'Dein Alltagskonto bei der Bank. Hier kommt Geld an (z.B. '
        'Taschengeld oder Lohn), und davon überweist oder bezahlst du. '
        'Zum Sparen nimmt man eher ein Spar- oder Tagesgeldkonto.',
    example: 'Mit der Bankkarte zahlst du vom Girokonto im Laden.',
    topic: 'konto',
  ),
  GlossarEntry(
    term: 'Sparkonto',
    definition:
        'Ein Konto nur zum Geld-Zurücklegen. Es gibt ein paar Zinsen, '
        'aber du nutzt es nicht zum täglichen Bezahlen. So trennst du '
        'Spar-Geld vom Alltags-Geld.',
    topic: 'konto',
  ),
  GlossarEntry(
    term: 'Abo-Falle',
    definition:
        'Ein „Gratis-Probemonat", der sich danach automatisch in ein '
        'kostenpflichtiges Abo verwandelt — weil viele das Kündigen '
        'vergessen. Trag dir das Ende-Datum ein und kündige rechtzeitig, '
        'wenn du es nicht brauchst.',
    example:
        'Spiele-App: 1 Monat gratis, dann 7 €/Monat, bis du kündigst.',
    topic: 'konsum',
  ),
  GlossarEntry(
    term: 'In-Game-Kauf',
    definition:
        'Echtes Geld für virtuelle Sachen im Spiel (Skins, Kisten, '
        'Münzen). „Gratis"-Spiele verdienen genau daran und sind so '
        'gebaut, dass du oft kaufst. Setz dir ein Limit — oder lass es.',
    topic: 'konsum',
  ),
  GlossarEntry(
    term: 'Ratenkauf',
    definition:
        'Du nimmst etwas sofort mit und zahlst es in monatlichen Raten ab '
        '— also mit Geld, das du noch nicht hast. Auch „0 %" bindet dich '
        'lange. Besser: vorher sparen, dann bar kaufen.',
    example:
        'Konsole 600 € in 24 Raten — du zahlst 2 Jahre für etwas, das '
        'schnell an Wert verliert.',
    topic: 'schulden',
  ),
  GlossarEntry(
    term: 'Phishing',
    definition:
        'Betrugs-Maschen per Mail oder Link, die dein Passwort oder deine '
        'Daten klauen wollen. Echte Firmen fragen so nie danach. Nicht '
        'klicken — lieber selbst die offizielle Seite oder App öffnen.',
    example:
        '„Dein Account ist gesperrt, hier Passwort eingeben" = Betrug.',
    topic: 'betrug',
  ),
  GlossarEntry(
    term: 'Fake-Shop',
    definition:
        'Ein gefälschter Online-Shop mit Traumpreisen. Du zahlst und '
        'bekommst nichts oder Schrott. Faustregel: zu gut um wahr zu sein '
        '= meist Betrug. Vorher Bewertungen prüfen.',
    topic: 'betrug',
  ),
  // Optionen-Backlog #4: Alltags-Begriffe passend zu neuen Quests.
  GlossarEntry(
    term: 'Wiederverkaufswert',
    definition:
        'Wie viel du für etwas noch bekommst, wenn du es später verkaufst. '
        'Die meisten Sachen verlieren schnell an Wert — nur wenige bleiben '
        'gefragt.',
    example:
        'Ein neues Handy für 800 € bringt nach 2 Jahren oft nur noch 200 €.',
    topic: 'konsum',
  ),
  GlossarEntry(
    term: 'Gruppenzwang',
    definition:
        'Das Gefühl, etwas kaufen zu müssen, weil alle es haben. Firmen '
        'nutzen das gezielt aus. Du entscheidest selbst, was dir wirklich '
        'wichtig ist.',
    example:
        'Alle haben die neuen SnipeShot-Schuhe — brauchst du sie wirklich, '
        'oder nur, um dazuzugehören?',
    topic: 'psychologie',
  ),
  GlossarEntry(
    term: 'Trinkgeld',
    definition:
        'Ein kleiner freiwilliger Extra-Betrag für guten Service, z. B. im '
        'Restaurant. Üblich sind etwa 5 bis 10 Prozent. Ein Dankeschön, '
        'keine Pflicht.',
    example: 'Das Essen kostet 20 €, du gibst 2 € Trinkgeld = 22 €.',
    topic: 'praxis',
  ),
  GlossarEntry(
    term: 'TAN',
    definition:
        'Ein Einmal-Code, der eine Überweisung am Handy bestätigt. Gib ihn '
        'NIEMALS am Telefon oder über einen Link weiter — echte Banken '
        'fragen so nie danach.',
    example:
        'Ein Anrufer sagt, er sei von der Bank und braucht deine TAN — '
        'auflegen, das ist Betrug.',
    topic: 'betrug',
  ),
  GlossarEntry(
    term: 'Pfand',
    definition:
        'Geld, das du auf eine Flasche oder Dose extra zahlst und beim '
        'Zurückbringen wiederbekommst. Es ist nur geliehen, kein echter '
        'Verlust — wenn du es zurückgibst.',
    example: '0,25 € Pfand pro Dose: 4 Dosen zurück = 1 € im Automaten.',
    topic: 'konsum',
  ),
  GlossarEntry(
    term: 'Gewährleistung',
    definition:
        'Geht etwas Neues kaputt, kannst du es oft reparieren oder '
        'umtauschen lassen. Gewährleistung gibt es 2 Jahre vom Gesetz; '
        'Garantie ist ein freiwilliges Extra vom Hersteller.',
    example:
        'Dein neuer Kopfhörer geht nach 3 Monaten kaputt — der Laden muss '
        'ihn reparieren oder ersetzen.',
    topic: 'konsum',
  ),
  GlossarEntry(
    term: 'Sparquote',
    definition:
        'Der Anteil deines Geldes, den du jeden Monat zur Seite legst statt '
        'auszugeben. Schon 10 Prozent regelmäßig bringen über die Jahre '
        'richtig viel.',
    example: '50 € Taschengeld, davon 5 € gespart = 10 % Sparquote.',
    topic: 'sparen',
  ),
];
