import '../day_event.dart';
import '../day_event_listener.dart';
import '../game_day.dart';
import '../weather.dart';

/// Adapter so listener stays in `domain/` (no Riverpod import).
/// `features/weather/weather_state.dart` provides the concrete sink + the
/// deterministic `weatherForDay(int)` function.
abstract class WeatherDaySource {
  /// Returns the global weather for [dayIndex].
  Weather weatherForDay(int dayIndex);

  /// Side-effect: store this day's weather so the UI can react.
  void publish(int dayIndex);
}

/// Emits one [DayEvent.weather] per advance with the global weather of the
/// new day. The kind is deterministic per dayIndex (seeded RNG inside the
/// source). islandId is the constant `'global'` since weather is global
/// starting Sprint 7.
class WeatherListener implements DayEventListener {
  const WeatherListener(this._source);

  final WeatherDaySource _source;

  static const String globalIslandId = 'global';

  @override
  Future<List<DayEvent>> onDayAdvance(GameDay newDay) async {
    final kind = _source.weatherForDay(newDay.dayIndex);
    _source.publish(newDay.dayIndex);
    return [DayEvent.weather(islandId: globalIslandId, kind: kind)];
  }
}

class _EmptyWeatherSource implements WeatherDaySource {
  const _EmptyWeatherSource();
  @override
  Weather weatherForDay(int dayIndex) => Weather.sunny;
  @override
  void publish(int dayIndex) {}
}

/// Inert source used by tests that don't care about weather output.
const WeatherDaySource emptyWeatherSource = _EmptyWeatherSource();
