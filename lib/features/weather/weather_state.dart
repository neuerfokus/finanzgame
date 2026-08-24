import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/sim/listeners/weather_listener.dart';
import '../../domain/sim/rng.dart';
import '../../domain/sim/weather.dart';

part 'weather_state.g.dart';

/// Maps a `GameDay.dayIndex` to a deterministic [Weather] via a fixed seed.
/// Same dayIndex → same Weather, run after run.
/// Ein Spieljahr Wetter als Deck: 128 sonnig · 128 bewölkt · 80 Regen ·
/// 29 Sturm = 365 Karten, also exakt die geplanten 35/35/22/8.
///
/// Balance-Analyse 2026-08: vorher wurde pro Tag unabhängig gewürfelt, und
/// zwar über `math.Random(0xF1A2B3 ^ (dayIndex * K))` — benachbarte Seeds,
/// korrelierte Erstausgaben. Die tatsächlich gezogene Verteilung wich damit
/// messbar von den Zielanteilen ab. Weil das Wetter auf die Kurse einzahlt
/// (und `weatherDelta` einen negativen Erwartungswert hat), wurde daraus ein
/// dauerhafter, für jeden Spieler identischer Renditeabzug. Als Deck stimmt
/// die Jahresmischung exakt, die Reihenfolge bleibt zufällig.
final List<Weather> _weatherYearDeck = [
  ...List<Weather>.filled(128, Weather.sunny),
  ...List<Weather>.filled(128, Weather.cloudy),
  ...List<Weather>.filled(80, Weather.rain),
  ...List<Weather>.filled(29, Weather.storm),
];

Weather rollWeather(int dayIndex) =>
    dealCard(0xF1A2B3, dayIndex, _weatherYearDeck);

/// Current day's weather. Updated by [WeatherListener] on each
/// `advanceDay()`. Defaults to sunny on day 0.
@Riverpod(keepAlive: true)
class WeatherState extends _$WeatherState implements WeatherDaySource {
  @override
  Weather build() => rollWeather(0);

  @override
  Weather weatherForDay(int dayIndex) => rollWeather(dayIndex);

  @override
  void publish(int dayIndex) {
    state = rollWeather(dayIndex);
  }
}
