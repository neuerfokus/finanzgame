import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/quest/quest_asset_repository.dart';
import 'package:finanzgame/data/quest/quest_yaml_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('v29 quest YAMLs (post-reorg)', () {
    test('all registered quest YAMLs parse + have unique ids', () async {
      const loader = QuestYamlLoader();
      final ids = <String>{};
      for (final p in kQuestAssetPaths) {
        final text = await rootBundle.loadString(p);
        final q = loader.parse(text);
        expect(q.id, isNotEmpty, reason: '$p missing id');
        expect(q.title, isNotEmpty, reason: '$p missing title');
        expect(q.steps, isNotEmpty, reason: '$p has no steps');
        expect(ids.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
      }
    });

    test('every prerequisite resolves to a registered quest', () async {
      const loader = QuestYamlLoader();
      final allIds = <String>{};
      final prereqs = <String, List<String>>{};
      for (final p in kQuestAssetPaths) {
        final text = await rootBundle.loadString(p);
        final q = loader.parse(text);
        allIds.add(q.id);
        prereqs[q.id] = q.prerequisites;
      }
      for (final entry in prereqs.entries) {
        for (final pre in entry.value) {
          expect(
            allIds.contains(pre),
            isTrue,
            reason: '${entry.key} references unknown prerequisite $pre',
          );
        }
      }
    });
  });
}
