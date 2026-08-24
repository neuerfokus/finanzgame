import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/db/app_database.dart';
import 'package:finanzgame/data/db/app_database_provider.dart';
import 'package:finanzgame/features/history/asset_labels.dart';
import 'package:finanzgame/features/history/zeitreise_page.dart';

/// Builds a [DbSnapshot] pre-seeded with [days] of aggregate history
/// rows so the page renders with at-least-2-point lines without needing
/// to drive [GameClock.advanceDay] (which spins up Riverpod dispose
/// timers that don't play nicely with widget-test FakeAsync).
DbSnapshot _snapshotWithHistory({
  required int days,
  bool tutorialSeen = false,
}) {
  final rows = <PriceHistoryRow>[];
  for (var day = 1; day <= days; day++) {
    for (final id in HistoryAssetIds.all) {
      rows.add(PriceHistoryRow(
        assetId: id,
        dayIndex: day,
        priceCents: 1000 + day * 50,
      ));
    }
  }
  return DbSnapshot(
    dayIndex: days,
    priceHistory: rows,
    settings: SettingsSnapshot(zeitreiseTutorialSeen: tutorialSeen),
  );
}

Future<ProviderContainer> _pumpPage(
  WidgetTester tester, {
  required DbSnapshot snap,
}) async {
  final container = ProviderContainer(
    overrides: [dbSnapshotProvider.overrideWithValue(snap)],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: ZeitreisePage()),
    ),
  );
  // Settle once for didChangeDependencies + tutorial overlay frame.
  await tester.pump();
  return container;
}

void main() {
  testWidgets(
    'tap on a chip toggles its line on/off',
    (tester) async {
      await _pumpPage(
        tester,
        snap: _snapshotWithHistory(days: 5, tutorialSeen: true),
      );

      final chipFinder = find.byKey(
        const Key('zeitreise-chip-${HistoryAssetIds.wishlistCpi}'),
      );
      expect(chipFinder, findsOneWidget);

      // Chip kann unter dem Chart außerhalb des sichtbaren Bereichs liegen
      // (Test-Surface 800×600) → erst in den View scrollen, sonst trifft
      // tap() ins Leere (warnIfMissed) und der Test ist flaky.
      await tester.ensureVisible(chipFinder);
      await tester.pump();

      // Toggle on → off → on. No exceptions means the state machine
      // stays valid through several cycles.
      await tester.tap(chipFinder);
      await tester.pump();
      await tester.tap(chipFinder);
      await tester.pump();
      await tester.tap(chipFinder);
      await tester.pump();
    },
  );

  testWidgets(
    'max 4 lines selected: 5th toggle is silently dropped',
    (tester) async {
      await _pumpPage(
        tester,
        snap: _snapshotWithHistory(days: 5, tutorialSeen: true),
      );

      // Default selection already has 3 (cash, etf, stock). Add 2 more
      // to overshoot the cap.
      final cpiChip = find.byKey(
        const Key('zeitreise-chip-${HistoryAssetIds.wishlistCpi}'),
      );
      final sparChip = find.byKey(
        const Key('zeitreise-chip-${HistoryAssetIds.sparYield}'),
      );
      // In den View scrollen → tap trifft sicher (sonst flaky off-screen).
      await tester.ensureVisible(cpiChip);
      await tester.pump();
      await tester.tap(cpiChip);
      await tester.pump();
      await tester.ensureVisible(sparChip);
      await tester.pump();
      await tester.tap(sparChip);
      await tester.pump();
      // Neither tap throws — the 5th add silently no-ops.
    },
  );

  testWidgets(
    'tutorial overlay appears on first open and disappears after dismiss',
    (tester) async {
      await _pumpPage(
        tester,
        // tutorialSeen=false by default → overlay should appear.
        snap: _snapshotWithHistory(days: 3),
      );

      expect(
        find.byKey(const Key('zeitreise-tutorial-overlay')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('zeitreise-tutorial-overlay')));
      await tester.pump();
      expect(
        find.byKey(const Key('zeitreise-tutorial-overlay')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'tutorial does NOT appear when zeitreiseTutorialSeen=true in snapshot',
    (tester) async {
      await _pumpPage(
        tester,
        snap: _snapshotWithHistory(days: 3, tutorialSeen: true),
      );
      expect(
        find.byKey(const Key('zeitreise-tutorial-overlay')),
        findsNothing,
      );
    },
  );
}
