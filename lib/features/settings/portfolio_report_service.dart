/// Welle-8 Round 23: Bestands-Report als Text → Share-Sheet.
///
/// Generiert lesbare Übersicht über alle Asset-Klassen für Snapshot/
/// Eltern-Kind-Gespräch oder Beleg an Beratungs-Gespräch.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/game_clock.dart';
import '../bank/savings_repository.dart';
import '../collectibles/collectible_repository.dart';
import '../crypto/crypto_repository.dart';
import '../economy/cash_state.dart';
import '../etf/etf_repository.dart';
import '../highscore/net_worth.dart';
import '../metal/metal_repository.dart';
import '../realestate/real_estate_repository.dart';
import '../stock/stock_repository.dart';
import 'settings_repository.dart';

class PortfolioReportService {
  PortfolioReportService._();
  static final instance = PortfolioReportService._();

  /// Baut Bestands-Report als String + öffnet Share-Sheet.
  Future<void> shareReport(WidgetRef ref) async {
    final report = buildReport(ref);
    await Share.share(
      report,
      subject: 'Finanzgame Bestand',
    );
  }

  String buildReport(WidgetRef ref) {
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final settings = ref.read(settingsRepositoryProvider);
    final cash = ref.read(cashStateProvider);
    final savings = ref.read(savingsRepositoryProvider);
    final etf = ref.read(etfRepositoryProvider);
    final stock = ref.read(stockRepositoryProvider);
    final crypto = ref.read(cryptoRepositoryProvider);
    final metal = ref.read(metalRepositoryProvider);
    final realestate = ref.read(realEstateRepositoryProvider);
    final reRepo = ref.read(realEstateRepositoryProvider.notifier);
    final collectibles = ref.read(collectibleRepositoryProvider);
    final collectRepo = ref.read(collectibleRepositoryProvider.notifier);
    final netWorth = ref.read(netWorthProvider(dayIndex));

    final age = settings.startAgeYears + dayIndex ~/ 365;
    final lines = <String>[];
    lines.add('=== Finanzgame Bestand ===');
    lines.add('Spieler: ${settings.playerName}  ·  Alter: $age');
    lines.add('Spieltag: ${dayIndex + 1}');
    lines.add('');
    lines.add('💵 Cash: ${cash.formatEur()}');
    lines.add('🏦 Spar: ${savings.formatEur()}');
    if (etf.holdings.isNotEmpty) {
      lines.add('');
      lines.add('📈 ETF:');
      for (final h in etf.holdings) {
        final q = etf.quotes[h.etfId];
        final price = q?.pricePerShare;
        if (price == null) continue;
        final value = price * h.shares;
        lines.add('  ${h.etfId} ×${h.shares} = ${value.formatEur()}');
      }
    }
    if (stock.holdings.isNotEmpty) {
      lines.add('');
      lines.add('📊 Aktien:');
      for (final h in stock.holdings) {
        final q = stock.quotes[h.stockId];
        final price = q?.pricePerShare;
        if (price == null) continue;
        final value = price * h.shares;
        lines.add('  ${h.stockId} ×${h.shares} = ${value.formatEur()}');
      }
    }
    if (crypto.holdings.isNotEmpty) {
      lines.add('');
      lines.add('₿ Krypto:');
      for (final h in crypto.holdings) {
        final q = crypto.quotes[h.assetId];
        final price = q?.pricePerShare;
        if (price == null) continue;
        final value = price * h.shares;
        lines.add('  ${h.assetId} ×${h.shares} = ${value.formatEur()}');
      }
    }
    if (metal.holdings.isNotEmpty) {
      lines.add('');
      lines.add('🥇 Metalle:');
      for (final h in metal.holdings) {
        final q = metal.quotes[h.assetId];
        final price = q?.pricePerShare;
        if (price == null) continue;
        final value = price * h.shares;
        lines.add('  ${h.assetId} ×${h.shares} = ${value.formatEur()}');
      }
    }
    if (realestate.isNotEmpty) {
      lines.add('');
      lines.add('🏠 Immobilien:');
      for (final h in realestate) {
        final value = reRepo.currentValueOf(h, dayIndex);
        final debt = reRepo.mortgageRemaining(h, dayIndex);
        // Restschuld ausweisen — der Nettowert ist das, was wirklich zählt.
        if (debt.cents > 0) {
          lines.add('  ${h.specId} = ${value.formatEur()} '
              '− Restschuld ${debt.formatEur()} '
              '= ${(value - debt).formatEur()}');
        } else {
          lines.add('  ${h.specId} = ${value.formatEur()}');
        }
      }
    }
    if (collectibles.isNotEmpty) {
      lines.add('');
      lines.add('🎨 Sammler:');
      for (final h in collectibles) {
        final value = collectRepo.currentValueOf(h, dayIndex);
        lines.add('  ${h.specId} = ${value.formatEur()}');
      }
    }
    lines.add('');
    lines.add('======================');
    lines.add('💎 Gesamt-Vermögen: ${_fmt(netWorth)}');
    lines.add('======================');
    return lines.join('\n');
  }

  String _fmt(int cents) {
    final euro = cents / 100;
    return '${euro.toStringAsFixed(2).replaceAll('.', ',')} €';
  }
}
