import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../data/quest/quest_asset_repository.dart';
import '../daily_goal/daily_goal_banner.dart';
import '../../domain/quest/quest.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'event_triggered_quests.dart';
import 'quest_availability.dart';
import 'quest_failure_repository.dart';
import 'quest_progress_repository.dart';
import 'quest_runner_controller.dart';
import 'quest_runner_page.dart';

/// Lists bundled quests split into three buckets:
/// - **Aktiv** — started but not yet completed (`status == 'running'`)
/// - **Verfügbar** — never started AND all prerequisites met
/// - **Gesperrt** — at least one prerequisite still missing
///
/// Locked entries render with a lock icon, the missing prereq id, and no tap
/// handler. Tapping any other entry pushes the runner; thanks to the
/// keep-alive `QuestRunnerController`, the same instance is reused across
/// pushes so the chat stream + step survive navigation.
/// Spec-43 v4: Quest-Kategorien für Tab-Filter.
enum QuestCategory {
  alle('Alle'),
  grundlagen('Grundlagen'),
  sparen('Sparen'),
  aktien('Aktien'),
  krypto('Krypto'),
  vorsorge('Vorsorge');

  const QuestCategory(this.label);
  final String label;
}

QuestCategory _categoryFor(Quest q) {
  final loc = q.location.toLowerCase();
  final id = q.id.toLowerCase();
  if (loc.contains('spar') || id.contains('spar')) {
    return QuestCategory.sparen;
  }
  if (loc.contains('etf') ||
      loc.contains('aktien') ||
      id.contains('etf') ||
      id.contains('aktien')) {
    return QuestCategory.aktien;
  }
  if (loc.contains('vulkan') || id.contains('krypto')) {
    return QuestCategory.krypto;
  }
  if (loc.contains('vorsorge') ||
      id.contains('riester') ||
      id.contains('bauspar') ||
      id.contains('versicher')) {
    return QuestCategory.vorsorge;
  }
  return QuestCategory.grundlagen;
}

class QuestListPage extends ConsumerStatefulWidget {
  const QuestListPage({super.key});

  @override
  ConsumerState<QuestListPage> createState() => _QuestListPageState();
}

class _QuestListPageState extends ConsumerState<QuestListPage> {
  QuestCategory _category = QuestCategory.alle;

