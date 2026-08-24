import 'dart:math' as math;

import '../../economy/money.dart';
import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../job_level.dart';

/// Spec-43 v9: Funny Random Events ~1×/Monat.
///
/// Pool aus 8 Events: Geld geschenkt (Tante, Geburtstag, Fundbüro,
/// Steuer-Rückzahlung) + Schadensfälle (Geldbörse verloren,
/// Strafzettel, Reparatur, Spendenaktion).
///
/// Schenkungsteuer-Hinweis: Beträge > 20.000 € (Freibetrag Fremde
/// alle 10 Jahre) werden mit 7 % Schenkungsteuer abgezogen —
/// Bildungs-Aha-Moment.
class LuckyEventListener implements DayEventListener {
  const LuckyEventListener({
    this.chancePerDay = 0.018,
    this.startAgeYears = 13,
    this.pechBias = 0.6,
  });

  /// Welle-8 Round 22: 0,018 ≈ 1 Event pro 2 Monate. Vorher 0,01 — User-
  /// Feedback "mehr und größere Schadensposten, die weh tun".
  final double chancePerDay;
  final int startAgeYears;

  /// Anteil der Zufalls-Events, die negativ (Pech) sein sollen. User-
  /// Feedback: Pech war unterrepräsentiert, weil ein junger Spieler mehr
  /// eligible Glücks-Events + garantierte Fest-Geschenke hat. Statt uniform
  /// über den Pool zu ziehen, wird zuerst per Bias das Vorzeichen gewählt,
  /// dann INNERHALB des Buckets uniform. 0.6 = 60 % Pech.
  final double pechBias;

  /// Spec-44 follow-up: Opa-Event nur noch sehr selten + nur wenn
  /// Spieler erwachsen + Vollzeit-Job hat (User-Feedback: zu früh
  /// reich gewesen). 0,0003/Tag ≈ 1× / 9 Jahre.
  static const double opaChancePerDay = 0.0003;

  /// Mindestalter für Opa-Event (ab Vollzeit-Phase).
  static const int opaMinAgeYears = 19;

  static const int _seed = 0x47C001;

  /// Schenkungs-Freibetrag für Fremde alle 10 Jahre (in Cents).
  static const int taxFreeAllowance = 2000000; // 20.000 €

  /// Schenkungsteuer-Satz für Beträge über Freibetrag.
  static const double taxRate = 0.07;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    // Spec-44 follow-up: Opa-Event nur ab Vollzeit-Job + Alter ≥ 19.
    // Vorher: 0,1 %/Tag ungated → User bekam mit 13 nach 60 Tagen 23k €.
    final ageYears = startAgeYears + newDay.yearIndex;
    final job = JobConfig.forAge(ageYears);
    if (ageYears >= opaMinAgeYears && job.index >= JobLevel.vollzeit.index) {
      final opaGate = math.Random(_seed ^ (newDay.dayIndex * 1717));
      if (opaGate.nextDouble() < opaChancePerDay) {
        return _emit(_opaEvent, newDay, salt: 0xA1B2);
      }
    }

    // Jährliche Fest-Events (Geburtstag, Weihnachten, Ostern). Skaliert
    // mit Alter — kleine Beträge im Kindesalter, größer als Erwachsener.
    final dayInYear = newDay.dayIndex % 365;
    final fest = _annualFestEvent(dayInYear, ageYears);
    if (fest != null) {
      return _emit(fest, newDay, salt: dayInYear);
    }

    final gate = math.Random(_seed ^ (newDay.dayIndex * 2654435761));
    if (gate.nextDouble() >= chancePerDay) return const [];

    // Age + Job-Gate: nur Events die zum Lebensabschnitt passen.
    final isVollzeit = job.index >= JobLevel.vollzeit.index;
    final eligible = _events
        .where((e) =>
            ageYears >= e.minAgeYears &&
            (!e.requiresVollzeit || isVollzeit))
        .toList(growable: false);
    if (eligible.isEmpty) return const [];

    // Pech-Bias: erst Vorzeichen-Bucket per Bias wählen, dann darin uniform.
    // Verhindert, dass der (für junge Spieler glückslastige) Pool die
    // negativen Ereignisse verschluckt. Leerer Bucket → anderer Bucket.
    final positives =
        eligible.where((e) => e.baseAmountCents >= 0).toList(growable: false);
    final negatives =
        eligible.where((e) => e.baseAmountCents < 0).toList(growable: false);
    final signRng = math.Random(_seed ^ (newDay.dayIndex * 40503));
    final wantNegative = signRng.nextDouble() < pechBias;
    final bucket = wantNegative
        ? (negatives.isNotEmpty ? negatives : positives)
        : (positives.isNotEmpty ? positives : negatives);

