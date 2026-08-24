# Spec 14 — Quest-Persistenz + Prerequisites-Gating

## Goal

Quest-Status (running / completed / chat-history) überlebt App-Restart.
Quest-Liste filtert/sperrt Quests nach `prerequisites` aus YAML.

## Why

`QuestRunnerController` ist Family-Provider und resettet bei jedem Push
zur QuestListPage → Spieler verliert Chat-Stream + Reward-Status. YAMLs
deklarieren `prerequisites: [questId]`, aber der Loader parst sie ohne
Wirkung → Story-Reihenfolge nicht erzwingbar.

## Non-Goals

- Quest-Rewinds / Re-Play
- Verzweigende Dialoge (Multi-Choice steps existieren schon, aber
  Branching jenseits davon ist out of scope)
- Vorschau auf locked Quests (zeige nur ID + Lock-Hint)

## Datenmodell

Zwei Drift-Tabellen:

```dart
class QuestProgressTable extends Table {
  TextColumn get questId => text()();
  IntColumn get currentStepIndex => integer().withDefault(const Constant(0))();
  TextColumn get status => text()(); // 'running' | 'completed'
  IntColumn get startedOnDayIndex => integer().nullable()();
  IntColumn get completedOnDayIndex => integer().nullable()();
  @override
  Set<Column> get primaryKey => {questId};
}

class QuestChatEntriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get questId => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get kind => text()(); // 'npc' | 'own' | 'system'
  TextColumn get payloadJson => text()(); // ChatEntry JSON
}
```

`DbSnapshot.quests: Map<String, QuestProgressRow>` und
`questChats: Map<String, List<ChatEntry>>` (geladen pro Quest beim Push,
nicht alle vorab — siehe Repository).

`QuestProgressRepository` (neuer Riverpod-Provider):
- `progressFor(questId)` → Row oder `null`
- `markStarted(questId, dayIndex)`
- `markCompleted(questId, dayIndex)`
- `appendChat(questId, ChatEntry)`
- `chatHistory(questId)` → `List<ChatEntry>`
- `stepIndex(questId, int)` update

`QuestRunnerController.build(questId)`: hydratisiert aus Repo, schreibt
durch bei jedem `nextStep()`, `recordChat()`, `complete()`.

## Prerequisites-Gating

`Quest.prerequisites: List<String>` ist schon im Modell. Neuer Pure-
Helper:

```dart
bool isQuestAvailable(Quest q, Map<String, QuestProgressRow> progress) {
  return q.prerequisites.every((id) =>
    progress[id]?.status == 'completed');
}
```

`QuestListPage` zeigt drei Buckets: **Aktiv**, **Verfügbar**, **Gesperrt**
(letzte mit Schloss-Icon + „Erst {prereqId} abschließen").

## Files (zu ändern)

- `lib/data/db/tables.dart` — 2 Tabellen
- `lib/data/db/daos.dart` — `QuestProgressDao`, `QuestChatDao`
- `lib/data/db/app_database_provider.dart` — `DbSnapshot.questProgress`
- `lib/features/quest_runner/quest_progress_repository.dart` — NEU
- `lib/features/quest_runner/quest_runner_controller.dart` — DB-anbinden,
  KEEP-ALIVE
- `lib/features/quest_runner/quest_list_page.dart` — 3 Buckets

## Tests

- Round-trip: starte Quest, 2 Steps, reopen DB → currentStep=2 + Chat erhalten
- Pure: `isQuestAvailable` Tabellen-Test
- Widget: Locked Quest hat Schloss-Icon und kein Tap-Handler

## Acceptance

- [ ] 2 Drift-Tabellen, 2 DAOs
- [ ] `QuestProgressRepository`
- [ ] `QuestRunnerController` lädt + schreibt durch
- [ ] `QuestListPage` 3 Buckets
- [ ] Bestehende Quest-Tests grün (Pure Quest-Modell unverändert)
- [ ] Neue Round-Trip + Gating-Tests
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(quest): quest progress persistence + prerequisites gating`

## Done When

Quest gestartet, App killed, App wieder auf → Quest zeigt vorigen Step,
Chat-Verlauf da. Quest mit unerfüllter Voraussetzung erscheint im
Gesperrt-Bucket mit Hinweis-Text.

## Risiko

`QuestRunnerController.build(questId)` ist Family — Riverpod 3 keepAlive
+ DB-Sync kann Async-State-Subtilitäten haben. Falls UI-Flicker: in
`main.dart` pre-warm `dbSnapshotProvider` lädt Quest-Progress vorab; Chat-
History bleibt lazy.
