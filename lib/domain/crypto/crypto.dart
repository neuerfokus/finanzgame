import 'package:freezed_annotation/freezed_annotation.dart';

import '../economy/money.dart';
import '../economy/money_json_converter.dart';

part 'crypto.freezed.dart';
part 'crypto.g.dart';

/// Static config for one fictive crypto coin. Hardregel: no real coin names.
/// Spec-22: extreme volatility, no underlying drift — coins are pure
/// random-walk and crash-vulnerable.
class CryptoSpec {
  const CryptoSpec({
    required this.id,
    required this.name,
    required this.glyph,
    required this.basePrice,
    required this.volatility,
    this.priceGroupId,
  });

  final String id;
  final String name;
  final String glyph;
  final Money basePrice;

  /// Per-day uniform `[-vola, +vola]` swing. Spec-26 reduced catalog:
  /// Bitcoin (`bitcoin`, ~0.04 vola, serious-volatile) and a generic
  /// "Krypto-Casino" basket (`krypto`, ~0.12 vola, pump-and-dump).
  final double volatility;

  /// Bug-fix v26: alle Bitcoin-Stückelungen teilen denselben Underlying.
  /// `priceGroupId` bündelt Specs, die proportional miteinander laufen
  /// müssen (gleicher Tages-Swing). Null = eigene Gruppe.
  final String? priceGroupId;

  String get groupId => priceGroupId ?? id;
}

/// Erlaubtes Preisband pro Gruppe, als Faktor auf `basePrice`.
///
/// EINE Quelle der Wahrheit für zwei Stellen, die zusammenpassen MÜSSEN:
/// der Tages-Clamp im `CryptoPriceListener` und das Reseed-Band beim Laden
/// im `CryptoRepository`. Drifted der Kurs aus dem Reseed-Band heraus, setzt
/// der nächste App-Start ihn auf die Basis zurück — genau daraus entstand
/// der Cent-Exploit: Casino-Kurs fiel auf 1 ¢ (Random-Walk hatte
/// ≈ −9,7 %/Tag geometrischen Drift), Spieler kaufte 10.000 Anteile für
/// 100 €, Neustart reseedete auf 150 € → 1,5 Mio €. Solange der Listener
/// INNERHALB des Reseed-Bands clampt, kann das nie wieder passieren.
class CryptoPriceBand {
  const CryptoPriceBand(this.lo, this.hi);
  final double lo;
  final double hi;

  /// Bitcoin: weites Band, damit der Lebenszeit-Korridor (~16k-250k €/BTC
  /// aus dem Year-Regime) App-Neustarts überlebt.
  static const bitcoin = CryptoPriceBand(0.25, 4.0);

  /// Casino: ±70 % um die feste Basis — exakt die dokumentierte Vorgabe
  /// „Basis 150 € × Zufallsfaktor, Min 45 €, Max 255 €". Vorher war das
  /// Reseed-Band mit [0.4×, 1.4×] ENGER als die Kursspanne → Reseed feuerte
  /// im Normalbetrieb.
  static const casino = CryptoPriceBand(0.3, 1.7);

  static CryptoPriceBand forGroup(String groupId) =>
      groupId == 'bitcoin' ? bitcoin : casino;

  int loCentsFor(int baseCents) => (baseCents * lo).round().clamp(1, 1 << 30);
  int hiCentsFor(int baseCents) => (baseCents * hi).round().clamp(1, 1 << 30);
}