    final pick = math.Random(_seed ^ (newDay.dayIndex * 7919));
    final tpl = bucket[pick.nextInt(bucket.length)];

    return _emit(tpl, newDay, salt: 0);
  }

  List<DayEvent> _emit(_EventTemplate tpl, GameDay newDay, {required int salt}) {
    final pick = math.Random(_seed ^ (newDay.dayIndex * 7919) ^ salt);
    final amountVar =
        1.0 + (pick.nextDouble() - 0.5) * tpl.variance;
    final amountCents = (tpl.baseAmountCents * amountVar).round();

    var tax = 0;
    var net = amountCents;
    if (amountCents > taxFreeAllowance && tpl.isGift) {
      final excess = amountCents - taxFreeAllowance;
      tax = (excess * taxRate).round();
      net = amountCents - tax;
    }
    return [
      DayEvent.luckyEvent(
        title: tpl.title,
        description: tpl.description +
            (tax > 0
                ? ' Steuer ${Money.cents(tax).formatEur()} (7 % über 20.000 €).'
                : ''),
        amount: Money.cents(net),
        taxDeducted: Money.cents(tax),
      ),
    ];
  }
}

/// Liefert ein jährliches Fest-Event für den gegebenen Jahres-Tag,
/// oder null wenn kein Fest. Beträge skalieren mit Alter (Kinder
/// bekommen weniger, Erwachsene mehr).
_EventTemplate? _annualFestEvent(int dayInYear, int ageYears) {
  // Geburtstag: Tag 60 (~Anfang März)
  if (dayInYear == 60) {
    return _EventTemplate(
      title: '🎂 Geburtstag',
      description:
          'Familie und Freunde haben dir was zugesteckt. Alles Gute!',
      baseAmountCents: ageYears < 16
          ? 3000 // 30 € Kind
          : ageYears < 19
              ? 6000 // 60 € Jugend
              : 10000, // 100 € Erwachsen
      variance: 0.3,
      isGift: true,
    );
  }
  // Ostern: Tag 110 (~April)
  if (dayInYear == 110) {
    return _EventTemplate(
      title: '🐰 Ostern',
      description: 'Oster-Geldgeschenk im Osterkörbchen.',
      baseAmountCents: ageYears < 16 ? 1500 : 2500,
      variance: 0.4,
      isGift: true,
    );
  }
  // Weihnachten: Tag 358 (~24. Dezember)
  if (dayInYear == 358) {
    return _EventTemplate(
      title: '🎄 Weihnachten',
      description: 'Geldgeschenke von der ganzen Familie.',
      baseAmountCents: ageYears < 16
          ? 5000
          : ageYears < 19
              ? 8000
              : 15000,
      variance: 0.3,
      isGift: true,
    );
  }
  // Konfirmation/Firmung/Jugendweihe: einmalig mit 14
  if (dayInYear == 200 && ageYears == 14) {
    return const _EventTemplate(
      title: '⛪ Konfirmation/Firmung',
      description: 'Großer Tag — Familie schenkt zur Einsegnung Geld.',
      baseAmountCents: 25000, // 250 €
      variance: 0.4,
      isGift: true,
    );
  }
  return null;
}

const _EventTemplate _opaEvent = _EventTemplate(
  title: '🎂 Geldgeschenk von Opa',
  description:
      'Opa hat dir eine schöne Summe übertragen. Bei großen Schenkungen '
      'an Fremde fällt ab 20.000 € Schenkungsteuer an.',
  baseAmountCents: 800000, // 8000 € (war 25k → User-Feedback zu früh reich)
  variance: 0.3,
  isGift: true,
);

class _EventTemplate {
  const _EventTemplate({
    required this.title,
    required this.description,
    required this.baseAmountCents,
    required this.variance,
    required this.isGift,
    this.minAgeYears = 0,
    this.requiresVollzeit = false,
  });

  final String title;
  final String description;
  final int baseAmountCents;
  final double variance;
  final bool isGift;
  /// Mindest-Alter für dieses Event (0 = überall).
  final int minAgeYears;
  /// Wenn true: nur wenn Spieler Vollzeit-Job hat.
  final bool requiresVollzeit;
}

