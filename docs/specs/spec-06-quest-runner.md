# Spec 06 — Quest-Runner YAML-deklarativ

## Goal

Quest-Inhalte (Dialoge, Quizfragen, Entscheidungen, Belohnungen) leben als
deklarative `assets/quests/q*.yaml` Files. Ein generischer `QuestRunnerPage`
liest YAML, rendert Chat-Stream pro Step und zahlt Reward beim Abschluss
aus.

## Why

Altes Repo: JSON + imperative Step-Renderer pro Typ → schwer zu erweitern,
Inhalt mit Logik vermischt. Mit YAML + Step-Type-Registry können die Eltern
neue Quests schreiben ohne Dart anzufassen.

## Non-Goals

- Quest-Editor-UI
- Branching (Wenn-Dann-Pfade) — Sprint 7+
- Localisierung — DE-only erstmal
- Persistenter Quest-Progress (in-memory bis DB-Foundation-Sprint)

## YAML-Format

`assets/quests/q01_sparschwein.yaml`:

```yaml
id: q01_sparschwein
title: Das Sparschwein erwacht
location: monetaria.heimathafen
prerequisites: []
reward:
  cash_cents: 200
  xp: 50
steps:
  - id: intro
    type: dialog
    speaker: Magister Aureus
    lines:
      - Willkommen in Monetaria!
      - Beginnen wir mit dem ersten Geheimnis.
  - id: quiz
    type: quiz
    question: Was bedeutet sparen?
    options:
      - { id: a, label: Alles ausgeben }
      - { id: b, label: Geld zur Seite legen }
    correct: b
    explanation: Sparen heißt Geld zurücklegen.
  - id: choice
    type: choice
    prompt: Du bekommst Taschengeld. Was tust du?
    options:
      - { id: spend, label: Sofort ausgeben }
      - { id: save, label: Auf Sparkonto }
```

Step-Typen Sprint 6: `dialog`, `quiz`, `choice`. Andere (`pay`, `buy`,
`wait_day`, `unlock_island`) folgen in späteren Sprints.

## Domain Model

```dart
@freezed sealed class QuestStep {
  factory QuestStep.dialog({required String id, required String speaker, required List<String> lines});
  factory QuestStep.quiz({required String id, required String question, required List<QuestOption> options, required String correctId, String? explanation});
  factory QuestStep.choice({required String id, required String prompt, required List<QuestOption> options});
}

abstract class QuestOption { String id; String label; }

abstract class Quest {
  String id; String title; String location;
  List<String> prerequisites;
  QuestReward reward;
  List<QuestStep> steps;
}

abstract class QuestReward { Money cash; int xp; }

@freezed sealed class ChatEntry {
  factory ChatEntry.npc({required String speaker, required String text});
  factory ChatEntry.own({required String text});
  factory ChatEntry.system({required String text});
}
```

## Code-Struktur

```
lib/domain/quest/
  quest.dart                 # Freezed unions
  chat_entry.dart
lib/data/quest/
  quest_yaml_loader.dart     # YAML → Quest (pure parse, no IO)
  quest_asset_repository.dart # AssetBundle → list of Quests
lib/features/quest_runner/
  quest_runner_page.dart     # ConsumerStatefulWidget
  quest_runner_controller.dart # Riverpod, holds chat list + current step
  step_renderers/            # dialog_bubble, quiz_buttons, choice_buttons
assets/quests/
  q01_sparschwein.yaml
  q02_wuensche.yaml          # placeholder
```

## Controller Flow

`QuestRunnerController.start(questId)`:
1. Lade Quest via AssetRepository
2. Initial step → push ChatEntries (dialog = NPC-Bubbles; quiz/choice = NPC prompt + warten)
3. Bei User-Antwort: validate (quiz), push Own-Bubble, push System-Bubble bei Fehler
4. Nächster Step → loop bis Liste leer
5. End: CashState.earn(reward.cash), emit System "+200¢ +50 XP"

## Tests

- Unit: `QuestYamlLoader.parse(yamlString)` → Quest. Round-trip Q01.
- Unit: Controller — start → dialog pushed 5 entries; pick wrong quiz → system error entry; pick right → advance.
- Widget: pump QuestRunnerPage, scroll shows last entry, tap option triggers controller.
- Integration: start → answer all → CashState credited.

## Acceptance

- [ ] YAML loader (`yaml ^3.1.2` already in deps)
- [ ] Quest + ChatEntry Freezed
- [ ] 2 sample YAML quests in `assets/quests/`
- [ ] QuestRunnerPage with chat-stream UI
- [ ] dialog + quiz + choice renderers
- [ ] Reward auszahlen am Ende
- [ ] Springboard Quests-AppIcon → list active quests → push QuestRunnerPage
- [ ] Tests grün, analyze clean
- [ ] Commit: `feat(quest): YAML-driven quest runner with chat-stream UI`

## Done When

Spieler tippt Quests-AppIcon, sieht „Das Sparschwein erwacht", spielt
Dialog → Quiz → Choice durch, bekommt 200¢ + 50 XP gutgeschrieben.
