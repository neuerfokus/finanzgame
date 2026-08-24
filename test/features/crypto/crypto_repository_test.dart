import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/domain/crypto/crypto.dart';
import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/features/crypto/crypto_repository.dart';
import 'package:finanzgame/features/economy/cash_state.dart';
import 'package:finanzgame/features/xp/level_titles.dart';
import 'package:finanzgame/features/xp/xp_repository.dart';

/// Round 28: Käufe/Verkäufe vergeben XP + Achievement-XP, die ein Level-Up
/// mit Cash-Bonus (Level × 5 €) auslösen können. Aus der Formel berechnet.
int _levelUpCashBonus(int fromXp, int toXp) {
  var bonus = 0;
  for (var l = LevelSystem.levelFor(fromXp) + 1;
      l <= LevelSystem.levelFor(toXp);
      l++) {
    bonus += l * XpRepository.levelUpRewardCentsPerLevel;
  }
  return bonus;
}

ProviderContainer _container({
  Money cash = const Money.cents(500000),
  DbSnapshot? snap,
}) {
  final c = ProviderContainer(
    overrides: [
      if (snap != null) dbSnapshotProvider.overrideWithValue(snap),
    ],
  );
  c.read(cashStateProvider.notifier).state = cash;
  return c;
}

void main() {
  group('CryptoRepository', () {
    test('initial quotes seeded from catalog', () {
      final c = _container();
      addTearDown(c.dispose);
      final p = c.read(cryptoRepositoryProvider);
      expect(p.quotes.length, CryptoCatalog.all.length);
      for (final spec in CryptoCatalog.all) {
        expect(p.quotes[spec.id]!.pricePerShare, spec.basePrice);
      }
    });

    test('Round 27: BTC in 16k-250k envelope is kept (weites Band)', () {
      // 0,001 BTC base = 6300¢ (63 €). Band [0.25×, 4×] = [1575, 25200].
      // 25000¢ (≈ 250k €/BTC) liegt im realistischen Korridor → behalten,
      // damit langfristiger Drift über App-Neustarts überlebt.
      final c = _container(
        snap: const DbSnapshot(
          cryptoQuotes: [
            CryptoQuoteRow(
              assetId: 'crypto_bitcoin',
              pricePerShareCents: 25000,
              onDayIndex: 100,
            ),
          ],
        ),
      );
      addTearDown(c.dispose);
      final p = c.read(cryptoRepositoryProvider);
      expect(p.quotes['crypto_bitcoin']!.pricePerShare,
          const Money.cents(25000));
    });

    test('Round 27 BUGFIX: byId resolves every BTC denomination', () {
      // Vorher fielen alle außer 0,001 auf Casino (150 €).
      expect(CryptoCatalog.byId('crypto_bitcoin_mikro').basePrice,
          const Money.cents(630));
      expect(CryptoCatalog.byId('crypto_bitcoin_ganz').basePrice,
          const Money.cents(6300000));
      expect(CryptoCatalog.byId('crypto_bitcoin_gross').basePrice,
          const Money.cents(63000));
      // Legacy/unbekannt → Casino.
      expect(CryptoCatalog.byId('crypto_rugcoin').basePrice,
          const Money.cents(15000));
    });

    test('Round 27 BUGFIX: 1-BTC quote at 63k is kept, not collapsed to 150', () {
      // Migrierter/gedrifteter „1 BTC"-Wert (6.300.000¢ = 63.000 €) muss
      // erhalten bleiben — vorher reseedete byId→Casino ihn auf 150 €.
      final c = _container(
        snap: const DbSnapshot(
          cryptoQuotes: [
            CryptoQuoteRow(
              assetId: 'crypto_bitcoin_ganz',
              pricePerShareCents: 6300000,
              onDayIndex: 100,
            ),
          ],
        ),
      );
      addTearDown(c.dispose);
      final p = c.read(cryptoRepositoryProvider);
      expect(p.quotes['crypto_bitcoin_ganz']!.pricePerShare,
          const Money.cents(6300000));
    });

    test('Round 27: absurd BTC quote (>4x base) reseeds to base', () {
      // 30000¢ (≈ 300k €/BTC) > 4×6300 (25200¢) → unplausibel, reseed.
      final c = _container(
        snap: const DbSnapshot(
          cryptoQuotes: [
            CryptoQuoteRow(
              assetId: 'crypto_bitcoin',
              pricePerShareCents: 30000,
              onDayIndex: 100,
            ),
          ],
        ),
      );
      addTearDown(c.dispose);
      final p = c.read(cryptoRepositoryProvider);
      expect(p.quotes['crypto_bitcoin']!.pricePerShare,
          CryptoCatalog.bitcoin.basePrice);
    });

    test('buy + sell round-trip', () {
      // 2× 0,001 BTC (je 63 €) = 126 € — kleiner Puffer reicht. Bewusst
      // UNTER 100.000 € Netto bleiben: ein Trade ruft evaluateAchievementsNow
      // → applyLifeGoals, und das Lebensziel „Erste 100.000 €" würde sonst
      // zusätzliches Cash gutschreiben (Test modelliert nur Level-Up-Cash).
      final c = _container(cash: const Money.cents(200000));
      addTearDown(c.dispose);
      final repo = c.read(cryptoRepositoryProvider.notifier);
      repo.buy(assetId: CryptoCatalog.bitcoin.id, shares: 2);
      expect(repo.holdingFor(CryptoCatalog.bitcoin.id)!.shares, 2);
      repo.sell(assetId: CryptoCatalog.bitcoin.id, shares: 2);
      expect(repo.holdingFor(CryptoCatalog.bitcoin.id), isNull);
      // Round-Trip-Wert hebt sich auf; übrig bleibt nur ein evtl.
      // Level-Up-Cash-Bonus aus den XP/Achievements des Handels.
      final bonus = _levelUpCashBonus(0, c.read(xpRepositoryProvider));
      expect(c.read(cashStateProvider), Money.cents(200000 + bonus));
    });

    test('insufficient cash throws', () {
      final c = _container(cash: const Money.cents(10));
      addTearDown(c.dispose);
      final repo = c.read(cryptoRepositoryProvider.notifier);
      expect(
        () => repo.buy(assetId: CryptoCatalog.kryptoCasino.id, shares: 1),
        throwsA(isA<CryptoError>()),
      );
    });
  });
}
