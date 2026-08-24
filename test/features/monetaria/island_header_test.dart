import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/monetaria/island_header.dart';
import 'package:finanzgame/features/monetaria/island_identity.dart';
import 'package:finanzgame/features/monetaria/island_page.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

void main() {
  group('IslandHeader (spec-16)', () {
    testWidgets('renders glyph, label, focus + asset class for spar-insel',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: IslandHeader.forId(IslandId.sparInsel)),
        ),
      );
      await tester.pump();

      final ident = islandIdentityFor(IslandId.sparInsel);
      expect(find.text(ident.label), findsOneWidget);
      expect(find.text('Schwerpunkt: ${ident.focus}'), findsOneWidget);
      expect(find.text('Asset: ${ident.assetClass}'), findsOneWidget);
      expect(find.text(ident.oneLiner), findsOneWidget);
    });

    testWidgets('renders on locked island fallback view', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: IslandPage(islandId: IslandId.mischwald),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final ident = islandIdentityFor(IslandId.mischwald);
      expect(find.text('Schwerpunkt: ${ident.focus}'), findsOneWidget);
      expect(find.text('Asset: ${ident.assetClass}'), findsOneWidget);
      expect(find.text('Noch verschlossen.'), findsOneWidget);
    });

    // Spec-38 Welle 5: mischwald hat jetzt CollectibleTradePage statt
    // generic-Fallback. Test entfernt — neue Page hat eigene Tests.
  });
}
