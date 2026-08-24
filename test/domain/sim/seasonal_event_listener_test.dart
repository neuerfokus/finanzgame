import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/seasonal_event_listener.dart';

void main() {
  const listener = SeasonalEventListener();
  Future<List<DayEvent>> on(int day) =>
      listener.onDayAdvance(GameDay.fromIndex(day));

  group('SeasonalEventListener (Round 28)', () {
    test('Black Friday an Tag 332', () async {
      final events = await on(332);
      expect(events, hasLength(1));
      expect(events.single, isA<SeasonalEvent>());
      expect((events.single as SeasonalEvent).title, contains('Black Friday'));
    });

    test('Weihnachtsgeld-Tipp an Tag 359', () async {
      final events = await on(359);
      expect(events, hasLength(1));
      expect((events.single as SeasonalEvent).title, contains('Weihnachts'));
    });

    test('wiederholt sich jährlich (Tag 332 + 365)', () async {
      final events = await on(332 + 365);
      expect(events, hasLength(1));
      expect((events.single as SeasonalEvent).title, contains('Black Friday'));
    });

    test('normaler Tag + Tag 0 → keine Events', () async {
      expect(await on(100), isEmpty);
      expect(await on(0), isEmpty);
      expect(await on(331), isEmpty);
    });

    // Optionen-Backlog #3: neue Jahres-Events.
    final newSlots = <int, String>{
      1: 'Neujahr',
      80: 'Frühjahrsputz',
      130: 'Steuer',
      180: 'Sommerferien',
      250: 'Schuljahr',
      304: 'Spartag',
    };
    newSlots.forEach((day, hint) {
      test('Saison-Event an Tag $day ($hint)', () async {
        final events = await on(day);
        expect(events, hasLength(1), reason: 'Tag $day soll 1 Event geben');
        final e = events.single;
        expect(e, isA<SeasonalEvent>());
        final title = (e as SeasonalEvent).title;
        // Render-Vertrag (day_summary_screen): title = 'Emoji<space>Text'.
        expect(title.contains(' '), isTrue,
            reason: 'title "$title" braucht Emoji + Leerzeichen');
        expect(title.indexOf(' '), greaterThan(0));
      });
    });

    test('alle Event-Slots disjunkt (keine Doppel-Belegung)', () {
      const slots = [
        SeasonalEventListener.neujahrDayOfYear,
        SeasonalEventListener.fruehjahrsputzDayOfYear,
        SeasonalEventListener.steuerSaisonDayOfYear,
        SeasonalEventListener.ferienjobDayOfYear,
        SeasonalEventListener.schuljahrDayOfYear,
        SeasonalEventListener.weltSpartagDayOfYear,
        SeasonalEventListener.blackFridayDayOfYear,
        SeasonalEventListener.weihnachtsGeldDayOfYear,
      ];
      expect(slots.toSet().length, slots.length);
      // Kollisionen mit Birthday(100)/Ostern(110)/Konfirmation(200)/
      // Weihnachten(358)/Geburtstag(60) vermeiden.
      const blocked = {60, 100, 110, 200, 358};
      for (final s in slots) {
        expect(blocked.contains(s), isFalse, reason: 'Slot $s kollidiert');
      }
    });
  });
}
