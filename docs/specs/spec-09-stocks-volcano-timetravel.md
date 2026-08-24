# Spec 09 — Aktien-Archipel + Vulkan-Insel + Zeitreise

## Goal

Drei zusammenhängende Mechaniken:

1. **Aktien-Archipel** — Einzelaktien (fiktiv) mit höherer Volatilität als
   ETFs. Spieler sieht Tageskurse, kauft/verkauft mit Market-Orders.
2. **Vulkan-Insel** — Seltenes Crash-Event (~2%/Tag) das alle Aktien-Kurse
   um 20–50% drückt. Eruption-Cutscene mit Juice.
3. **Zeitreise** — Verlauf einsehen: Liniendiagramm der letzten N Tage
   pro Asset (ETF + Aktien). Keine echte Rückreise — nur History-Viewer.

## Why

ETFs sind diversifiziert + ruhig. Einzelaktien lehren: höhere Chance,
höheres Risiko. Vulkan macht Crash spürbar → "warum war breit gestreut
besser?". Zeitreise zeigt dem Spieler **objektiv** die Konsequenz seiner
Entscheidungen (Sparen vs. Sneaker vs. Aktie).

## Non-Goals

- Echte Aktien-Tickers (Hardregel — fiktiv)
- Optionen / Hebel / Short-Selling
- Dividenden (Sprint 10+)
- News-Feed
- Speichern des History-Verlaufs (Sprint = DB-Foundation)

## Domain Model

### Stock

```dart
class StockSpec {
  String id;                   // 'aktie_fluxon'
  String name;                 // 'Fluxon AG'
  double baseDriftPerDay;      // higher than ETFs
  double volatility;           // 2x-3x ETF volatility
  Money initialPrice;
  String? correlationGroup;    // 'tech' | 'industrial' | null
}

abstract final class StockCatalog {
  static const fluxon = StockSpec(id: 'aktie_fluxon', name: 'Fluxon AG', baseDriftPerDay: 0.0025, volatility: 0.035, initialPrice: Money.cents(8000), correlationGroup: 'tech');
  static const skyrail = StockSpec(id: 'aktie_skyrail', name: 'Skyrail Co', baseDriftPerDay: 0.0010, volatility: 0.020, initialPrice: Money.cents(5000), correlationGroup: 'industrial');
  static const novabank = StockSpec(id: 'aktie_novabank', name: 'Novabank', baseDriftPerDay: 0.0015, volatility: 0.025, initialPrice: Money.cents(12000), correlationGroup: null);
  static const all = [fluxon, skyrail, novabank];
}
```

Reuse `EtfHolding` / `EtfQuote` shape — rename module-level types to
`AssetHolding` / `AssetQuote` if needed, or duplicate for now to keep
patch small. **Empfehlung:** neue `StockHolding` / `StockQuote` (klare
Trennung, kein riskanter Rename).

### Crash-Event

```dart
@FreezedUnionValue('crash')
const factory DayEvent.crash({
  required double dropPct,         // 0.20-0.50
  required List<String> affectedAssetIds,
}) = CrashEvent;
```

Crash bumps both ETF + Stock quotes negativ. ~2% Wahrscheinlichkeit pro
Tag, seeded by `(dayIndex, 0xCRASH)`.

## Pipeline

Neue Stage `crash` **NACH** `etfPrice` (so Crashes überschreiben
normalen Tages-Move):

```
allowance → interest → plant → inflation → weather → etfPrice → stockPrice → crash → birthday → temptation
```

Update spec-01 pipeline comment.

## Listeners

`StockPriceListener` analog `EtfPriceListener` (gleiche Box-Muller-Logik,
andere Kataloge). Wetter-Delta wirkt schwächer (Aktien weniger Wetter-
sensitiv): 50% des ETF-Multipliers.

`CrashListener`:
1. Rolle p ~ U(0,1). p < 0.02 → Crash today.
2. Drop = U(0.20, 0.50) per RNG.
3. Multipliziere alle Stock- und ETF-Quotes mit `1 - drop`.
4. Emit `DayEvent.crash`.

## Vulkan-Insel UI

6. Insel in `kIslandSpecs`. Eigene `VulkanIslandPage`:
- Großer Vulkan-Sprite (Primitives bis Sprite landed)
- Letzte Eruption Datum + Drop %
- "Eruption-History" Liste

Bei Crash während `advanceDay`: SleepCutscene/DaySummary zeigt Crash mit
fettem 💥-Emoji + Screen-Shake im Day-Summary.

## Aktien-Trade UI

Wiederverwende `EtfTradePage` Layout. Neue `StockTradePage` Liste +
gleicher Mengen-Stepper. `IslandPage(aktienArchipel)` → push it.

## Zeitreise

7. Insel `zeitreise` (oder Settings-Eintrag? — Empfehlung: AppIcon
„Zeitreise" auf Springboard ist eh schon stub'd, jetzt aktivieren).

`HistoryRepository`:
```dart
@Riverpod(keepAlive: true)
class HistoryRepository extends _$HistoryRepository {
  @override
  Map<String, List<Money>> build();   // assetId → daily prices

  void recordToday(int dayIndex, Map<String, Money> snapshot);
}
```

`GameClock.advanceDay()` ruft nach dem Pipeline-Run `HistoryRepository.recordToday(...)`
mit allen aktuellen ETF + Stock Preisen.

`ZeitreisePage`:
- Asset-Auswahl Dropdown
- Mini-Liniendiagramm (Custom-Painter, kein Chart-Lib — bleibt asset-free)
- Tage seit Tag 0

## Tests

- Unit: StockPriceListener wie ETF (Determinismus, Wetter-Multi halbiert)
- Unit: CrashListener — fixed seed → reproduzierbarer Crash-Tag, Drop angewandt
- Unit: HistoryRepository — recordToday speichert per Asset
- Integration: 100x advanceDay → mindestens 1 Crash, Stocks mehr Drift als ETFs
- Widget: VulkanIslandPage zeigt Eruption-History

## Acceptance

- [ ] StockSpec + Catalog (3 fiktive)
- [ ] StockHolding + StockQuote Freezed
- [ ] StockRepository (analog EtfRepository, kein RepoDuplikation-Refactor)
- [ ] StockPriceListener neue Pipeline-Stage
- [ ] CrashListener + DayEvent.crash + crash Stage
- [ ] HistoryRepository, in GameClock.advanceDay verdrahtet
- [ ] VulkanIslandPage, AktienArchipelPage, ZeitreisePage
- [ ] 6./7. Insel in kIslandSpecs (aktienArchipel, vulkan)
- [ ] Springboard Zeitreise-AppIcon → ZeitreisePage
- [ ] DaySummary rendert CrashEvent fettgedruckt
- [ ] Tests grün, analyze clean
- [ ] Commit: `feat(market): add stocks, volcano crashes, time-travel history`

## Done When

Spieler kauft Fluxon-Aktie, schläft 100 Tage, sieht 1+ Crash-Tag mit
Vulkan-Cutscene, öffnet Zeitreise und sieht Fluxon-Verlauf als
Liniendiagramm.
