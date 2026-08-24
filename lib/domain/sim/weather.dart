/// Weather condition emitted by the WeatherListener once per game day.
///
/// Global per day (not per island) starting Sprint 7. ETF returns and
/// plant growth modifiers consult the day's weather.
enum Weather { sunny, cloudy, rain, storm }

/// Growth-speed multiplier applied to plants on a given weather day.
///
/// Sun favours light-loving species, rain is best, storm slows them
/// down to a crawl. See spec-18.
double growthMultiplier(Weather w) => switch (w) {
      Weather.sunny => 1.2,
      Weather.cloudy => 1.0,
      Weather.rain => 1.3,
      Weather.storm => 0.5,
    };

/// Harvest-yield multiplier applied at the moment of harvest based on
/// the weather on the harvest day. See spec-18.
double yieldMultiplier(Weather w) => switch (w) {
      Weather.sunny => 1.1,
      Weather.cloudy => 1.0,
      Weather.rain => 1.05,
      Weather.storm => 0.7,
    };

/// Human-readable label per weather kind, shown in the Springboard pill
/// and Day-Summary entry. Spec-18.
String weatherLabel(Weather w) => switch (w) {
      Weather.sunny => 'Sonne',
      Weather.cloudy => 'Wolken',
      Weather.rain => 'Regen',
      Weather.storm => 'Sturm',
    };

/// Emoji glyph per weather kind. Spec-18.
String weatherEmoji(Weather w) => switch (w) {
      Weather.sunny => '☀',
      Weather.cloudy => '☁',
      Weather.rain => '🌧',
      Weather.storm => '⛈',
    };

/// Verbal description of the weather's effect on plant growth.
/// Used by DaySummary. Spec-18.
String describePlantImpact(Weather w) => switch (w) {
      Weather.sunny => 'Pflanzen wachsen +20% schneller',
      Weather.cloudy => 'Pflanzen wachsen normal',
      Weather.rain => 'Pflanzen wachsen +30% schneller',
      Weather.storm => 'Pflanzen wachsen halb so schnell, Sturm-Risiko',
    };

/// Verbal description of the weather's effect on ETF prices.
/// Used by DaySummary. Spec-18.
String describeEtfImpact(Weather w) => switch (w) {
      Weather.sunny => 'ETF-Anteile leicht positiv',
      Weather.cloudy => 'ETF-Anteile neutral',
      Weather.rain => 'ETF-Anteile leicht positiv',
      Weather.storm => 'ETF-Anteile unter Druck',
    };
