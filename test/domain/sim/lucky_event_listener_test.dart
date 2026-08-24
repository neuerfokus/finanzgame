import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/sim/day_event.dart';
import 'package:finanzgame/domain/sim/game_day.dart';
import 'package:finanzgame/domain/sim/listeners/lucky_event_listener.dart';

/// Pech-Bias: die zufälligen Glücks-/Pech-Events sollen mehrheitlich Pech
/// sein (User-Feedback: Pech war unterrepräsentiert). Garantierte Jahres-
/// Feste sind immer positiv und werden hier ausgeklammert.
const _festDaysInYear = {60, 110, 200, 358};

void main() {
  test('Zufalls-Events sind mehrheitlich Pech (~60 %)', () async {
    const listener = LuckyEventListener(startAgeYears: 14);
    var pos = 0;
    var neg = 0;
    for (var d = 0; d < 7300; d++) {
      // Feste (immer positiv) ausklammern — wir testen nur den Zufallspool.
      if (_festDaysInYear.contains(d % 365)) continue;
      final events = await listener.onDayAdvance(GameDay.fromIndex(d));
      for (final e in events) {
        if (e is LuckyEvent) {
          if (e.amount.cents < 0) {
            neg++;
          } else {
            pos++;
          }
        }
      }
    }
    final total = pos + neg;
    expect(total, greaterThan(40), reason: 'genug Stichprobe');
    expect(neg, greaterThan(pos), reason: 'Pech überwiegt');
    final share = neg / total;
    expect(share, inInclusiveRange(0.45, 0.75),
        reason: 'Pech-Anteil ~60 %, war $share');
  });

  test('pechBias 0 → fast nur Glück', () async {
    const listener = LuckyEventListener(startAgeYears: 14, pechBias: 0.0);
    var neg = 0;
    for (var d = 0; d < 3650; d++) {
      if (_festDaysInYear.contains(d % 365)) continue;
      final events = await listener.onDayAdvance(GameDay.fromIndex(d));
      for (final e in events) {
        if (e is LuckyEvent && e.amount.cents < 0) neg++;
      }
    }
    expect(neg, 0, reason: 'bei Bias 0 keine negativen Zufalls-Events');
  });
}