  @override
  Widget build(BuildContext context) {
    final questsAsync = ref.watch(questsProvider);
    final progress = ref.watch(questProgressRepositoryProvider);
    // Sprint C4: event-getriggerte Quests werden bis zum Trigger
    // ausgeblendet (sonst sähe der Spieler Spoiler).
    final eventVisible = ref.watch(eventTriggeredQuestsProvider);
    // Home-Screen-Cleanup: Tagesziel lebt jetzt hier oben (statt als
    // Dauer-Banner auf dem Springboard).
    final dayIndex = ref.watch(gameClockProvider).dayIndex;

    return PhoneFrame(
      appName: 'Quests',
      onBack: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          DailyGoalBanner(dayIndex: dayIndex),
          _CategoryTabs(
            selected: _category,
            onChanged: (c) => setState(() => _category = c),
          ),
          Expanded(
            child: questsAsync.when(
              data: (quests) {
                // Sprint C4: event-gating zuerst, dann Kategorie-Filter.
                final visible = quests.where((q) =>
                    !EventTriggeredQuests.knownEventGatedIds.contains(q.id) ||
                    eventVisible.contains(q.id));
                final filtered = _category == QuestCategory.alle
                    ? visible.toList()
                    : visible
                        .where((q) => _categoryFor(q) == _category)
                        .toList();
                return _buildBuckets(filtered, progress);
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(FgSpacing.l),
                child: Text(
                  'Quests konnten nicht geladen werden: $e',
                  style: FgTypography.bodyM,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuckets(
    List<Quest> quests,
    Map<String, QuestProgress> progress,
  ) {
    // spec-30: split into 4 buckets so completed quests can't be retapped.
    final active = <Quest>[];
    final available = <Quest>[];
    final completed = <Quest>[];
    final locked = <Quest>[];
    for (final q in quests) {
      final row = progress[q.id];
      if (row != null && row.status == questStatusCompleted) {
        completed.add(q);
      } else if (row != null && row.status == questStatusRunning) {
        active.add(q);
      } else if (isQuestAvailable(q, progress)) {
        available.add(q);
      } else {
        locked.add(q);
      }
    }

    // Spec-43 v3: Active/Available/Completed bleiben bei cap 3 (Fokus).
    // Gesperrt zeigt alle — User will Überblick was später kommt.
    const limit = 3;
    final activeShown = active.take(limit).toList();
    final availableShown = available.take(limit).toList();
    final completedShown = completed.take(limit).toList();
    final lockedShown = locked; // unbegrenzt
    return ListView(
      padding: const EdgeInsets.all(FgSpacing.l),
      children: [
        if (activeShown.isNotEmpty) ...[
          _BucketHeader(
            label: 'Aktiv${active.length > limit ? " (${active.length})" : ""}',
          ),
          for (final q in activeShown)
            _QuestRow(quest: q, accent: FgColors.info, badge: '▶ Aktiv'),
        ],
        if (availableShown.isNotEmpty) ...[
          _BucketHeader(
            label:
                'Neu — noch nicht gestartet${available.length > limit ? " (${available.length})" : ""}',
          ),
          for (final q in availableShown)
            _QuestRow(
              quest: q,
              accent: FgColors.success,
              badge: '✨ Neu',
            ),
        ],
        if (completedShown.isNotEmpty) ...[
          _BucketHeader(
            label:
                'Erledigt${completed.length > limit ? " (${completed.length})" : ""}',
          ),
          for (final q in completedShown) _CompletedQuestRow(quest: q),
        ],
        if (lockedShown.isNotEmpty) ...[
          _BucketHeader(
            label:
                'Gesperrt${locked.length > limit ? " (${locked.length})" : ""}',
          ),
          for (final q in lockedShown) _LockedQuestRow(quest: q),
        ],
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.selected, required this.onChanged});

  final QuestCategory selected;
  final void Function(QuestCategory) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: FgSpacing.s),
        children: [
          for (final c in QuestCategory.values)
            Padding(
              padding: const EdgeInsets.only(right: FgSpacing.xs),
              child: ChoiceChip(
                label: Text(c.label,
                    style: FgTypography.bodyS.copyWith(
                      color: c == selected
                          ? FgColors.onPrimary
                          : FgColors.onSurface,
                    )),
                selected: c == selected,
                backgroundColor: FgColors.backgroundElevated,
                selectedColor: FgColors.primary,
                onSelected: (_) => onChanged(c),
              ),
            ),
        ],
      ),
    );
  }
}

class _BucketHeader extends StatelessWidget {
  const _BucketHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: FgSpacing.s,
        bottom: FgSpacing.s,
      ),
      child: Text(label, style: FgTypography.bodyL),
    );
  }
}

/// Welle-8: harter Cap 3 neue Quest-Starts pro Spieltag. Aktive
/// (running) Quests fortsetzen geht ohne Block.
const int kDailyQuestStartCap = 3;

