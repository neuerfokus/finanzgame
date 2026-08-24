/// Round 28: Wochen-Report als Text → Share-Sheet.
///
/// Komplement zum [PortfolioReportService] (Bestand). Fasst die Woche
/// zusammen: Vermögen + Veränderung seit dem letzten Wochen-Snapshot +
/// gelernte Begriffe + Level. Freigeschaltet über den Skill „Überblicker".
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/game_clock.dart';
import '../daily_quiz/daily_quiz_state.dart';
import '../highscore/net_worth.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import 'settings_repository.dart';

class WeeklyReportService {
  WeeklyReportService._();
  static final instance = WeeklyReportService._();

  /// Baut Wochen-Report als String + öffnet Share-Sheet.
  Future<void> shareReport(WidgetRef ref) async {
    final report = buildReport(ref);
    await Share.share(report, subject: 'Finanzgame Wochen-Report');
  }

  String buildReport(WidgetRef ref) {
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final settings = ref.read(settingsRepositoryProvider);
    final netWorth = ref.read(netWorthProvider(dayIndex));
    final lastWeek = settings.lastWeekNetWorthCents;
    final learned = ref.read(learnedTopicsProvider).length;
    final xp = ref.read(xpRepositoryProvider);
    final level = LevelSystem.levelFor(xp);
    final title = LevelSystem.titleFor(level);

    final age = settings.startAgeYears + dayIndex ~/ 365;
    final week = dayIndex ~/ 7 + 1;

    final lines = <String>[];
    lines.add('=== Finanzgame Wochen-Report ===');
    lines.add('Spieler: ${settings.playerName}  ·  Alter: $age');
    lines.add('Spieltag ${dayIndex + 1}  ·  Woche $week');
    lines.add('');
    lines.add('💎 Vermögen jetzt: ${_fmt(netWorth)}');
    if (lastWeek > 0) {
      final delta = netWorth - lastWeek;
      final sign = delta >= 0 ? '+' : '';
      lines.add('📊 Seit letzter Woche: $sign${_fmt(delta)}');
    } else {
      lines.add('📊 Seit letzter Woche: (noch kein Vergleich)');
    }
    lines.add('🎓 Gelernte Begriffe: $learned');
    lines.add('🏆 Level $level — $title  ($xp XP)');
    lines.add('');
    lines.add('Weiter dranbleiben — kleine Schritte, große Wirkung!');
    return lines.join('\n');
  }

  String _fmt(int cents) {
    final euro = cents / 100;
    return '${euro.toStringAsFixed(2).replaceAll('.', ',')} €';
  }
}
