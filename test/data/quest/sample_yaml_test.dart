import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/data/quest/quest_yaml_loader.dart';
import 'package:finanzgame/data/quest/quest_asset_repository.dart';
import 'package:finanzgame/domain/quest/quest.dart';

void main() {
  test('bundled YAML quests parse without errors', () async {
    const loader = QuestYamlLoader();
    for (final path in kQuestAssetPaths) {
      final text = await File(path).readAsString();
      final quest = loader.parse(text);
      expect(quest.steps, isNotEmpty, reason: path);
      expect(quest.id, startsWith('q'), reason: path);
    }
  });

  test('q01_sparschwein has dialog+quiz+choice+dialog', () async {
    final text = await File('assets/quests/q01_sparschwein.yaml').readAsString();
    final quest = const QuestYamlLoader().parse(text);
    expect(quest.id, 'q01_sparschwein');
    expect(quest.steps.length, 4);
    expect(quest.steps[0], isA<DialogStep>());
    expect(quest.steps[1], isA<QuizStep>());
    expect(quest.steps[2], isA<ChoiceStep>());
    expect(quest.steps[3], isA<DialogStep>());
  });
}
