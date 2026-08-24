import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';

/// Round 28: Saisonale Lehr-Events.
///
/// Deterministisch über `dayIndex % 365` (wie [BirthdayListener]) — kein
/// persistierter State, wiederholt sich jährlich. Reine Bildungs-Karten
/// ohne Geld-Effekt: Anti-Konsum OHNE Moralkeule — sie zeigen die
/// Konsequenz eines Impuls-Kaufs, verbieten aber nichts.
///
/// - **Neujahr** (Tag 1): kleiner, konkreter Spar-Vorsatz.
/// - **Frühjahrsputz** (Tag 80 ≈ Mitte März): aussortieren + Kaufimpuls
///   hinterfragen.
/// - **Steuer-Saison** (Tag 130 ≈ Mitte Mai): brutto vs netto.
/// - **Sommerferien-Minijob** (Tag 180 ≈ Anfang Juli): selbst verdienen +
///   einen Teil zurücklegen.
/// - **Neues Schuljahr** (Tag 250 ≈ Mitte September): Budget-Check vor
///   Neukäufen.
/// - **Welt-Spartag** (Tag 304 ≈ 31. Oktober): pay-yourself-first.
/// - **Black Friday** (Tag 332 ≈ Ende November): Rabatt-Falle.
/// - **Weihnachts-Geld** (Tag 359 ≈ 25./26. Dez, einen Tag nach dem
///   Geld-Geschenk aus dem [LuckyEventListener]): Tipp, einen Teil zur
///   Seite zu legen statt alles sofort auszugeben.
///
/// Slots bewusst kollisionsfrei zu Geburtstag (60/100), Ostern (110),
/// Konfirmation (200) + Weihnachten (358) aus Lucky/Birthday-Listenern.
class SeasonalEventListener implements DayEventListener {
  const SeasonalEventListener();

  static const int neujahrDayOfYear = 1;
  static const int fruehjahrsputzDayOfYear = 80;
  static const int steuerSaisonDayOfYear = 130;
  static const int ferienjobDayOfYear = 180;
  static const int schuljahrDayOfYear = 250;
  static const int weltSpartagDayOfYear = 304;
  static const int blackFridayDayOfYear = 332;
  static const int weihnachtsGeldDayOfYear = 359;

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    if (newDay.dayIndex <= 0) return const [];
    final dayInYear = newDay.dayIndex % 365;

    if (dayInYear == neujahrDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🎆 Neujahrs-Sparvorsatz',
          message:
              'Neues Jahr, neuer Plan! Viele nehmen sich teure Dinge vor '
              'und vergessen sie im Februar. Ein guter Geld-Vorsatz ist '
              'klein und konkret: jeden Monat einen festen Betrag zur Seite '
              'legen — egal wie wenig. Dranbleiben schlägt groß anfangen.',
        ),
      ];
    }

    if (dayInYear == fruehjahrsputzDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🧹 Frühjahrsputz',
          message:
              'Räum dein Zimmer auf und schau, was du wirklich nutzt. '
              'Vieles, das mal unbedingt sein musste, liegt jetzt ungenutzt '
              'rum. Kein Vorwurf — nur ein Tipp: Beim nächsten Kaufimpuls '
              'kurz fragen, ob das Ding in einem Jahr auch noch im '
              'Frühjahrsputz übersteht.',
        ),
      ];
    }

    if (dayInYear == steuerSaisonDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🧾 Steuer-Saison',
          message:
              'Erwachsene geben jetzt ihre Steuererklärung ab. Steuern '
              'klingen langweilig, zahlen aber Schule, Bus und Schwimmbad. '
              'Gut zu wissen: Von jedem verdienten Euro bleibt netto weniger '
              'übrig als brutto draufsteht — wer das einplant, erlebt beim '
              'ersten Job keine böse Überraschung.',
        ),
      ];
    }

    if (dayInYear == ferienjobDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '☀️ Sommerferien-Minijob',
          message:
              'Ferien! Gute Zeit, mit einem Minijob (Zeitung austragen, '
              'Nachhilfe, Rasen mähen) eigenes Geld zu verdienen. Tipp: '
              'Bevor du alles für den Sommer ausgibst, leg einen Teil für '
              'ein größeres Ziel zur Seite. Selbstverdientes fühlt sich '
              'anders an — und wächst, wenn man es nicht sofort verbrennt.',
        ),
      ];
    }

    if (dayInYear == schuljahrDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🎒 Neues Schuljahr — Budget-Check',
          message:
              'Neues Schuljahr, oft neuer Kram. Bevor alles neu gekauft '
              'wird: Was vom letzten Jahr tut es noch? Ein kurzer '
              'Kassensturz spart Geld für die Dinge, die wirklich kaputt '
              'sind. Budget heißt nicht geizig — es heißt, selbst '
              'entscheiden statt von Werbung entscheiden lassen.',
        ),
      ];
    }

    if (dayInYear == weltSpartagDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🐷 Welt-Spartag',
          message:
              'Heute ist Weltspartag — ein Tag fürs Sparen. Der Trick: Es '
              'muss nicht wehtun. Wenn du einen kleinen Teil sofort '
              'beiseitelegst, sobald Geld reinkommt (Taschengeld, Job), '
              'merkst du den Rest gar nicht erst als „weg". Zukunfts-Du '
              'sagt Danke.',
        ),
      ];
    }

    if (dayInYear == blackFridayDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🛍️ Black Friday',
          message:
              'Überall blinken Rabatte. Kleiner Merksatz: Ein Angebot ist '
              'nur dann ein guter Deal, wenn du die Sache sowieso gebraucht '
              'hättest. 50 % Rabatt auf etwas Unnötiges sind trotzdem '
              '100 % ausgegebenes Geld.',
        ),
      ];
    }

    if (dayInYear == weihnachtsGeldDayOfYear) {
      return const [
        DayEvent.seasonalEvent(
          title: '🎄 Weihnachtsgeld clever nutzen',
          message:
              'Du hast Geld geschenkt bekommen — schönes Gefühl! Tipp: leg '
              'einen Teil gleich zur Seite (z. B. aufs Spar-Konto oder in '
              'einen ETF), bevor du den Rest ausgibst. So bleibt vom Fest '
              'auch später noch etwas übrig.',
        ),
      ];
    }

    return const [];
  }
}
