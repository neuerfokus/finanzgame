# Spec 08 — Inflations-Atoll + Wunschliste mit dynamischen Preisen

## Goal

Dritte echte Insel: Inflations-Atoll. Spieler sieht eine **Wunschliste**
mit fiktiven Konsumgütern (`SnipeShot` Sneaker, `DropTok` Premium etc.).
Preise steigen langsam über Zeit durch Inflations-Pipeline-Stage. Wenn
Spieler ein Wunschobjekt kauft, fließt Cash raus — sichtbarer Trade-off
gegen Sparen/ETF/Pflanzen.

## Why

Anti-Konsum-Haltung **ohne Moralkeule** (CLAUDE.md Hardregel). Wunsch-
liste zeigt: heute warten = morgen teurer, aber heute kaufen = weniger
für Ernte/ETF. Spieler entscheidet selbst, sieht Konsequenz im
Day-Summary.

## Non-Goals

- Echte Marken (Hardregel — nur `SnipeShot`, `DropTok`, weitere fiktiv)
- Limited-Drop-Mechaniken (kein FOMO)
- Lootboxen / Glücksspiel (Hardregel)
- Persistenz (in-memory bis DB-Foundation)

## Domain Model

### WishItem

```dart
@freezed abstract class WishItem {
  String id;                    // 'sneaker_quantum_x'
  String name;                  // 'SnipeShot Quantum X'
  String category;              // 'sneaker' | 'social' | 'snack' | 'game'
  Money basePrice;              // initial sticker price
  Money currentPrice;           // updated by InflationListener
  String emoji;                 // '👟'
  String? owned;                // dayIndex bought, null = not owned
}
```

### Inflation rate

```dart
abstract final class InflationConfig {
  static const double dailyRate = 0.0008;  // ≈ +25%/Jahr
  static const double categoryJitter = 0.0005;  // per category
}
```

Sneakers + Social drift faster than Snacks/Games (Phase-1 only —
balancing fine-tunes later).

## Pipeline integration

`InflationListener` runs in existing `inflation` stage (already in
pipeline order). Reads `WishlistRepository.activeItems`, increases
`currentPrice` per `dailyRate + categoryJitter`. Emits
`DayEvent.inflation(rate, affectedItemIds)` once per day (one event,
not per item — collapse into one for UI).

## Repository

```dart
@Riverpod(keepAlive: true)
class WishlistRepository extends _$WishlistRepository {
  @override
  List<WishItem> build();    // seeded from kWishCatalog

  List<WishItem> active();   // not yet owned
  void inflate(double rate); // bumps prices
  void buy(String itemId);   // deduct cash, mark owned, emit no event itself
}
```

## Flame Scene

`lib/game/monetaria/islands/inflation_atoll_world.dart`:
- Grass background, 1 building "Markt"
- Tap → push `WishlistPage`

## UI

`WishlistPage`:
- Cards per category, each WishItem zeigt:
  - Emoji, Name, currentPrice
  - "Vor X Tagen war es Y€" (basePrice vs currentPrice delta)
  - Kaufen-Button → confirm modal → deduct cash, mark owned
- "Owned" Items in separater Sektion „Deine Sachen"

## Wishlist-Katalog

Initial 6 Items, fiktiv:

```dart
const kWishCatalog = [
  WishItem(id: 'sneaker_quantum_x', name: 'SnipeShot Quantum X', category: 'sneaker', basePrice: Money.cents(8000), emoji: '👟'),
  WishItem(id: 'sneaker_pulse', name: 'SnipeShot Pulse', category: 'sneaker', basePrice: Money.cents(4500), emoji: '👟'),
  WishItem(id: 'social_premium', name: 'DropTok Plus 1M', category: 'social', basePrice: Money.cents(900), emoji: '✨'),
  WishItem(id: 'snack_xxl', name: 'XXL Snack-Box', category: 'snack', basePrice: Money.cents(300), emoji: '🍫'),
  WishItem(id: 'game_seasonpass', name: 'Game Season-Pass', category: 'game', basePrice: Money.cents(2000), emoji: '🎮'),
  WishItem(id: 'sneaker_apex', name: 'SnipeShot Apex (Limited)', category: 'sneaker', basePrice: Money.cents(15000), emoji: '👟'),
];
```

## Island wire

Add `IslandId.inflationAtoll` as 5. island in `kIslandSpecs`. Default-
unlocked (gating TODO). `IslandPage(inflationAtoll)` → `WishlistPage`.

## Tests

- Unit: `InflationListener` mit fake repo → preise steigen, ein Event/Tag
- Unit: `WishlistRepository.buy` deduct cash, mark owned, raise on broke
- Unit: `inflate(rate)` multipliziert currentPrice korrekt, owned items skipped
- Widget: WishlistPage zeigt Items + reagiert auf Buy-Tap
- Integration: 30x advanceDay → SnipeShot Pulse zb +6% drift

## Acceptance

- [ ] WishItem Freezed + kWishCatalog
- [ ] WishlistRepository (Riverpod, keepAlive) mit active/inflate/buy
- [ ] InflationListener echt, pipeline-stage wired
- [ ] InflationAtoll Flame world + Markt building
- [ ] WishlistPage UI mit Buy-Confirm
- [ ] 5. Insel in kIslandSpecs (inflationAtoll) + IslandPage routing
- [ ] Tests grün, analyze clean
- [ ] Commit: `feat(inflation): add Inflations-Atoll with dynamic-price wishlist`

## Done When

Spieler tippt Inflations-Atoll, sieht Wunschliste mit 6 Items, kauft
SnipeShot Pulse, sieht Cash sinken. Nach 30x Schlafen ist
SnipeShot Apex spürbar teurer. Owned-Items zeigen "Hast du".
