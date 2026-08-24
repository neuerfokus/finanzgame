import 'package:yaml/yaml.dart';

import '../../domain/economy/money.dart';
import '../../domain/quest/quest.dart';

class QuestYamlError implements Exception {
  const QuestYamlError(this.message);
  final String message;
  @override
  String toString() => 'QuestYamlError: $message';
}

/// Pure parser: YAML text → [Quest]. No IO.
class QuestYamlLoader {
  const QuestYamlLoader();

  Quest parse(String yamlText) {
    final root = loadYaml(yamlText);
    if (root is! YamlMap) {
      throw const QuestYamlError('root must be a map');
    }

    final id = _req<String>(root, 'id');
    final title = _req<String>(root, 'title');
    final location = _req<String>(root, 'location');
    final rewardNode = root['reward'];
    if (rewardNode is! YamlMap) {
      throw const QuestYamlError('reward must be a map');
    }
    final reward = QuestReward(
      cash: Money.cents(_req<int>(rewardNode, 'cash_cents')),
      xp: (rewardNode['xp'] as int?) ?? 0,
    );

    final prerequisites = <String>[
      for (final p in (root['prerequisites'] as YamlList? ?? const []))
        p as String,
    ];

    final stepsRaw = root['steps'];
    if (stepsRaw is! YamlList) {
      throw const QuestYamlError('steps must be a list');
    }
    final steps = stepsRaw.map<QuestStep>(_parseStep).toList(growable: false);

    return Quest(
      id: id,
      title: title,
      location: location,
      reward: reward,
      prerequisites: prerequisites,
      steps: steps,
    );
  }

  QuestStep _parseStep(dynamic node) {
    if (node is! YamlMap) {
      throw const QuestYamlError('step must be a map');
    }
    final id = _req<String>(node, 'id');
    final type = _req<String>(node, 'type');
    switch (type) {
      case 'dialog':
        final speaker = _req<String>(node, 'speaker');
        final lines = (node['lines'] as YamlList).cast<String>().toList();
        return QuestStep.dialog(id: id, speaker: speaker, lines: lines);
      case 'quiz':
        return QuestStep.quiz(
          id: id,
          question: _req<String>(node, 'question'),
          options: _parseOptions(node['options']),
          correctId: _req<String>(node, 'correct'),
          explanation: node['explanation'] as String?,
        );
      case 'choice':
        return QuestStep.choice(
          id: id,
          prompt: _req<String>(node, 'prompt'),
          options: _parseOptions(node['options']),
        );
      case 'interactive':
        // v29: User-Quest q09 "Regel dein Risiko" mit interaktivem Regler.
        // Fallback: als Dialog rendern (Text statt Interaktion), bis
        // Engine-Hook implementiert.
        return QuestStep.dialog(
          id: id,
          speaker: 'System',
          lines: [
            (node['text'] as String?) ??
                (node['prompt'] as String?) ??
                '(Interaktiver Regler — bald verfügbar)',
          ],
        );
      default:
        throw QuestYamlError('unknown step type "$type"');
    }
  }

  List<QuestOption> _parseOptions(dynamic node) {
    if (node is! YamlList) {
      throw const QuestYamlError('options must be a list');
    }
    return [
      for (final raw in node)
        QuestOption(
          id: _reqStr(raw as YamlMap, 'id'),
          label: _reqStr(raw, 'label'),
        ),
    ];
  }

  /// v29: User-Quests teilweise mit int-Labels (z.B. "label: 2025")
  /// → tolerantes Coerce to String.
  String _reqStr(YamlMap map, String key) {
    final v = map[key];
    if (v == null) {
      throw QuestYamlError('missing "$key"');
    }
    return v.toString();
  }

  T _req<T>(YamlMap map, String key) {
    final v = map[key];
    if (v is! T) {
      throw QuestYamlError(
        'missing or wrong type for "$key" (expected $T, got ${v.runtimeType})',
      );
    }
    return v;
  }
}
