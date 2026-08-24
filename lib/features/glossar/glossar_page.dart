import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/compound_chart.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../../ui/widgets/what_if_simulator.dart';
import '../daily_quiz/daily_quiz_state.dart';
import '../daily_quiz/wissens_quiz_page.dart';
import '../daily_quiz/wissens_quiz_stats.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import 'glossar_entries.dart';

/// spec-35 phase N: alphabetical glossary of finance terms used in
/// Finanzgame. Tap-to-expand entries via ExpansionTile.
class GlossarPage extends ConsumerStatefulWidget {
  const GlossarPage({super.key});

  @override
  ConsumerState<GlossarPage> createState() => _GlossarPageState();
}

class _GlossarPageState extends ConsumerState<GlossarPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(wissensQuizStatsRepoProvider);
    final learned = ref.watch(learnedTopicsProvider);
    final q = _query.toLowerCase().trim();
    final filtered = q.isEmpty
        ? [...kGlossar]
        : [
            for (final e in kGlossar)
              if (e.term.toLowerCase().contains(q) ||
                  e.definition.toLowerCase().contains(q) ||
                  (e.example?.toLowerCase().contains(q) ?? false) ||
                  e.topic.toLowerCase().contains(q))
                e
          ];
    final sorted = filtered
      ..sort((a, b) {
        final aLearned = learned.contains(a.topic);
        final bLearned = learned.contains(b.topic);
        if (aLearned != bLearned) return aLearned ? -1 : 1;
        return a.term.compareTo(b.term);
      });
    return PhoneFrame(
      appName: 'Wissen',
      child: ListView.builder(
        padding: const EdgeInsets.all(FgSpacing.l),
        itemCount: sorted.length + 1,
        itemBuilder: (context, idx) {
          if (idx == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: FgSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welle-8 Round 22 v5: Such-Feld nach Begriff,
                  // Definition, Beispiel oder Topic.
                  TextField(
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: '🔍 Suche nach Begriff / Schlagwort',
                      border: OutlineInputBorder(),
                    ),
                    style: FgTypography.bodyM,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: FgSpacing.s),
                  PixelButton(
                    label: '🎓 Wissens-Quiz starten (10 Fragen)',
                    background: FgColors.secondary,
                    foreground: FgColors.onSurface,
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const WissensQuizPage(),
                        ),
                      );
                    },
                  ),
                  // Round 28 v4: Wissens-Meisterprüfung (nur schwere Fragen)
                  // — Endgame, erst ab Level 20 sichtbar.
                  if (LevelSystem.levelFor(ref.watch(xpRepositoryProvider)) >=
                      20) ...[
                    const SizedBox(height: FgSpacing.s),
                    PixelButton(
                      label: '🏛 Meisterprüfung (nur schwere Fragen)',
                      background: FgColors.primary,
                      foreground: FgColors.onPrimary,
                      onPressed: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                const WissensQuizPage(expertMode: true),
                          ),
                        );
                      },
                    ),
                  ],
                  if (stats.sessions > 0) ...[
                    const SizedBox(height: FgSpacing.s),
                    PixelPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📊 Deine Quiz-Statistik',
                            style: FgTypography.bodyL,
                          ),
                          const SizedBox(height: FgSpacing.xs),
                          Text(
                            'Sessions: ${stats.sessions}  ·  '
                            'Bestleistung: ${stats.bestCorrect}/10',
                            style: FgTypography.bodyS,
                          ),
                          Text(
                            'Win-Rate gesamt: '
                            '${(stats.winRate * 100).toStringAsFixed(0)} %  '
                            '·  Letztes Ergebnis: '
                            '${stats.lastCorrect}/${stats.lastTotal}',
                            style: FgTypography.bodyS,
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Welle-8 Round 24 (#3): Was-wäre-wenn-Rechner.
                  const SizedBox(height: FgSpacing.s),
                  const PixelPanel(
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.only(
                        bottom: FgSpacing.s,
                      ),
                      iconColor: FgColors.primary,
                      collapsedIconColor: FgColors.onSurface,
                      title: Text(
                        '🔮 Was-wäre-wenn-Rechner',
                        style: FgTypography.bodyL,
                      ),
                      children: [WhatIfSimulator()],
                    ),
                  ),
                ],
              ),
            );
          }
          final i = idx - 1;
          final e = sorted[i];
          final isLearned = learned.contains(e.topic);
          return Padding(
            padding: const EdgeInsets.only(bottom: FgSpacing.s),
            child: PixelPanel(
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(
                  bottom: FgSpacing.s,
                ),
                iconColor: FgColors.primary,
                collapsedIconColor: FgColors.onSurface,
                title: Row(
                  children: [
                    Text(isLearned ? '✅' : '○',
                        style: TextStyle(
                          fontSize: 18,
                          color: isLearned
                              ? FgColors.success
                              : FgColors.outline,
                        )),
                    const SizedBox(width: FgSpacing.s),
                    Expanded(
                      child: Text(e.term, style: FgTypography.bodyL),
                    ),
                  ],
                ),
                children: [
                  if (!isLearned && e.topic.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: FgSpacing.xs),
                      child: Text(
                        '🔒 Noch nicht gelernt. Schließe eine Quest zum '
                        'Thema "${e.topic}" ab — oder beantworte eine '
                        'Quiz-Frage dazu richtig.',
                        style: FgTypography.bodyS.copyWith(
                          color: FgColors.onSurfaceMuted,
                        ),
                      ),
                    ),
                  ],
                  Text(e.definition, style: FgTypography.bodyM),
                  if (e.example != null) ...[
                    const SizedBox(height: FgSpacing.xs),
                    Text(
                      'Beispiel: ${e.example}',
                      style: FgTypography.bodyS
                          .copyWith(color: FgColors.info),
                    ),
                  ],
                  // Spec-42: bei Zinseszins-Eintrag das Vergleichs-Chart
                  // direkt einblenden.
                  if (e.term == 'Zinseszins') ...[
                    const SizedBox(height: FgSpacing.m),
                    const CompoundChart(),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
