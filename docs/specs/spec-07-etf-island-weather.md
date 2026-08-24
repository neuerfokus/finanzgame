# Spec 07 — ETF-Insel + Wetter + Volatilität

## Goal

Zweite Insel: ETF-Insel. Spieler kauft Anteile an fiktiven ETFs (Körbe
mehrerer fiktiver Tickers), Wert ändert sich täglich abhängig von
Wetter + Volatilität. Wetter ist global pro Tag, nicht pro Insel —
beeinflusst alle Inseln. ETF-Insel wird durch Erreichen eines Spar-
Meilensteins freigeschaltet.

## Why

Pflanzen-Mechanik (Sparen) ist deterministisch. ETFs lehren Volatilität +
langfristigen Aufwärtstrend: schwankt täglich, wächst über Wochen.
Wetter macht das spürbar — Sonnenschein = grüner Tag, Sturm = Verluste.

## Non-Goals

- Echte Aktien-Tickers (Hardregel: nur fiktiv)
- Einzelaktien (Sprint 8 — Aktien-Archipel)
- Inflation (Sprint 9)
- Order-Book / Limit-Orders — nur Market-Buy/Sell zu Tagesschluss-Kurs

## Domain Model

### Fiktive ETFs

```dart
abstract final class EtfCatalog {
  static const weltKorb = EtfSpec(
    id: 'welt_korb',
    name: 'Welt-Korb',
    baseDriftPerDay: 0.0015,    // ≈ +5.6%/Jahr average
    volatility: 0.012,           // daily stddev
  );
  static const techKorb = EtfSpec(
    id: 'tech_korb',
    name: 'Tech-Korb',
    baseDriftPerDay: 0.0020,
    volatility: 0.025,
  );
  static const all = [weltKorb, techKorb];
}

class EtfSpec {
  String id; String name;
  double baseDriftPerDay;
  double volatility;
}

@freezed class EtfHolding {  // one row per ETF the player owns
  String etfId;
  int shares;
  Money averageBuyPrice;  // for P&L display
}

@freezed class EtfQuote {    // current price per share
  String etfId;
  Money pricePerShare;
  int onDayIndex;            // last update day
}
```

### Wetter (global)

```dart
enum WeatherKind { sonnig, bewoelkt, regen, sturm }

@freezed class WeatherDay {
  int dayIndex;
  WeatherKind kind;
}

// Effect on ETF return: sonnig +0.5%, bewoelkt 0, regen -0.3%, sturm -1.5%.
```

`WeatherListener` (Sprint 1 stub) emits `WeatherEvent(islandId='global', kind=...)`
per `advanceDay()` using a seeded RNG (deterministic for tests).

## Pipeline integration

Add a new stage AFTER weather, BEFORE birthday:

```
allowance → interest → plant → inflation → weather → etfPrice → birthday → temptation
```

Update spec-01 pipeline-order comment in `lib/core/game_clock.dart`.

`EtfPriceListener` reads today's weather + each `EtfSpec` and updates
`EtfQuote` per ETF. Emits `EtfPriceUpdateEvent(etfId, newPrice, deltaPct)`.

## State

```
lib/features/etf/
  etf_state.dart        # Riverpod: List<EtfHolding> + Map<String,EtfQuote>
  etf_repository.dart   # buy/sell + price tick
lib/features/weather/
  weather_state.dart    # current global WeatherDay
```

In-memory per [[../../../../Claude_Code_projects/Finanzgame_neu/CLAUDE.md]] convention until DB-foundation lands.

## Flame Scene + UI

`lib/game/monetaria/islands/etf_island_world.dart` — single building
("Börse"), tap → push `EtfTradePage`.

`EtfTradePage`:
- Liste aller `EtfSpec` mit aktuellem Quote + Tagesveränderung farbig
- Buy/Sell-Buttons → Modal mit Mengen-Stepper
- Eigene Holdings + Gesamtwert + P&L

Wetter-Badge oben im PhoneFrame zeigt aktuellen `WeatherKind` als Emoji.

## Unlock

Mischwald bleibt locked. ETF-Insel statt Mischwald freischalten wenn
`cashState + plantValue ≥ 5€`. Migration: rename Mischwald → ETF in
`kIslandSpecs` ODER neue 4. Insel-Position einfügen. (Empfehlung:
4. Insel — keine Renames, klare Trennung.)

## Tests

- Unit: `EtfPriceListener` mit fester Seed → deterministische Preisreihe über 30 Tage
- Unit: Wetter-Multiplier-Tabelle korrekt angewandt
- Unit: `EtfRepository.buy` deduct cash + adds holding, `sell` reverse
- Widget: `EtfTradePage` zeigt Quotes + reagiert auf Buy-Tap
- Integration: 30x `advanceDay` mit gehaltenem `welt_korb` → Endwert > Anfangswert (positiver Drift)

## Acceptance

- [ ] `EtfSpec`, `EtfHolding`, `EtfQuote`, `WeatherDay` Freezed
- [ ] `WeatherListener` real (seeded RNG, deterministisch)
- [ ] `EtfPriceListener` neue Pipeline-Stage zwischen weather + birthday
- [ ] `EtfRepository` mit buy/sell, hält Holdings + Quotes
- [ ] `EtfTradePage` + Buy/Sell Modal
- [ ] ETF-Insel als 4. Insel in `kIslandSpecs`, unlocked nach Spar-Meilenstein
- [ ] Wetter-Badge im PhoneFrame
- [ ] Tests grün, analyze clean
- [ ] Commit: `feat(etf): add ETF-Insel with weather-driven volatility`

## Done When

Spieler tippt ETF-Insel, kauft 1 Anteil `welt_korb`, schläft 30 Tage,
sieht Preisschwankungen je nach Wetter, verkauft mit Gewinn.