// Event-Pool. Pick erfolgt NICHT uniform, sondern erst per pechBias übers
// Vorzeichen, dann im Bucket uniform (siehe onDayAdvance) — daher müssen die
// Bucket-Größen nicht gleich sein. Großbrocken sind age/job-gated.
const List<_EventTemplate> _events = [
  // ── Positiv ──────────────────────────────────────────────
  _EventTemplate(
    title: '🎁 Oma schickt Geld',
    description: 'Oma hat dir was Liebes überwiesen.',
    baseAmountCents: 5000,
    variance: 0.4,
    isGift: true,
  ),
  _EventTemplate(
    title: '💰 Geldbörse gefunden',
    description: 'Geldbörse mit Bargeld am Boden — Glück gehabt!',
    baseAmountCents: 3000,
    variance: 0.6,
    isGift: false,
  ),
  _EventTemplate(
    title: '🎂 Geburtstags-Umschlag',
    description: 'Tante Erika hat dir zum Geburtstag was reingelegt.',
    baseAmountCents: 8000,
    variance: 0.3,
    isGift: true,
  ),
  _EventTemplate(
    title: '💸 Steuer-Rückzahlung',
    description: 'Finanzamt hat zu viel kassiert — du bekommst was zurück.',
    baseAmountCents: 4500,
    variance: 0.4,
    isGift: false,
    minAgeYears: 16,
  ),
  _EventTemplate(
    title: '🎰 Lotterie-Mini-Gewinn',
    description: 'Kleiner Lotterie-Gewinn.',
    baseAmountCents: 1500,
    variance: 0.8,
    isGift: false,
  ),
  _EventTemplate(
    title: '🛠 Nachbarschafts-Hilfe',
    description: 'Hast geholfen Rasen zu mähen / Tüten zu tragen.',
    baseAmountCents: 2500,
    variance: 0.4,
    isGift: false,
  ),
  _EventTemplate(
    title: '🎓 Schul-Preis',
    description: 'Für gute Note / Projekt — kleine Anerkennung.',
    baseAmountCents: 5000,
    variance: 0.3,
    isGift: true,
  ),
  // ── Negativ ──────────────────────────────────────────────
  _EventTemplate(
    title: '😞 Geldbörse verloren',
    description: 'Geldbörse irgendwo liegengelassen.',
    baseAmountCents: -2000,
    variance: 0.5,
    isGift: false,
  ),
  _EventTemplate(
    title: '🚨 Strafzettel',
    description: 'Beim Falschparken erwischt. Lehrgeld.',
    baseAmountCents: -3500,
    variance: 0.3,
    isGift: false,
    minAgeYears: 16,
  ),
  _EventTemplate(
    title: '🔧 Handy-Reparatur',
    description: 'Display gesplittert — muss zur Werkstatt.',
    baseAmountCents: -8000,
    variance: 0.4,
    isGift: false,
  ),
  _EventTemplate(
    title: '🦷 Zahnarzt-Zuzahlung',
    description: 'Krankenkasse zahlt nicht alles.',
    baseAmountCents: -5000,
    variance: 0.4,
    isGift: false,
    minAgeYears: 18,
  ),
  _EventTemplate(
    title: '🚴 Fahrrad-Schaden',
    description: 'Reifen + Schaltung neu.',
    baseAmountCents: -4500,
    variance: 0.4,
    isGift: false,
  ),
  _EventTemplate(
    title: '🎫 Konzert-Karte (Spontan)',
    description: 'Konntest nicht widerstehen.',
    baseAmountCents: -6000,
    variance: 0.3,
    isGift: false,
    minAgeYears: 14,
  ),
  _EventTemplate(
    title: '💳 Bank-Gebühr (Auslandszahlung)',
    description: r'Online-Shop hat in $ verlangt.',
    baseAmountCents: -1500,
    variance: 0.4,
    isGift: false,
    minAgeYears: 14,
  ),
  // Junge, kleine Pech-Events (Alltag eines Teenagers) — mehr Pech-
  // Abwechslung früh im Spiel, mit Konsum-/Betrugs-Lerneffekt.
  _EventTemplate(
    title: '🎮 In-Game-Kauf bereut',
    description: 'Im Spiel was gekauft — am nächsten Tag schon egal.',
    baseAmountCents: -1500,
    variance: 0.5,
    isGift: false,
  ),
  _EventTemplate(
    title: '👟 Sneaker-Fehlkauf',
    description: 'Hype-Schuhe gekauft, drücken — Geld futsch.',
    baseAmountCents: -3500,
    variance: 0.4,
    isGift: false,
    minAgeYears: 14,
  ),
  _EventTemplate(
    title: '📦 Fake-Shop reingefallen',
    description: 'Ware kam nie an — der Shop war ein Fake.',
    baseAmountCents: -2500,
    variance: 0.4,
    isGift: false,
    minAgeYears: 14,
  ),
  _EventTemplate(
    title: '🔁 Abo vergessen zu kündigen',
    description: 'Gratis-Monat lief aus, Abo lief weiter.',
    baseAmountCents: -1200,
    variance: 0.5,
    isGift: false,
    minAgeYears: 14,
  ),
  // ── Schwere Brocken (selten in 14er-Pool, also ~1× pro Jahr) ──
  _EventTemplate(
    title: '🧾 Steuernachzahlung',
    description: 'Finanzamt hat nachgerechnet — Bescheid kommt.',
    baseAmountCents: -45000,
    variance: 0.4,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '🚗 Werkstatt-Rechnung Auto',
    description: 'Kupplung hin — überraschend teuer.',
    baseAmountCents: -120000,
    variance: 0.3,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '🏠 Wasserschaden Wohnung',
    description: 'Selbstbeteiligung der Hausratversicherung.',
    baseAmountCents: -80000,
    variance: 0.4,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '⚖ Anwalts-Honorar',
    description: 'Streit mit Vermieter — Anwalt nötig.',
    baseAmountCents: -60000,
    variance: 0.3,
    isGift: false,
    minAgeYears: 18,
  ),
  _EventTemplate(
    title: '🦴 Krankenhaus-Zuzahlung',
    description: 'OP + Reha — auch mit Kasse zahlst du mit.',
    baseAmountCents: -40000,
    variance: 0.3,
    isGift: false,
    minAgeYears: 18,
  ),
  // ── Schwere positive Brocken ──
  _EventTemplate(
    title: '💼 Bonus vom Chef',
    description: 'Außerordentliche Prämie — Projekt fertig.',
    baseAmountCents: 80000,
    variance: 0.4,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '🏆 Wettbewerbs-Preis',
    description: 'Bei einem Online-Wettbewerb gewonnen.',
    baseAmountCents: 50000,
    variance: 0.5,
    isGift: false,
    minAgeYears: 14,
  ),
  _EventTemplate(
    title: '🤝 Aktien-Dividende-Bonus',
    description: 'Sonder-Ausschüttung einer Beteiligung.',
    baseAmountCents: 60000,
    variance: 0.5,
    isGift: false,
    minAgeYears: 16,
  ),
  _EventTemplate(
    title: '🪙 Steuer-Erstattung (groß)',
    description: 'Werbungskosten anerkannt — größere Rückzahlung.',
    baseAmountCents: 70000,
    variance: 0.4,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '💰 Erbschaft Tante',
    description: 'Tante hat dich bedacht — unter Freibetrag.',
    baseAmountCents: 150000,
    variance: 0.3,
    isGift: true,
    // Welle-8: User-Feedback "mit 13 Erbschaft = unrealistisch".
    minAgeYears: 18,
  ),
  // ── Welle-8 Round 22: Neue Schadensereignisse die „weh tun" ──────
  _EventTemplate(
    title: '🔥 Heizung defekt',
    description: 'Mitten im Winter — Notdienst + neue Therme. Autsch.',
    baseAmountCents: -180000, // 1.800 €
    variance: 0.3,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '🚗 Auto-Unfall Selbstbeteiligung',
    description: 'Kleiner Crash, deine Vollkasko zahlt — bis auf 500 € SB.',
    baseAmountCents: -100000,
    variance: 0.4,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '🧾 Steuernachzahlung (groß)',
    description: 'Finanzamt-Bescheid: 2.000 € Nachzahlung. Hart.',
    baseAmountCents: -200000,
    variance: 0.3,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '🦷 Zahn-Krone',
    description: 'Kasse zahlt nur Basis — Rest selbst.',
    baseAmountCents: -90000,
    variance: 0.3,
    isGift: false,
    minAgeYears: 18,
  ),
  _EventTemplate(
    title: '🛁 Waschmaschine kaputt',
    description: 'Reparatur lohnt nicht — neues Gerät muss her.',
    baseAmountCents: -60000,
    variance: 0.3,
    isGift: false,
    requiresVollzeit: true,
  ),
  _EventTemplate(
    title: '📱 Phishing-Falle',
    description: 'Auf Fake-SMS reingefallen — Geld weg, Bank zahlt nicht.',
    baseAmountCents: -50000,
    variance: 0.4,
    isGift: false,
    minAgeYears: 16,
  ),
  _EventTemplate(
    title: '🚲 Fahrrad-Diebstahl',
    description: 'Rad weg. Versicherung erstattet nur Restwert.',
    baseAmountCents: -45000,
    variance: 0.3,
    isGift: false,
    minAgeYears: 14,
  ),
  _EventTemplate(
    title: '🏥 OP + Reha lang',
    description: 'Lange Genesung — Zuzahlungen + Verdienstausfall.',
    baseAmountCents: -130000,
    variance: 0.3,
    isGift: false,
    minAgeYears: 18,
  ),
];
