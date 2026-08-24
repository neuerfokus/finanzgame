import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/features/monetaria/island_identity.dart';
import 'package:finanzgame/game/monetaria/state/monetaria_state.dart';

void main() {
  group('kIslandIdentities', () {
    test('contains all 9 island IDs', () {
      const expectedIds = {
        IslandId.heimathafen,
        IslandId.sparInsel,
        IslandId.mischwald,
        IslandId.etfInsel,
        IslandId.inflationAtoll,
        IslandId.aktienArchipel,
        IslandId.vulkan,
        IslandId.goldmine,
        IslandId.wohnviertel,
      };
      expect(kIslandIdentities.keys.toSet(), expectedIds);
      expect(kIslandIdentities.length, 9);
    });

    test('no entry has empty label, focus, assetClass, oneLiner or glyph', () {
      for (final entry in kIslandIdentities.entries) {
        final id = entry.key;
        final ident = entry.value;
        expect(ident.label, isNotEmpty, reason: '$id label');
        expect(ident.focus, isNotEmpty, reason: '$id focus');
        expect(ident.assetClass, isNotEmpty, reason: '$id assetClass');
        expect(ident.oneLiner, isNotEmpty, reason: '$id oneLiner');
        expect(ident.glyph, isNotEmpty, reason: '$id glyph');
      }
    });

    test('islandIdentityFor returns mapped identity for known ids', () {
      final spar = islandIdentityFor(IslandId.sparInsel);
      expect(spar.label, 'Spar-Insel');
      expect(spar.glyph, '🌱');
      expect(spar.form, IslandForm.hill);
    });

    test('islandIdentityFor returns fallback for unknown ids', () {
      final unknown = islandIdentityFor('nonexistent_island');
      expect(unknown.label, '?');
      expect(unknown.glyph, '❓');
    });
  });
}
