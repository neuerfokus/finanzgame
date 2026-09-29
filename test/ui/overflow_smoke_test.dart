import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:finanzgame/core/fg_text_scaler.dart';
import 'package:finanzgame/core/fg_theme.dart';
import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/data/quest/quest_yaml_loader.dart';
import 'package:finanzgame/domain/quest/quest.dart';
import 'package:finanzgame/features/bank/bank_page.dart';
import 'package:finanzgame/features/daily_quiz/daily_quiz_page.dart';
import 'package:finanzgame/features/daily_quiz/wissens_quiz_page.dart';
import 'package:finanzgame/features/glossar/glossar_page.dart';
import 'package:finanzgame/features/highscore/highscore_page.dart';
import 'package:finanzgame/features/phone_ui/springboard_page.dart';
import 'package:finanzgame/features/quest_runner/quest_list_page.dart';
import 'package:finanzgame/features/quest_runner/quest_runner_page.dart';
import 'package:finanzgame/features/real_life/real_life_page.dart';
import 'package:finanzgame/features/settings/berichte_page.dart';
import 'package:finanzgame/features/settings/settings_page.dart';
import 'package:finanzgame/features/settings/text_scale.dart';
import 'package:finanzgame/features/stats/stats_page.dart';
import 'package:finanzgame/features/vorsorge/vorsorge_page.dart';
import 'package:finanzgame/features/zimmer/zimmer_page.dart';
import 'package:finanzgame/ui/widgets/answer_button.dart';

/// Lesbarkeit: Overflow-Smoke der Hauptscreens bei Schriftgröße „Groß"
/// (× 1,2) auf einem schmalen Handy (360 × 640 dp) — in beiden Schrift-Modi.
///
/// Echte Schriften (KenneyPixel aus der pubspec, Roboto) über
/// `loadAppFonts`, sonst misst der Test mit der Ersatzschrift, deren Glyphen
/// alle ein volles Geviert breit sind — viel zu pessimistisch.
///
/// Gesammelt wird jeder „RenderFlex overflowed"-Fehler aller Screens, damit
/// ein Lauf die komplette Liste zeigt statt beim ersten abzubrechen.
const _size = Size(360, 640);

Widget _app(Widget page, {required bool readableFont}) {
  return ProviderScope(
    overrides: [
      dbSnapshotProvider.overrideWithValue(
        DbSnapshot(
          settings: SettingsSnapshot(
            lastQuizDayIndex: 0,
            onboardingComplete: true,
            birthYearAsked: true,
            readableFont: readableFont,
            textScalePct: TextScaleStufe.gross.pct,
          ),
          questProgress: const {
            'q00_tutorial': QuestProgressRow(
              questId: 'q00_tutorial',
              currentStepIndex: 0,
              status: 'completed',
              startedOnDayIndex: 0,
              completedOnDayIndex: 0,
            ),
          },
        ),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildFgTheme(readableFont: readableFont),
      // Wie FinanzgameApp.builder in main.dart.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: combineTextScale(
              mq.textScaler,
              TextScaleStufe.gross.faktor,
              kMaxTextScale,
            ),
          ),
          child: child!,
        );
      },
      home: page,
    ),
  );
}

/// Das Tutorial unter eigener ID — die echte ist im Snapshot als erledigt
/// markiert, dann stünde der Runner sofort auf „Fertig".
Quest _tutorial() => const QuestYamlLoader()
    .parse(File('assets/quests/q00_tutorial.yaml').readAsStringSync())
    .copyWith(id: 'q00_overflow_smoke');

Map<String, Widget Function()> _screens() => {
      'Springboard': () => const SpringboardPage(),
      'Bank': () => const BankPage(),
      'Zimmer': () => const ZimmerPage(),
      'Stats': () => const StatsPage(),
      'Quests': () => const QuestListPage(),
      'Einstellungen': () => const SettingsPage(),
      'Glossar': () => const GlossarPage(),
      'Vorsorge': () => const VorsorgePage(),
      'Highscore': () => const HighscorePage(),
      'Berichte': () => const BerichtePage(),
      'Echtes Leben': () => const RealLifePage(),
      'Frage des Tages': () => const DailyQuizPage(),
      'Wissens-Quiz': () => const WissensQuizPage(),
      'Quest-Runner': () => QuestRunnerPage(quest: _tutorial()),
    };

Future<void> _settle(WidgetTester tester) async {
  // Kein pumpAndSettle: manche Screens haben Dauer-Animationen.
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 300));
  }
}

void main() {
  setUpAll(() async => loadAppFonts());

  for (final readable in [true, false]) {
    final modus = readable ? 'lesbar' : 'Pixel';
    testWidgets('keine Overflows bei „Groß" auf 360 dp ($modus)',
        (tester) async {
      tester.view.physicalSize = _size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final overflows = <String>[];
      final original = FlutterError.onError;
      String? current;
      FlutterError.onError = (details) {
        final msg = details.exceptionAsString();
        if (msg.contains('overflowed')) {
          // Ort des verursachenden Widgets (Datei:Zeile) mitschreiben.
          final ort = RegExp(r'lib/([\w/]+\.dart:\d+)')
              .firstMatch(details.toString())
              ?.group(1);
          final eintrag = '$current: ${msg.split('\n').first} [$ort]';
          if (!overflows.contains(eintrag)) overflows.add(eintrag);
        } else {
          original?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = original);

      for (final e in _screens().entries) {
        current = e.key;
        await tester.pumpWidget(_app(e.value(), readableFont: readable));
        await _settle(tester);
        // Quest-Runner: bis zur Quiz-Frage durchklicken, damit auch die
        // Antwort-Buttons gemessen werden.
        if (e.key == 'Quest-Runner') {
          for (var i = 0; i < 20; i++) {
            final weiter = find.text('Weiter →');
            if (weiter.evaluate().isEmpty) break;
            await tester.tap(weiter);
            await _settle(tester);
          }
          expect(find.byType(AnswerButton), findsWidgets,
              reason: 'Quest-Runner muss bis zur Quiz-Frage laufen');
        }
        // Leeren Baum pumpen, damit Timer/Animationen des Screens enden.
        await tester.pumpWidget(const SizedBox.shrink());
        await _settle(tester);
      }

      FlutterError.onError = original;
      expect(overflows, isEmpty, reason: overflows.join('\n'));
    });
  }
}
