import 'quiz_question.dart';
import 'quiz_topics.dart';

/// Spec-17 + Spec-45 Bucket I: deterministic, child-appropriate finance
/// quiz pool with topic-tags + difficulty tier.
///
/// All brands are fictional (SnipeShot AG, DropTok Inc) per the project
/// hard-rule. Questions cover: sparen, ETF, inflation, crash, single-stock
/// risk, diversification, compound interest, dividend, market cap.
///
/// Selection priority (DailyQuizState.questionFor):
/// 1. Spaced-Repetition Queue (E4 review after quest-complete)
/// 2. Filter by learnedTopics ∩ tiersFor(dayIndex)
/// 3. Fallback: tiersFor(dayIndex) only
const List<QuizQuestion> kQuizPool = [
  // 1. Sparen — basics
  QuizQuestion.multipleChoice(
    text: 'Was bedeutet "sparen"?',
    options: [
      'Geld sofort komplett ausgeben',
      'Geld für später zur Seite legen',
      'Geld verstecken und vergessen',
      'Geld nur für Süßigkeiten nutzen',
    ],
    correctIndex: 1,
    explanation:
        'Sparen heißt: Geld jetzt nicht ausgeben, damit du es später für '
        'wichtige Dinge oder größere Wünsche hast.',
    topic: QuizTopic.sparen,
    tier: QuizTier.easy,
  ),
  // 2. Zinseszins
  QuizQuestion.multipleChoice(
    text:
        'Du legst 100 € an und bekommst jedes Jahr 5% Zinsen — auch auf die '
        'schon erhaltenen Zinsen. Wie nennt man das?',
    options: [
      'Inflation',
      'Dividende',
      'Zinseszins',
      'Kursgewinn',
    ],
    correctIndex: 2,
    explanation:
        'Zinseszins: Du bekommst Zinsen auf dein Geld UND auf die Zinsen, '
        'die du schon hast. Über viele Jahre wächst das Geld wie ein Baum.',
    topic: QuizTopic.zinsen,
    tier: QuizTier.easy,
  ),
  // 3. ETF — basics
  QuizQuestion.multipleChoice(
    text: 'Was ist ein ETF?',
    options: [
      'Ein einzelnes Spar-Konto',
      'Ein Korb aus vielen Aktien auf einmal',
      'Eine Kryptowährung',
      'Eine Versicherung',
    ],
    correctIndex: 1,
    explanation:
        'Ein ETF (Exchange Traded Fund) ist ein Korb aus vielen Aktien. '
        'Du kaufst mit einem Anteil gleich ganz viele Firmen mit.',
    topic: QuizTopic.etf,
    tier: QuizTier.easy,
  ),
  // 4. Inflation
  QuizQuestion.multipleChoice(
    text:
        'Ein Brot kostet heute 3 €. In 10 Jahren kostet es 4 €. Was ist '
        'passiert?',
    options: [
      'Das Brot ist besser geworden',
      'Inflation — Geld verliert Kaufkraft',
      'Die Bäckerei wurde reicher',
      'Die Sonne war schlechter',
    ],
    correctIndex: 1,
    explanation:
        'Inflation bedeutet: Preise steigen mit der Zeit. Dein Geld kann '
        'sich weniger leisten, wenn es nur herumliegt.',
    topic: QuizTopic.inflation,
    tier: QuizTier.easy,
  ),
  // 5. Crash — verhalten
  QuizQuestion.multipleChoice(
    text:
        'Die Börse crasht — alle Aktien fallen um 30%. Was machen langfristige '
        'Anleger meistens?',
    options: [
      'Sofort alles verkaufen, bevor noch mehr Verlust kommt',
      'In Panik geraten und nie wieder anlegen',
      'Ruhig bleiben und durchhalten',
      'Alles in Bargeld umwandeln und verstecken',
    ],
    correctIndex: 2,
    explanation:
        'Wer ruhig bleibt, sieht meistens nach Monaten oder Jahren die '
        'Erholung. Wer panisch verkauft, hat den Verlust fest eingebucht.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.mid,
  ),
  // 6. Einzelaktie-Risiko
  QuizQuestion.multipleChoice(
    text:
        'Du steckst dein ganzes Geld in EINE Firma — SnipeShot AG. Die Firma '
        'geht pleite. Was passiert?',
    options: [
      'Du verlierst nichts, weil es nur Spielgeld war',
      'Du verlierst fast dein ganzes Geld',
      'Die Bank ersetzt deinen Verlust',
      'Andere Aktien gleichen den Schaden aus',
    ],
    correctIndex: 1,
    explanation:
        'Konzentrationsrisiko: Wenn du auf eine einzige Firma setzt, '
        'verlierst du fast alles, wenn diese Firma fällt. Deshalb streut man.',
    topic: QuizTopic.einzelaktie,
    tier: QuizTier.mid,
  ),
  // 7. Diversifikation
  QuizQuestion.multipleChoice(
    text: 'Warum sagt man: "Lege nicht alle Eier in einen Korb"?',
    options: [
      'Weil Eier zerbrechlich sind',
      'Weil ein Korb nicht so viel trägt',
      'Weil ein Verlust beim Streuen weniger weh tut',
      'Damit die Eier frischer bleiben',
    ],
    correctIndex: 2,
    explanation:
        'Bei Geld heißt das: streue auf viele Anlagen. Geht eine schief, '
        'sind die anderen noch da. Das nennt man Diversifikation.',
    topic: QuizTopic.diversifikation,
    tier: QuizTier.easy,
  ),
  // 8. Markt-Schwankung
  QuizQuestion.multipleChoice(
    text: 'Was bedeutet "Volatilität" bei einer Aktie?',
    options: [
      'Wie alt die Firma ist',
      'Wie stark der Kurs schwankt',
      'Wie viel Dividende sie zahlt',
      'Wie viele Mitarbeiter sie hat',
    ],
    correctIndex: 1,
    explanation:
        'Volatilität ist das Auf und Ab des Kurses. Hohe Volatilität '
        'gleich starke Schwankungen gleich höheres Risiko.',
    topic: QuizTopic.volatilitaet,
    tier: QuizTier.mid,
  ),
  // 9. Dividende
  QuizQuestion.multipleChoice(
    text:
        'Eine Firma macht Gewinn und schüttet einen Teil an die Aktionäre '
        'aus. Wie heißt das?',
    options: [
      'Zinseszins',
      'Inflation',
      'Dividende',
      'Steuer',
    ],
    correctIndex: 2,
    explanation:
        'Dividende: Anteil am Gewinn, den eine Firma an ihre Aktionäre '
        'auszahlt — meist einmal im Jahr.',
    topic: QuizTopic.dividende,
    tier: QuizTier.mid,
  ),
  // 10. Marktkapitalisierung
  QuizQuestion.multipleChoice(
    text:
        'Was bedeutet "Marktkapitalisierung" einer Firma — kurz '
        '"Marktwert"?',
    options: [
      'Wie hoch ihre Schulden sind',
      'Aktienkurs mal Anzahl aller Aktien',
      'Wie alt ihr Logo ist',
      'Wie viele Mitarbeiter sie hat',
    ],
    correctIndex: 1,
    explanation:
        'Marktkapitalisierung = Aktienkurs × Anzahl aller Aktien. Sagt grob, '
        'wie viel die Firma an der Börse wert ist.',
    topic: QuizTopic.aktien,
    tier: QuizTier.hard,
  ),
  // 11. Geld auf Konto vs. Anlage
  QuizQuestion.multipleChoice(
    text:
        'Du hast 1000 € auf einem Konto ohne Zinsen. In 10 Jahren mit '
        '2% Inflation pro Jahr — was passiert mit der Kaufkraft?',
    options: [
      'Sie steigt langsam',
      'Sie bleibt gleich',
      'Sie sinkt — du kannst dir weniger leisten',
      'Sie verdoppelt sich',
    ],
    correctIndex: 2,
    explanation:
        'Ohne Zinsen frisst die Inflation die Kaufkraft auf. Deshalb reicht '
        'reines Sparen oft nicht — du brauchst Anlagen.',
    topic: QuizTopic.inflation,
    tier: QuizTier.mid,
  ),
  // 12. Risiko vs Rendite
  QuizQuestion.multipleChoice(
    text:
        'Eine Anlage verspricht 30% Gewinn pro Jahr — garantiert. Was '
        'solltest du tun?',
    options: [
      'Sofort dein ganzes Geld reinstecken',
      'Misstrauisch sein — solche Versprechen sind oft Betrug',
      'Es deinen Freunden weiterempfehlen',
      'Mehr Geld leihen, um noch mehr zu gewinnen',
    ],
    correctIndex: 1,
    explanation:
        'Hohe Gewinne gehen IMMER mit Risiko einher. "Garantierte" hohe '
        'Renditen sind fast immer Betrug. Ehrliche Anlagen werben mit '
        'Risiken, nicht mit Garantien.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.mid,
  ),
  // 13. Schulden
  QuizQuestion.multipleChoice(
    text:
        'Du leihst dir 100 € und sollst nach einem Jahr 120 € zurückzahlen. '
        'Was sind die 20 € extra?',
    options: [
      'Strafe',
      'Zinsen für den Kredit',
      'Geschenk an die Bank',
      'Steuern',
    ],
    correctIndex: 1,
    explanation:
        'Wer Geld leiht, zahlt Zinsen. Das ist der Preis dafür, das Geld '
        'früher zu haben.',
    topic: QuizTopic.schulden,
    tier: QuizTier.easy,
  ),
  // 14. Sparquote
  QuizQuestion.multipleChoice(
    text: 'Du bekommst 20 € Taschengeld. Was ist eine gute Faustregel?',
    options: [
      'Alles sofort ausgeben',
      'Alles auf einmal sparen',
      'Etwa 10-20% sparen, Rest nach Wunsch nutzen',
      'Alles an einen Freund verleihen',
    ],
    correctIndex: 2,
    explanation:
        'Eine Sparquote von etwa 10-20% ist eine gute Gewohnheit. So baust '
        'du langsam Reserven auf, ohne dass es weh tut.',
    topic: QuizTopic.sparen,
    tier: QuizTier.easy,
  ),
  // 15. ETF vs Einzelaktie
  QuizQuestion.multipleChoice(
    text:
        'Was ist meistens RISIKOÄRMER für Anfänger — ein breit gestreuter '
        'ETF oder eine einzelne Aktie?',
    options: [
      'Einzelne Aktie',
      'Breit gestreuter ETF',
      'Beide gleich risikoreich',
      'Kommt nur auf den Namen an',
    ],
    correctIndex: 1,
    explanation:
        'Ein breit gestreuter ETF ist meistens risikoärmer, weil das Geld '
        'auf viele Firmen verteilt ist. Eine einzelne Aktie kann stark '
        'fallen oder steigen.',
    topic: QuizTopic.etf,
    tier: QuizTier.easy,
  ),
  // 16. Langfristig anlegen
  QuizQuestion.multipleChoice(
    text:
        'Geldanlagen mit Aktien sind besonders sinnvoll, wenn du wie lange '
        'investieren willst?',
    options: [
      'Bis morgen',
      'Eine Woche',
      'Mehrere Jahre, am besten Jahrzehnte',
      'Eine Stunde',
    ],
    correctIndex: 2,
    explanation:
        'Aktien schwanken kurzfristig stark. Über viele Jahre haben sie '
        'historisch fast immer Gewinn gebracht. Geduld ist der Schlüssel.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.easy,
  ),
  // 17. Notgroschen
  QuizQuestion.multipleChoice(
    text: 'Was ist ein "Notgroschen"?',
    options: [
      'Geld, das du an Freunde verleihst',
      'Reserve für unerwartete Ausgaben',
      'Eine alte Münze als Glücksbringer',
      'Geld nur für Spielzeug',
    ],
    correctIndex: 1,
    explanation:
        'Notgroschen: Reserve für plötzliche Ausgaben (kaputtes Handy, '
        'Geschenk vergessen). Sollte schnell verfügbar sein — nicht in '
        'Aktien stecken.',
    topic: QuizTopic.notgroschen,
    tier: QuizTier.easy,
  ),
  // 18. Brutto vs. Netto
  QuizQuestion.multipleChoice(
    text:
        'Dein Job zahlt 100 € — aber 20 € gehen an Steuern. Wie viel hast '
        'du wirklich (netto)?',
    options: [
      '100 €',
      '120 €',
      '80 €',
      '20 €',
    ],
    correctIndex: 2,
    explanation:
        'Brutto ist vor Abzügen, Netto ist nach Abzügen. Wichtig zu wissen, '
        'wenn du später deinen ersten Lohn bekommst.',
    topic: QuizTopic.steuer,
    tier: QuizTier.easy,
  ),
  // 19. Blase
  QuizQuestion.multipleChoice(
    text:
        'Alle reden plötzlich über eine bestimmte Aktie und der Preis '
        'verzehnfacht sich in wenigen Wochen. Was ist das oft?',
    options: [
      'Sicherer Gewinn',
      'Eine "Blase" — Preis weit über echtem Wert',
      'Ein Geschenk vom Staat',
      'Eine normale Entwicklung',
    ],
    correctIndex: 1,
    explanation:
        'Blasen platzen meist genauso schnell, wie sie entstanden sind. '
        'Wer zu spät einsteigt, verliert oft viel Geld.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.hard,
  ),
  // 20. Wunsch vs Bedürfnis
  QuizQuestion.multipleChoice(
    text: 'Welches davon ist eine NOTWENDIGKEIT, kein Wunsch?',
    options: [
      'Limitierter SnipeShot Sneaker',
      'Essen für die Woche',
      'Premium-Account auf DropTok',
      'Neuestes Smartphone',
    ],
    correctIndex: 1,
    explanation:
        'Essen brauchst du zum Leben. Alles andere sind Wünsche. Wünsche '
        'sind nicht schlecht — aber sie kommen nach Notwendigkeiten.',
    topic: QuizTopic.grundlagen,
    tier: QuizTier.easy,
  ),
  // 22. Sparplan / Cost-Average (Welle-8 Round 13)
  QuizQuestion.multipleChoice(
    text:
        'Du legst JEDEN Monat 25 € in den gleichen ETF an. Mal steht der '
        'Kurs hoch, mal tief. Warum ist das clever?',
    options: [
      'Du kaufst bei tiefem Kurs mehr Anteile, bei hohem weniger',
      'Der ETF bekommt einen Rabatt',
      'Die Bank verschenkt dir Aktien',
      'Du sparst Steuern',
    ],
    correctIndex: 0,
    explanation:
        'Cost-Average-Effekt: Bei niedrigem Kurs kriegst du für dieselben '
        '25 € mehr Anteile, bei hohem weniger. Über Jahre ergibt sich ein '
        'fairer Durchschnittspreis — ohne dass du den Markt timen musst.',
    topic: QuizTopic.sparplan,
    tier: QuizTier.mid,
  ),
  // 23. Notgroschen-Höhe (Welle-8 Round 13)
  QuizQuestion.multipleChoice(
    text:
        'Wie hoch sollte dein Notgroschen ungefähr sein — Faustregel?',
    options: [
      'Genau 50 €',
      'Etwa 3 Monatsausgaben',
      'Ein ganzes Jahresgehalt',
      'So viel wie auf dem Girokonto eh schon liegt',
    ],
    correctIndex: 1,
    explanation:
        'Faustregel: 3 Monatsausgaben als Notgroschen — auf einem '
        'Sparkonto, schnell verfügbar. Reicht für kaputtes Handy, '
        'überraschende Reparatur, oder wenn der Job mal ausfällt.',
    topic: QuizTopic.notgroschen,
    tier: QuizTier.mid,
  ),
  // 24. Gold als Inflationsschutz (Welle-8 Round 13)
  QuizQuestion.multipleChoice(
    text:
        'Warum kaufen manche Leute Gold, wenn die Inflation hoch ist?',
    options: [
      'Weil es leuchtet',
      'Weil Gold seinen Wert über Jahrhunderte oft gehalten hat',
      'Weil die Bank Zinsen darauf zahlt',
      'Weil es jeden Monat wächst',
    ],
    correctIndex: 1,
    explanation:
        'Gold zahlt zwar keine Zinsen oder Dividende — aber sein Wert hielt '
        'sich historisch oft, wenn Geld an Kaufkraft verlor. Deshalb gilt '
        'es als Krisen-Versicherung. Nicht das ganze Geld in Gold stecken.',
    topic: QuizTopic.edelmetalle,
    tier: QuizTier.mid,
  ),
  // 21. Buy and hold
  QuizQuestion.multipleChoice(
    text: 'Was beschreibt die "Buy and Hold"-Strategie am besten?',
    options: [
      'Schnell kaufen, schnell wieder verkaufen',
      'Kaufen und über Jahre liegen lassen',
      'Nur kaufen, wenn alle anderen kaufen',
      'Jeden Tag neu entscheiden',
    ],
    correctIndex: 1,
    explanation:
        'Buy and Hold: Du kaufst gute, breit gestreute Anlagen und lässt '
        'sie liegen. Spart Nerven, Gebühren und schlägt oft hektisches '
        'Hin-und-Her.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.mid,
  ),
  // ─────────────────────────────────────────────────────────────────
  // Welle-8 Round 25: Alltags-Finanzen eines Teenagers.
  // ─────────────────────────────────────────────────────────────────
  // 22. Konto-Basics — Giro vs Spar
  QuizQuestion.multipleChoice(
    text: 'Wofür ist ein Girokonto da?',
    options: [
      'Zum Geld lange liegen lassen und viel Zinsen sammeln',
      'Für den täglichen Geldverkehr: Geld empfangen, überweisen, zahlen',
      'Nur um Aktien zu kaufen',
      'Um Bargeld zu Hause zu verstecken',
    ],
    correctIndex: 1,
    explanation:
        'Das Girokonto ist dein Alltagskonto: Hier kommt z.B. Taschengeld '
        'oder Lohn an, davon überweist und bezahlst du. Zum Ansparen nimmt '
        'man eher ein Spar- oder Tagesgeldkonto.',
    topic: QuizTopic.konto,
    tier: QuizTier.easy,
  ),
  // 23. In-Game-Käufe
  QuizQuestion.multipleChoice(
    text:
        'Ein kostenloses Handyspiel will ständig, dass du echtes Geld für '
        'Kisten und Skins ausgibst. Was stimmt?',
    options: [
      'Die Sachen sind ihr Geld immer wert',
      'Das Spiel ist extra so gebaut, dass du oft kaufst — überleg dir ein '
          'Limit oder lass es',
      'Wer nicht kauft, kann nicht spielen',
      'In-Game-Käufe machen dich auf Dauer reich',
    ],
    correctIndex: 1,
    explanation:
        '„Gratis"-Spiele verdienen genau an diesen Käufen. Skins sind weg, '
        'sobald das Spiel stirbt. Setz dir ein festes Limit — oder spar das '
        'Geld lieber für etwas Echtes.',
    topic: QuizTopic.konsum,
    tier: QuizTier.easy,
  ),
  // 24. Abo-Falle
  QuizQuestion.multipleChoice(
    text:
        'Eine App ist „1 Monat gratis" — danach wird automatisch jeden Monat '
        'abgebucht. Was ist schlau?',
    options: [
      'Einfach vergessen, wird schon nicht teuer',
      'Direkt im Kalender notieren und rechtzeitig kündigen, wenn du sie '
          'nicht brauchst',
      'Noch drei weitere Gratis-Abos dazunehmen',
      'Die Karte der Eltern ohne Fragen benutzen',
    ],
    correctIndex: 1,
    explanation:
        'Gratis-Proben sind dazu da, dass man das Kündigen vergisst. Trag dir '
        'das Ende-Datum ein und entscheide bewusst: behalten oder kündigen.',
    topic: QuizTopic.konsum,
    tier: QuizTier.mid,
  ),
  // 25. Ratenkauf / 0%-Finanzierung
  QuizQuestion.multipleChoice(
    text:
        'Eine Konsole für 600 € gibt es „in 24 bequemen Raten zu 0 %". Wo ist '
        'der Haken?',
    options: [
      'Es gibt keinen — Raten sind immer gut',
      'Du gibst Geld aus, das du noch nicht hast, und zahlst lange für etwas, '
          'das schnell an Wert verliert',
      'Die Konsole wird dadurch billiger',
      'Raten zahlen verbessert deinen Notgroschen',
    ],
    correctIndex: 1,
    explanation:
        'Auch bei 0 % bindest du dich monatelang und gibst Geld aus, das du '
        'noch nicht hast. Besser: vorher sparen, dann bar kaufen — dann '
        'gehört es wirklich dir.',
    topic: QuizTopic.schulden,
    tier: QuizTier.mid,
  ),
  // 26. Phishing / Account-Klau
  QuizQuestion.multipleChoice(
    text:
        'Du bekommst eine Mail: „Dein Account ist gesperrt! Hier klicken und '
        'Passwort eingeben." Was tust du?',
    options: [
      'Schnell klicken und Passwort eingeben',
      'Nicht klicken — echte Firmen fragen so nie nach deinem Passwort. Im '
          'Zweifel direkt auf der echten Seite einloggen',
      'Das Passwort an einen Freund weitergeben',
      'Antworten und nach mehr Infos fragen',
    ],
    correctIndex: 1,
    explanation:
        'Das ist Phishing: Betrüger wollen dein Passwort. Echte Anbieter '
        'fragen nie per Mail/Link danach. Nicht klicken, lieber selbst die '
        'offizielle Seite/App öffnen.',
    topic: QuizTopic.betrug,
    tier: QuizTier.easy,
  ),
  // 27. Fake-Shop / zu billig
  QuizQuestion.multipleChoice(
    text:
        'Ein unbekannter Online-Shop bietet das nagelneue 1000-€-Handy für '
        '99 €. Was ist am wahrscheinlichsten?',
    options: [
      'Ein super Schnäppchen, sofort zugreifen',
      'Eine Abzocke — Geld weg und keine Ware. Wenn es zu gut klingt, ist es '
          'meist Betrug',
      'Der Shop verschenkt einfach gern Geld',
      'Der Preis wird nach dem Kauf normal',
    ],
    correctIndex: 1,
    explanation:
        'Fake-Shops locken mit Traumpreisen. Du zahlst, bekommst nichts (oder '
        'Schrott). Faustregel: zu gut um wahr zu sein = Finger weg, vorher '
        'Bewertungen prüfen.',
    topic: QuizTopic.betrug,
    tier: QuizTier.easy,
  ),
  // 28. Werbung / Influencer
  QuizQuestion.multipleChoice(
    text:
        'Ein Influencer zeigt in fast jedem Video dasselbe Produkt. Warum oft?',
    options: [
      'Er findet es einfach zufällig super',
      'Er wird dafür bezahlt (Werbung) — sein Lob ist nicht neutral',
      'Das Produkt ist garantiert das beste der Welt',
      'Influencer dürfen keine Werbung machen',
    ],
    correctIndex: 1,
    explanation:
        'Vieles ist bezahlte Werbung, auch wenn es wie ein Tipp aussieht. '
        'Frag dich: Verdient die Person daran? Vergleiche selbst, bevor du '
        'kaufst.',
    topic: QuizTopic.konsum,
    tier: QuizTier.easy,
  ),
  // 29. Zielsparen
  QuizQuestion.multipleChoice(
    text:
        'Du willst eine Konsole für 240 € und sparst 20 € pro Monat. Wie '
        'lange dauert es?',
    options: [
      '6 Monate',
      '12 Monate',
      '24 Monate',
      '3 Monate',
    ],
    correctIndex: 1,
    explanation:
        '240 € geteilt durch 20 €/Monat = 12 Monate. Ein klares Ziel + feste '
        'Sparrate macht große Wünsche planbar — und du weißt genau, wann du '
        'da bist.',
    topic: QuizTopic.sparen,
    tier: QuizTier.easy,
  ),
  // ─────────────────────────────────────────────────────────────────
  // Welle-8 Round 26: 2. Frage zu dünnen Kern-Topics (waren nur 1) —
  // mehr Abwechslung früh im Spiel + im Spaced-Rep-Review.
  // ─────────────────────────────────────────────────────────────────
  // 30. Konto — Überweisung
  QuizQuestion.multipleChoice(
    text: 'Was passiert bei einer Überweisung?',
    options: [
      'Bargeld wird gedruckt',
      'Geld wird von deinem Konto auf ein anderes Konto geschickt',
      'Dein Konto wird gelöscht',
      'Du bekommst kostenlos Geld geschenkt',
    ],
    correctIndex: 1,
    explanation:
        'Bei einer Überweisung schickst du Geld von deinem Konto auf ein '
        'anderes — z.B. um online etwas zu bezahlen. Kein Bargeld nötig.',
    topic: QuizTopic.konto,
    tier: QuizTier.easy,
  ),
  // 31. Grundlagen — Budget
  QuizQuestion.multipleChoice(
    text: 'Was ist ein „Budget"?',
    options: [
      'Eine teure Marke',
      'Ein Plan, wie viel Geld du wofür ausgeben willst',
      'Ein anderes Wort für Schulden',
      'Eine App zum Spielen',
    ],
    correctIndex: 1,
    explanation:
        'Ein Budget ist dein Geld-Plan: Du legst vorher fest, wie viel du '
        'wofür ausgibst und wie viel du sparst. So behältst du den Überblick.',
    topic: QuizTopic.grundlagen,
    tier: QuizTier.easy,
  ),
  // 32. Zinsen — Grundbegriff
  QuizQuestion.multipleChoice(
    text: 'Was sind „Zinsen", wenn du Geld auf einem Sparkonto hast?',
    options: [
      'Eine Strafe fürs Sparen',
      'Geld, das die Bank dir fürs Anlegen dazugibt',
      'Eine Gebühr, die du jeden Monat zahlst',
      'Das Gleiche wie Steuern',
    ],
    correctIndex: 1,
    explanation:
        'Zinsen sind die Belohnung fürs Anlegen: Die Bank zahlt dir einen '
        'kleinen Prozentsatz dazu, weil sie mit deinem Geld arbeiten darf.',
    topic: QuizTopic.zinsen,
    tier: QuizTier.easy,
  ),
  // 33. Steuern — wofür
  QuizQuestion.multipleChoice(
    text: 'Wofür werden Steuern hauptsächlich verwendet?',
    options: [
      'Nur für die Chefs großer Firmen',
      'Für gemeinsame Dinge: Schulen, Straßen, Krankenhäuser, Polizei',
      'Die verschwinden einfach',
      'Nur fürs Ausland',
    ],
    correctIndex: 1,
    explanation:
        'Von Steuern bezahlt der Staat Dinge, die alle nutzen — Schulen, '
        'Straßen, Feuerwehr, Krankenhäuser. Deshalb zahlt fast jeder, der '
        'Geld verdient, einen Teil als Steuer.',
    topic: QuizTopic.steuer,
    tier: QuizTier.mid,
  ),
  // 34. Sparplan — Automatik
  QuizQuestion.multipleChoice(
    text:
        'Was ist ein großer Vorteil eines Sparplans (jeden Monat automatisch '
        'ein fester Betrag)?',
    options: [
      'Du musst nie wieder daran denken und sparst ganz von allein',
      'Er macht dich über Nacht reich',
      'Er funktioniert nur für Erwachsene',
      'Man kann ihn nie wieder stoppen',
    ],
    correctIndex: 0,
    explanation:
        'Ein Sparplan zieht automatisch jeden Monat denselben Betrag ein. So '
        'sparst du regelmäßig, ohne dich zu überwinden — „erst sparen, dann '
        'ausgeben".',
    topic: QuizTopic.sparplan,
    tier: QuizTier.mid,
  ),
  // 35. Diversifikation — breit gestreut
  QuizQuestion.multipleChoice(
    text:
        'Dein Geld ist „breit gestreut". Was heißt das?',
    options: [
      'Alles steckt in einer einzigen Firma',
      'Es ist auf viele verschiedene Anlagen verteilt, damit ein Reinfall '
          'nicht alles trifft',
      'Du hast es überall im Zimmer verteilt',
      'Du gibst es schnell wieder aus',
    ],
    correctIndex: 1,
    explanation:
        'Breit gestreut = auf viele verschiedene Firmen/Anlagen verteilt. '
        'Geht eine Sache schief, ziehen die anderen dich nicht mit runter. '
        'Das senkt dein Risiko.',
    topic: QuizTopic.diversifikation,
    tier: QuizTier.mid,
  ),
  // ─────────────────────────────────────────────────────────────────
  // Welle-8 Round 27 v6: +12 Fragen gegen Wiederholung (Pool wächst).
  // ─────────────────────────────────────────────────────────────────
  QuizQuestion.multipleChoice(
    text: 'Warum ist es schlau, früh mit dem Sparen anzufangen?',
    options: [
      'Weil man als Kind mehr Geld hat',
      'Weil das Geld mehr Zeit hat zu wachsen (Zinseszins)',
      'Weil Sparen später verboten ist',
      'Gar nicht — egal wann man anfängt',
    ],
    correctIndex: 1,
    explanation:
        'Je früher du anfängst, desto länger arbeitet der Zinseszins für '
        'dich. Zeit ist beim Geld-Anlegen wichtiger als der Betrag.',
    topic: QuizTopic.zinsen,
    tier: QuizTier.easy,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was bedeutet „TER" bei einem ETF?',
    options: [
      'Der Gewinn pro Jahr',
      'Die jährlichen Kosten/Gebühren des ETF (in %)',
      'Die Anzahl der Firmen drin',
      'Ein Risiko-Siegel',
    ],
    correctIndex: 1,
    explanation:
        'TER = jährliche Kosten des ETF in Prozent. Niedrig ist gut — bei '
        'breiten ETFs oft 0,1–0,3 %/Jahr. Hohe Gebühren fressen Rendite.',
    topic: QuizTopic.etf,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Du brauchst dein Notgroschen-Geld vielleicht plötzlich. Wo gehört es hin?',
    options: [
      'In riskante Aktien für mehr Rendite',
      'Aufs Sparkonto — sicher + schnell verfügbar',
      'In Krypto',
      'In eine Immobilie',
    ],
    correctIndex: 1,
    explanation:
        'Der Notgroschen muss sicher + jederzeit verfügbar sein. Aktien/'
        'Krypto können gerade dann tief stehen, wenn du das Geld brauchst.',
    topic: QuizTopic.notgroschen,
    tier: QuizTier.easy,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was ist eine Dividende?',
    options: [
      'Eine Strafe für Aktionäre',
      'Ein Teil des Firmengewinns, der an die Aktionäre ausgezahlt wird',
      'Der Kaufpreis einer Aktie',
      'Eine Steuer',
    ],
    correctIndex: 1,
    explanation:
        'Macht eine Firma Gewinn, kann sie einen Teil als Dividende an ihre '
        'Aktionäre auszahlen — wie ein kleiner Bonus fürs Mit-Besitzen.',
    topic: QuizTopic.dividende,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Warum gilt Gold als „sicherer Hafen"?',
    options: [
      'Weil es jedes Jahr stark steigt',
      'Weil es seinen Wert über lange Zeit hält, auch bei Krisen/Inflation',
      'Weil eine Firma es garantiert',
      'Weil es Zinsen zahlt',
    ],
    correctIndex: 1,
    explanation:
        'Gold zahlt keine Zinsen, aber es behält über sehr lange Zeit seinen '
        'Wert. In Krisen flüchten viele rein — als Schutz, nicht zum schnell '
        'reich werden.',
    topic: QuizTopic.edelmetalle,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Eine einzelne Aktie kann auf 0 fallen, wenn die Firma pleitegeht. Was schützt davor?',
    options: [
      'Nur eine einzige Aktie kaufen',
      'Auf viele verschiedene Firmen verteilen (z.B. ETF)',
      'Täglich kaufen und verkaufen',
      'Gar nicht möglich',
    ],
    correctIndex: 1,
    explanation:
        'Eine Pleite trifft eine Einzelaktie hart. In einem breiten ETF mit '
        'hunderten Firmen fällt eine Pleite kaum auf — das ist der Schutz '
        'durch Streuung.',
    topic: QuizTopic.einzelaktie,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Der Kurs deiner Anlage schwankt stark hoch und runter. Wie nennt man das?',
    options: [
      'Dividende',
      'Volatilität',
      'Inflation',
      'Zinseszins',
    ],
    correctIndex: 1,
    explanation:
        'Volatilität = wie stark der Preis schwankt. Hohe Volatilität heißt '
        'große Sprünge — mehr Chance, aber auch mehr Risiko und Nerven.',
    topic: QuizTopic.volatilitaet,
    tier: QuizTier.easy,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was ist meist die klügste Reaktion, wenn die Kurse stark fallen?',
    options: [
      'Panisch alles verkaufen',
      'Ruhig bleiben und dranbleiben — Märkte haben sich bisher immer erholt',
      'Schnell alles auf eine Aktie setzen',
      'Nie wieder investieren',
    ],
    correctIndex: 1,
    explanation:
        'Wer im Tief verkauft, macht den Verlust echt. Historisch haben sich '
        'breite Märkte nach Crashs immer wieder erholt. Geduld schlägt Panik.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was heißt „den Markt timen"?',
    options: [
      'Genau den besten Kauf- und Verkaufs-Zeitpunkt treffen wollen',
      'Eine Uhr kaufen',
      'Jeden Tag dieselbe Summe sparen',
      'Den ETF wechseln',
    ],
    correctIndex: 0,
    explanation:
        'Den perfekten Zeitpunkt zu treffen klappt fast nie — selbst Profis '
        'scheitern. Regelmäßig investieren (Sparplan) schlägt das Timen.',
    topic: QuizTopic.sparplan,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Du hast 100 € übrig. Was ist meist die beste Reihenfolge?',
    options: [
      'Erst Wünsche, dann Notgroschen',
      'Erst Notgroschen aufbauen, dann investieren, dann Wünsche',
      'Alles sofort ausgeben',
      'Alles in eine Krypto-Münze',
    ],
    correctIndex: 1,
    explanation:
        'Profis sagen: zuerst ein Notgroschen-Polster, dann breit investieren, '
        'und was übrig bleibt für Wünsche. So bist du abgesichert UND baust auf.',
    topic: QuizTopic.grundlagen,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was bedeutet „den Cost-Average-Effekt nutzen"?',
    options: [
      'Immer alles auf einmal kaufen',
      'Regelmäßig denselben Betrag anlegen — mal teurer, mal billiger, im '
          'Schnitt entspannt',
      'Nur kaufen wenn es teuer ist',
      'Nie kaufen',
    ],
    correctIndex: 1,
    explanation:
        'Bei festen Raten kaufst du bei tiefen Preisen mehr Anteile, bei hohen '
        'weniger. Über die Zeit glättet das den Einstieg — kein Stress mit dem '
        'Timing.',
    topic: QuizTopic.sparplan,
    tier: QuizTier.mid,
  ),
  QuizQuestion.multipleChoice(
    text: 'Warum ist ein Girokonto schlecht zum langfristigen Sparen?',
    options: [
      'Weil man es nicht benutzen darf',
      'Weil es kaum Zinsen gibt und die Inflation die Kaufkraft auffrisst',
      'Weil Girokonten verboten sind',
      'Weil man da keine Karte hat',
    ],
    correctIndex: 1,
    explanation:
        'Auf dem Girokonto liegt Geld fast zinslos herum, während die '
        'Inflation jeden Wert langsam senkt. Zum Wachsen braucht es Zinsen '
        'oder breite Anlagen.',
    topic: QuizTopic.inflation,
    tier: QuizTier.easy,
  ),

  // ── Round 28 v4: Experten-Fragen für die Wissens-Meisterprüfung ──────────
  // Schwer (tier hard). Erst spät relevant — fordern echtes Verständnis.
  QuizQuestion.multipleChoice(
    text: 'Ein ETF hat eine TER von 0,20 %. Was heißt das?',
    options: [
      'Du zahlst 20 % Steuern auf Gewinne',
      'Die laufenden Kosten betragen 0,20 % pro Jahr auf dein angelegtes Geld',
      'Der ETF wächst garantiert 0,20 % pro Jahr',
      'Du bekommst 0,20 % Rabatt beim Kauf',
    ],
    correctIndex: 1,
    explanation:
        'TER = jährliche laufende Kosten des Fonds. Bei 10.000 € sind 0,20 % '
        '= 20 € im Jahr. Niedrige Kosten sind ein großer Vorteil breiter '
        'ETFs gegenüber teuren Fonds.',
    topic: QuizTopic.etf,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Deine Anlage macht 5 % Rendite, die Inflation liegt bei 2 %. '
        'Wie viel bist du real reicher geworden?',
    options: [
      'Etwa 3 %',
      'Genau 5 %',
      'Genau 7 %',
      'Gar nicht',
    ],
    correctIndex: 0,
    explanation:
        'Reale Rendite ≈ Rendite − Inflation. 5 % − 2 % = rund 3 % echte '
        'Kaufkraft-Steigerung. Deshalb muss man die Inflation immer '
        'mitdenken.',
    topic: QuizTopic.inflation,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was bedeutet „Rebalancing" bei einem Portfolio?',
    options: [
      'Alles verkaufen und neu anfangen',
      'Die ursprüngliche Aufteilung wiederherstellen, wenn sie verrutscht ist',
      'Immer die Verlierer nachkaufen',
      'Das Konto wechseln',
    ],
    correctIndex: 1,
    explanation:
        'Steigt z. B. der Aktien-Anteil von 60 auf 75 %, verkauft man etwas '
        'davon und kauft das Untergewichtete nach — zurück zur Ziel-'
        'Aufteilung. Das diszipliniert: teuer verkaufen, günstig kaufen.',
    topic: QuizTopic.diversifikation,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Unterschied „ausschüttend" vs. „thesaurierend" bei einem ETF?',
    options: [
      'Ausschüttend zahlt Erträge aus, thesaurierend legt sie automatisch wieder an',
      'Thesaurierend ist immer teurer',
      'Ausschüttend ist verboten in Deutschland',
      'Es gibt keinen Unterschied',
    ],
    correctIndex: 0,
    explanation:
        'Ausschüttend = Dividenden landen auf deinem Konto. Thesaurierend = '
        'sie werden direkt reinvestiert (Zinseszins läuft automatisch '
        'weiter). Beides ist okay — Geschmackssache.',
    topic: QuizTopic.etf,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Warum mischen manche Anleger Gold zu ihren Aktien?',
    options: [
      'Weil Gold immer mehr Rendite bringt als Aktien',
      'Weil Gold sich oft anders bewegt als Aktien und das Schwankungen dämpft',
      'Weil Gold steuerfrei ist',
      'Weil man Gold anfassen kann',
    ],
    correctIndex: 1,
    explanation:
        'Gold und Aktien laufen oft NICHT im Gleichschritt. Mischt man '
        'Dinge, die sich unterschiedlich bewegen, schwankt das Gesamt-Depot '
        'weniger — das ist der Kern von Diversifikation.',
    topic: QuizTopic.diversifikation,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Die „72er-Regel": Bei 6 % Zinsen pro Jahr verdoppelt sich dein '
        'Geld in etwa …',
    options: [
      '72 Jahren',
      '12 Jahren',
      '6 Jahren',
      '36 Jahren',
    ],
    correctIndex: 1,
    explanation:
        'Faustregel: 72 ÷ Zinssatz = Jahre bis zur Verdopplung. 72 ÷ 6 = 12. '
        'Eine schnelle Art, die Kraft des Zinseszins im Kopf zu schätzen.',
    topic: QuizTopic.zinsen,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Eine Aktie kostet 100 € und zahlt 3 € Dividende im Jahr. Wie hoch '
        'ist die Dividendenrendite?',
    options: [
      '3 %',
      '30 %',
      '0,3 %',
      '300 %',
    ],
    correctIndex: 0,
    explanation:
        'Dividendenrendite = Dividende ÷ Kurs = 3 € ÷ 100 € = 3 %. Sie sagt, '
        'wie viel Ausschüttung du pro investiertem Euro bekommst.',
    topic: QuizTopic.dividende,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Was sagt eine hohe „Volatilität" über eine Anlage aus?',
    options: [
      'Sie steigt sicher stark',
      'Ihr Preis schwankt stark — mal kräftig hoch, mal kräftig runter',
      'Sie ist garantiert sicher',
      'Sie zahlt viele Dividenden',
    ],
    correctIndex: 1,
    explanation:
        'Volatilität misst, wie heftig der Preis schwankt. Hoch = wilde '
        'Ausschläge in beide Richtungen. Mehr Schwankung heißt mehr Nerven, '
        'nicht automatisch mehr Rendite.',
    topic: QuizTopic.volatilitaet,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Warum ist ein Börsencrash kurz vor der Rente gefährlicher als mit 20?',
    options: [
      'Weil alte Menschen kein Internet haben',
      'Weil mit 20 noch viele Jahre Zeit bleiben, bis sich die Kurse erholen',
      'Crashs sind im Alter immer schlimmer programmiert',
      'Das stimmt gar nicht, es ist egal',
    ],
    correctIndex: 1,
    explanation:
        'Mit 20 hast du Jahrzehnte, um eine Erholung abzuwarten. Wer kurz '
        'vorm Entnehmen steht, hat diese Zeit nicht — deshalb schichtet man '
        'mit dem Alter oft etwas sicherer um.',
    topic: QuizTopic.psychologie,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Wie hoch ist in Deutschland der jährliche Sparerpauschbetrag '
        '(steuerfreie Kapitalerträge) für eine Person?',
    options: [
      '1.000 €',
      '100 €',
      '10.000 €',
      'Unbegrenzt',
    ],
    correctIndex: 0,
    explanation:
        'Bis 1.000 € Kapitalerträge pro Jahr bleiben mit Freistellungsauftrag '
        'steuerfrei. Erst darüber fallen rund 25 % Abgeltungssteuer an.',
    topic: QuizTopic.steuer,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Faustregel für den Notgroschen — wie viel und wo?',
    options: [
      'So viel wie möglich, komplett in Aktien',
      'Etwa 3–6 Monatsausgaben, jederzeit verfügbar (z. B. Tagesgeld)',
      'Genau 50 €, im Sparschwein',
      'Gar keiner nötig, wenn man investiert ist',
    ],
    correctIndex: 1,
    explanation:
        'Der Notgroschen (3–6 Monatsausgaben) gehört NICHT in schwankende '
        'Anlagen, sondern dahin, wo du sofort drankommst. So musst du bei '
        'einer Panne nichts mit Verlust verkaufen.',
    topic: QuizTopic.notgroschen,
    tier: QuizTier.hard,
  ),
  QuizQuestion.multipleChoice(
    text: 'Warum schlägt ein breiter Welt-ETF langfristig die meisten '
        'aktiv gemanagten Fonds?',
    options: [
      'Weil ETFs immer steigen',
      'Vor allem wegen der niedrigeren Kosten — und weil kaum jemand den '
          'Markt dauerhaft schlägt',
      'Weil Fondsmanager faul sind',
      'Weil ETFs vom Staat garantiert werden',
    ],
    correctIndex: 1,
    explanation:
        'Über viele Jahre fressen hohe Gebühren die Mehr-Rendite teurer '
        'Fonds auf, und kaum ein Manager schlägt den Markt dauerhaft. Günstig '
        '+ breit gewinnt meistens.',
    topic: QuizTopic.etf,
    tier: QuizTier.hard,
  ),
];