class _QuestRow extends ConsumerWidget {
  const _QuestRow({
    required this.quest,
    this.accent,
    this.badge,
  });
  final Quest quest;
  final Color? accent;
  final String? badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final progress = ref.read(questProgressRepositoryProvider);
          final today = ref.read(gameClockProvider).dayIndex;
          final existing = progress[quest.id];
          // Quest läuft schon → einfach öffnen, kein neuer Start.
          if (existing != null) {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => QuestRunnerPage(quest: quest),
              ),
            );
            return;
          }
          // Welle-8 Round 3: Cooldown nach Quest-Fail.
          final failRepo =
              ref.read(questFailureRepositoryProvider.notifier);
          if (failRepo.isOnCooldown(quest.id, today)) {
            final daysLeft = failRepo.daysUntilRetry(quest.id, today);
            showFgSnack(
              context,
              '💔 Quest war falsch beantwortet. Neuer Versuch '
              'in $daysLeft Tag${daysLeft == 1 ? '' : 'en'} '
              '— schlafe weiter.',
              duration: const Duration(seconds: 3),
              isError: true,
            );
            return;
          }
          // Welle-8: zähle heute neu gestartete Quests.
          //
          // L7 (Analyse 2026-08): gezählt wurden nur noch VORHANDENE
          // Progress-Zeilen. Wer eine Quest zweimal falsch beantwortet,
          // verliert seine Zeile aber (`deleteQuestProgress`) — der Versuch
          // verschwand damit aus der Tageszählung und man konnte eine vierte
          // Quest starten. Heute gescheiterte Quests zählen deshalb mit.
          //
          // Bewusste Ungenauigkeit: eine gestern begonnene und heute
          // gescheiterte Quest zählt gegen das heutige Kontingent. Das genau
          // zu trennen bräuchte den Starttag in der Fail-Zeile (Schema);
          // zulasten des Spielers zu irren ist hier das kleinere Übel, weil
          // der Cap ohnehin nur Quest-Hetze bremsen soll.
          final failedToday = ref
              .read(questFailureRepositoryProvider)
              .values
              .where((day) => day == today)
              .length;
          final startedToday = progress.values
                  .where((p) => p.startedOnDayIndex == today)
                  .length +
              failedToday;
          if (startedToday >= kDailyQuestStartCap) {
            showFgSnack(
              context,
              'Max 3 neue Quests pro Tag. '
              'Schlafen + neuer Tag, dann geht\'s weiter.',
              duration: const Duration(seconds: 3),
            );
            return;
          }
          // Frischer Start (kein Progress): der keepAlive-QuestRunnerController
          // wird hier invalidiert. Sonst hängt eine zuvor 2× falsch
          // beantwortete (→ abgebrochene) Quest im alten questAborted-Zustand
          // fest und startet auch nach abgelaufenem 2-Tage-Cooldown NICHT neu
          // — build() rebuildet keepAlive nie von selbst. Invalidate erzwingt
          // einen frischen build() ab Schritt 0.
          ref.invalidate(questRunnerControllerProvider(quest));
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => QuestRunnerPage(quest: quest),
            ),
          );
        },
        child: PixelPanel(
          background: accent != null
              ? accent!.withValues(alpha: 0.15)
              : FgColors.backgroundElevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accent ?? FgColors.neutral,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(FgRadius.tight),
                        ),
                      ),
                      child: Text(
                        badge!,
                        style: FgTypography.bodyS.copyWith(
                          color: FgColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: FgSpacing.s),
                  ],
                  Expanded(
                    child: Text(quest.title, style: FgTypography.bodyL),
                  ),
                ],
              ),
              const SizedBox(height: FgSpacing.xs),
              () {
                final diff = _questDifficulty(quest.id);
                return Text(
                  '${diff.emoji} ${diff.label}  ·  '
                  'Belohnung: ${quest.reward.cash.formatEur()}  ·  '
                  '${quest.reward.xp} XP',
                  style: FgTypography.bodyS.copyWith(color: diff.color),
                );
              }(),
            ],
          ),
        ),
      ),
    );
  }
}

/// spec-30: read-only row for completed quests. No tap handler so the
/// player can't accidentally restart a quest they already finished.
class _CompletedQuestRow extends StatelessWidget {
  const _CompletedQuestRow({required this.quest});
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      child: Opacity(
        opacity: 0.7,
        child: PixelPanel(
          child: Row(
            children: [
              const Text('✔', style: TextStyle(fontSize: 22)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(quest.title, style: FgTypography.bodyL),
                    const SizedBox(height: FgSpacing.xs),
                    const Text(
                      'Erledigt — Belohnung kassiert.',
                      style: FgTypography.bodyS,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Spec-45 E2: Schwierigkeit aus Quest-Reihenfolge ableiten.
/// q00-q09 = Grundlagen 🟢, q10-q24 = Aufbau 🟡, q25+ = Fortgeschritten 🔴.
({String emoji, String label, Color color}) _questDifficulty(String id) {
  final match = RegExp(r'q(\d+)').firstMatch(id);
  final num = match == null ? 0 : int.tryParse(match.group(1)!) ?? 0;
  if (num <= 9) {
    return (emoji: '🟢', label: 'Grundlagen', color: FgColors.success);
  }
  if (num <= 24) {
    return (emoji: '🟡', label: 'Aufbau', color: FgColors.info);
  }
  return (emoji: '🔴', label: 'Fortgeschritten', color: FgColors.alert);
}

class _LockedQuestRow extends StatelessWidget {
  const _LockedQuestRow({required this.quest});
  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final prereq = quest.prerequisites.isEmpty
        ? null
        : quest.prerequisites.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: FgSpacing.m),
      // No GestureDetector — locked rows are non-interactive.
      child: PixelPanel(
        child: Row(
          children: [
            const Icon(Icons.lock, size: 18),
            const SizedBox(width: FgSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quest.title, style: FgTypography.bodyL),
                  const SizedBox(height: FgSpacing.xs),
                  Text(
                    prereq == null
                        ? '🔒 Noch nicht freigeschaltet'
                        : '🔒 Erst $prereq abschließen',
                    style: FgTypography.bodyS,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
