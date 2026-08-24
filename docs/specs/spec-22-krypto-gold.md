# Spec 22 — Krypto + Edelmetalle als Asset-Klassen

## Goal

Zwei neue Asset-Klassen mit eigenen Insel-Mechaniken:
1. **Krypto-Vulkan** — Vulkan-Insel wird zur Bitcoin-Insel (Vulkan-
   Aktivität bleibt erhalten als Crash-Volatilität).
2. **Goldminen-Insel** — neue Insel für Gold + Silber + Edelmetalle als
   Inflations-Schutz.

## Why

Sohn-Feedback: „Es fehlt als Assets auch noch Bitcoin, Gold usw.? …
Bitcoin Vulkan, Edelsteine, Gold und Edelmetalle extra Insel?"

Beide Klassen sind im Real-Life finanzbildungs-relevant: Krypto = extreme
Volatilität + Hype-Lehre, Gold = Inflations-Hedge + Wertspeicher.

## Non-Goals

- Realweltliche Coins (Hardregel: fiktiv). Verwende `RugCoin`, `PixelBit`,
  `ChainKraken`.
- Mining-Mechanik mit Strom-Kosten (zu komplex)
- Echte Gold-Preise (fiktive deterministische Reihe)

## Mechanik

### Krypto-Vulkan

Vulkan-Insel doppelt sich: bleibt Crash-Lehrkonzept **UND** wird
Trade-Insel für Crypto.

- 3 fiktive Coins: `RugCoin` (extreme Vola, ±15% pro Tag), `PixelBit`
  (hoch, ±8%), `ChainKraken` (mittel, ±5%).
- Jeden Tag: Preis = `prevPrice * (1 + rand[-vola, +vola])` mit Seed
  aus `dayIndex` (deterministisch).
- Bei Vulkan-Crash-Event (1% Wahrscheinlichkeit/Tag): **alle Coins
  -50% bis -80%**. Klassische Krypto-Crash-Lehre.
- Insel-Lesson erklärt: Krypto kann sich vervielfachen oder fast Null
  werden; **niemals mehr investieren als man bereit ist zu verlieren**.

Trade-UI ähnlich `StockTradePage` aber dramatischer:
- 24h-Change in % groß rot/grün
- „Wenn du gestern gekauft hättest..."-Hint

### Goldminen-Insel

Neue Insel-ID `goldmine`. Liegt zwischen Spar-Insel und Inflations-Atoll.
Identity-Eintrag in spec-16 erweitern.

- 3 Edelmetalle: `Gold`, `Silber`, `Platin`.
- Preise wachsen leicht mit Inflation (`InflationListener`): Pro
  +1% Inflation steigt Gold +1.2%, Silber +0.8%, Platin +1%. Bewusst
  „träges Wertspeicher"-Verhalten.
- Volatilität gering: ±1.5% pro Tag (Random).
- Unlock-Bedingung: nach Inflations-Atoll-Unlock (spec-13 erweitern).

Trade-UI: identisch StockTradePage Layout, andere Asset-Liste.

### Insel-Lesson Edelmetalle

> Gold und Silber halten ihren Wert über Zeit. Wenn Geld weniger wert
> wird (Inflation), steigen ihre Preise. Sie schwanken weniger als
> Aktien, wachsen aber auch langsamer. Klassischer „sicherer Hafen".

## Drift-Schema

Bestehende `StockHoldingsTable`/`StockQuotesTable` reused mit
`assetClass` Spalte? Sauberer: getrennte Tabellen pro Klasse, gleiche
Form:
- `CryptoHoldingsTable`, `CryptoQuotesTable`
- `MetalHoldingsTable`, `MetalQuotesTable`

Catalog-Definitionen in `lib/domain/crypto/crypto.dart` +
`lib/domain/metal/metal.dart`.

## Listeners

- `CryptoPriceListener` (in GameClock nach `StockPriceListener`)
- `MetalPriceListener` (liest Inflations-Event vom gleichen Tag)
- Vulkan-Crash-Hook erweitern: triggert auch Crypto-Crash

## Files

- `lib/domain/crypto/crypto.dart` NEU (Freezed + Catalog)
- `lib/domain/metal/metal.dart` NEU
- `lib/features/crypto/crypto_repository.dart` + `crypto_trade_page.dart` NEU
- `lib/features/metal/metal_repository.dart` + `metal_trade_page.dart` NEU
- `lib/domain/sim/listeners/crypto_price_listener.dart` NEU
- `lib/domain/sim/listeners/metal_price_listener.dart` NEU
- `lib/data/db/tables.dart` + DAOs
- `lib/game/monetaria/state/monetaria_state.dart` — neue Insel `goldmine`
- `lib/features/monetaria/island_page.dart` — Vulkan = Crypto-Trade,
  Goldmine = Metal-Trade
- spec-16 IslandIdentity-Map: Vulkan-Glyph 🌋→₿, Goldmine 🪙

## Tests

- Pure: CryptoPriceListener deterministische Roll
- Pure: MetalPriceListener mit Inflations-Event-Mock
- Crash: Vulkan-Crash macht Crypto -50% bis -80%
- Round-trip: Crypto/Metal Holdings + Quotes

## Acceptance

- [ ] 3 Krypto-Coins, 3 Metalle
- [ ] Vulkan-Insel zeigt Crypto-Trade-UI (bestehende Vulkan-Crash-
       Storyline bleibt erhalten in DaySummary)
- [ ] Neue Goldminen-Insel + Identity + Unlock-Regel
- [ ] Inflations-Atoll-Unlock triggert Goldmine-Unlock
- [ ] Vulkan-Crash trifft Crypto + Aktien
- [ ] Insel-Lessons für Krypto + Edelmetalle
- [ ] Bestehende Tests grün
- [ ] Neue Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(asset): crypto coins on vulkan + gold mine island`

## Done When

Sohn betritt Vulkan → sieht 3 Krypto-Coins mit dramatischen Preis-
Schwankungen. Inflation steigt → Gold-Preis steigt mit. Crash-Tag →
Crypto bricht massiv ein.