abstract final class CryptoCatalog {
  /// Bitcoin — the "serious" volatile coin. Higher unit price, lower swing.
  // Welle-8 Round 22: BTC = 63.000 € pro 1 BTC (Real-Stand 2026-05-31,
  // User-Korrektur). Alle Stückelungen proportional: 0,0001 = 6,30 €,
  // 1 BTC = 63.000 €.
  static const bitcoinMikro = CryptoSpec(
    id: 'crypto_bitcoin_mikro',
    name: 'Bitcoin (0,0001 BTC)',
    glyph: '₿',
    basePrice: Money.cents(630),        // 6,30 €
    volatility: 0.04,
    priceGroupId: 'bitcoin',
  );
  static const bitcoin = CryptoSpec(
    id: 'crypto_bitcoin',
    name: 'Bitcoin (0,001 BTC)',
    glyph: '₿',
    basePrice: Money.cents(6300),       // 63 €
    volatility: 0.04,
    priceGroupId: 'bitcoin',
  );
  static const bitcoinGross = CryptoSpec(
    id: 'crypto_bitcoin_gross',
    name: 'Bitcoin (0,01 BTC)',
    glyph: '₿',
    basePrice: Money.cents(63000),      // 630 €
    volatility: 0.04,
    priceGroupId: 'bitcoin',
  );
  static const bitcoinZehntel = CryptoSpec(
    id: 'crypto_bitcoin_zehntel',
    name: 'Bitcoin (0,1 BTC)',
    glyph: '₿',
    basePrice: Money.cents(630000),     // 6.300 €
    volatility: 0.04,
    priceGroupId: 'bitcoin',
  );
  static const bitcoinGanz = CryptoSpec(
    id: 'crypto_bitcoin_ganz',
    name: 'Bitcoin (1 BTC)',
    glyph: '₿',
    basePrice: Money.cents(6300000),    // 63.000 €
    volatility: 0.04,
    priceGroupId: 'bitcoin',
  );

  /// BTC-Stückelung in BTC-Einheiten (1 Anteil = wieviel BTC).
  static double btcPerShare(String assetId) {
    switch (assetId) {
      case 'crypto_bitcoin_mikro':
        return 0.0001;
      case 'crypto_bitcoin':
        return 0.001;
      case 'crypto_bitcoin_gross':
        return 0.01;
      case 'crypto_bitcoin_zehntel':
        return 0.1;
      case 'crypto_bitcoin_ganz':
        return 1.0;
      default:
        return 0.0;
    }
  }

  /// Krypto-Casino basket. v29: 100 € pro Coin (User-Vorgabe).
  static const kryptoCasino = CryptoSpec(
    id: 'crypto_kasino',
    name: 'Krypto-Casino',
    glyph: '🎰',
    // Welle-8 Round 22 v3: User-Spec — Basis 150 € × Zufallsfaktor.
    // Volatilität 0.70 = ±70 % Schwankung pro Quote. Min 45 €, Max 255 €.
    basePrice: Money.cents(15000),
    volatility: 0.70,
  );

  static const all = <CryptoSpec>[
    bitcoinMikro,
    bitcoin,
    bitcoinGross,
    bitcoinZehntel,
    bitcoinGanz,
    kryptoCasino,
  ];

  static CryptoSpec byId(String id) {
    // Round 27 BUGFIX: vorher matchte nur 'crypto_bitcoin' (0,001 BTC),
    // ALLE anderen Bitcoin-Stückelungen (mikro/gross/zehntel/ganz) fielen
    // auf den Casino-Spec (Basis 150 €) → Reseed setzte „1 BTC" auf 150 €.
    // Jetzt echtes Lookup über den Katalog.
    for (final s in all) {
      if (s.id == id) return s;
    }
    // spec-26: Legacy-IDs (rugcoin/pixelbit/chainkraken) → Casino-Basket,
    // damit alte Saves weiterlaufen.
    return kryptoCasino;
  }
}

@freezed
abstract class CryptoHolding with _$CryptoHolding {
  const factory CryptoHolding({
    required String assetId,
    required int shares,
    @MoneyConverter() required Money averageBuyPrice,
  }) = _CryptoHolding;

  factory CryptoHolding.fromJson(Map<String, dynamic> json) =>
      _$CryptoHoldingFromJson(json);
}

@freezed
abstract class CryptoQuote with _$CryptoQuote {
  const factory CryptoQuote({
    required String assetId,
    @MoneyConverter() required Money pricePerShare,
    required int onDayIndex,
  }) = _CryptoQuote;

  factory CryptoQuote.fromJson(Map<String, dynamic> json) =>
      _$CryptoQuoteFromJson(json);
}
