import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../settings/parent_gate.dart';
import 'real_savings_goal_repository.dart';

/// Welle C: Echtes-Sparziel-Begleiter. Das Kind setzt ein reales Sparziel,
/// trägt Fortschritt ein; wenn erreicht, bestätigen die Eltern per PIN und
/// das Spiel belohnt mit XP + Trophäe. Brücke echtes Sparen ↔ Spiel.
class RealSavingsGoalPage extends ConsumerWidget {
  const RealSavingsGoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(realSavingsGoalRepositoryProvider);
    final repo = ref.read(realSavingsGoalRepositoryProvider.notifier);
    final active = repo.activeGoal;
    final confirmed = goals
        .where((g) => g.status == SavingsGoalStatus.confirmed)
        .toList();

    return PhoneFrame(
      appName: 'Echtes Sparziel',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          const PixelPanel(
            background: FgColors.backgroundDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🐷 Spar dir was Echtes zusammen',
                    style: FgTypography.bodyL),
                SizedBox(height: FgSpacing.xs),
                Text(
                  'Setz dir ein echtes Sparziel (z. B. ein Spiel oder ein '
                  'Fahrrad). Trag ein, wenn du Geld zur Seite gelegt hast. '
                  'Wenn du es geschafft hast, bestätigen es deine Eltern — '
                  'dann gibt es im Spiel XP und eine Trophäe!',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          if (active == null)
            _CreateGoalForm(
              onCreate: (emoji, title, targetCents) async {
                await repo.createGoal(
                  emoji: emoji,
                  title: title,
                  targetCents: targetCents,
                  createdIso: _today(),
                );
                if (context.mounted) {
                  showFgSnack(context, '$emoji Ziel „$title" gesetzt!');
                }
              },
            )
          else
            _ActiveGoalCard(goal: active),
          if (confirmed.isNotEmpty) ...[
            const SizedBox(height: FgSpacing.l),
            const Text('🏆 Geschaffte Ziele', style: FgTypography.bodyL),
            const SizedBox(height: FgSpacing.s),
            for (final g in confirmed)
              Padding(
                padding: const EdgeInsets.only(bottom: FgSpacing.xs),
                child: PixelPanel(
                  background: FgColors.success.withValues(alpha: 0.12),
                  child: Row(
                    children: [
                      Text(g.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: FgSpacing.s),
                      Expanded(
                        child: Text(g.title, style: FgTypography.bodyM),
                      ),
                      Text(Money.cents(g.targetCents).formatEur(),
                          style: FgTypography.bodyM
                              .copyWith(color: FgColors.success)),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _today() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}';
  }
}

class _CreateGoalForm extends StatefulWidget {
  const _CreateGoalForm({required this.onCreate});

  final Future<void> Function(String emoji, String title, int targetCents)
      onCreate;

  @override
  State<_CreateGoalForm> createState() => _CreateGoalFormState();
}

class _CreateGoalFormState extends State<_CreateGoalForm> {
  final _titleCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  String _emoji = '🐷';

  static const _emojis = ['🐷', '🎮', '🚲', '👟', '📱', '🎧', '⚽', '🎸'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    final eur = int.tryParse(_targetCtrl.text.trim());
    if (title.isEmpty) {
      showFgSnack(context, 'Gib deinem Ziel einen Namen.', isError: true);
      return;
    }
    if (eur == null || eur <= 0) {
      showFgSnack(context, 'Gib einen Zielbetrag in € ein.', isError: true);
      return;
    }
    widget.onCreate(_emoji, title, eur * 100);
    _titleCtrl.clear();
    _targetCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Neues Sparziel', style: FgTypography.bodyL),
          const SizedBox(height: FgSpacing.s),
          Wrap(
            spacing: FgSpacing.xs,
            children: [
              for (final e in _emojis)
                Semantics(
                  button: true,
                  selected: _emoji == e,
                  label: 'Symbol $e wählen',
                  child: GestureDetector(
                    onTap: () => setState(() => _emoji = e),
                    child: Container(
                      constraints: const BoxConstraints(
                          minWidth: 48, minHeight: 48),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(FgSpacing.xs),
                      decoration: BoxDecoration(
                        color: _emoji == e
                            ? FgColors.primary.withValues(alpha: 0.3)
                            : FgColors.backgroundElevated,
                        borderRadius: BorderRadius.circular(8),
                        // A11y 1.4.1: Auswahl nicht nur per Farbe.
                        border: _emoji == e
                            ? Border.all(color: FgColors.primary, width: 2)
                            : null,
                      ),
                      child: ExcludeSemantics(
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FgSpacing.s),
          TextField(
            controller: _titleCtrl,
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              labelText: 'Wofür sparst du?',
              hintText: 'z. B. neues Spiel',
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          TextField(
            controller: _targetCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              labelText: 'Zielbetrag in €',
              hintText: 'z. B. 50',
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          PixelButton(
            label: 'Ziel anlegen',
            background: FgColors.primary,
            foreground: FgColors.onPrimary,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _ActiveGoalCard extends ConsumerWidget {
  const _ActiveGoalCard({required this.goal});

  final RealSavingsGoal goal;

  Future<void> _addProgress(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final eur = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('Wie viel hast du gespart?',
            style: FgTypography.bodyL),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
              labelText: 'Betrag in €', hintText: 'z. B. 10'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(int.tryParse(ctrl.text.trim())),
            child: const Text('Eintragen'),
          ),
        ],
      ),
    );
    if (eur == null || eur <= 0) return;
    await ref
        .read(realSavingsGoalRepositoryProvider.notifier)
        .addProgress(goal.rowId, eur * 100);
    if (context.mounted) {
      showFgSnack(context, '💪 $eur € eingetragen — weiter so!');
    }
  }

  Future<void> _withdraw(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final eur = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('Geld entnehmen', style: FgTypography.bodyL),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manchmal braucht man das Ersparte doch früher. Wie viel '
              'nimmst du raus? (max. ${Money.cents(goal.savedCents).formatEur()})',
              style: FgTypography.bodyS,
            ),
            const SizedBox(height: FgSpacing.s),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
              labelText: 'Betrag in €', hintText: 'z. B. 10'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(ctx).pop(int.tryParse(ctrl.text.trim())),
            child: const Text('Entnehmen'),
          ),
        ],
      ),
    );
    if (eur == null || eur <= 0) return;
    await ref
        .read(realSavingsGoalRepositoryProvider.notifier)
        .withdraw(goal.rowId, eur * 100);
    if (context.mounted) {
      showFgSnack(context, '➖ $eur € entnommen.');
    }
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    // Belohnung nur mit Eltern-Freigabe. Ohne gesetzten PIN führt der Gate
    // ins Einrichten — vorher gab es ohne PIN gar keine Prüfung, das Kind
    // konnte sich die XP und die Trophäe selbst geben.
    if (!await ParentGate.require(context, ref)) return;
    if (!context.mounted) return;
    final dayIndex = ref.read(gameClockProvider).dayIndex;
    final xp = await ref
        .read(realSavingsGoalRepositoryProvider.notifier)
        .confirmReached(
          rowId: goal.rowId,
          confirmedIso: _todayStr(),
          dayIndex: dayIndex,
        );
    if (context.mounted && xp > 0) {
      showFgSnack(
        context,
        '🎉 Bestätigt! +$xp XP und die Trophäe „Echtes Sparen" 🐷',
        duration: const Duration(seconds: 4),
      );
    }
  }

  static String _todayStr() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reached = goal.isReached;
    final rewardXp = savingsGoalRewardXp(goal.targetCents);
    return PixelPanel(
      background: reached
          ? FgColors.success.withValues(alpha: 0.15)
          : FgColors.backgroundElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(goal.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(goal.title,
                    style: FgTypography.bodyL
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.s),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 14,
              backgroundColor: FgColors.backgroundDeep,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(FgColors.success),
            ),
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            '${Money.cents(goal.savedCents).formatEur()} von '
            '${Money.cents(goal.targetCents).formatEur()} gespart '
            '(${(goal.progress * 100).round()} %)',
            style: FgTypography.bodyM.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: FgSpacing.m),
          if (reached) ...[
            Text('🎉 Ziel erreicht! Lass es deine Eltern bestätigen — '
                'dann gibt es +$rewardXp XP + die Trophäe.',
                style: FgTypography.bodyM
                    .copyWith(color: FgColors.success)),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '🔒 Eltern bestätigen → Belohnung',
              background: FgColors.success,
              foreground: FgColors.onPrimary,
              onPressed: () => _confirm(context, ref),
            ),
          ] else ...[
            PixelButton(
              label: '💪 Gespartes eintragen',
              background: FgColors.primary,
              foreground: FgColors.onPrimary,
              onPressed: () => _addProgress(context, ref),
            ),
          ],
          // Notgroschen-Zugriff: an den Topf darf man, wenn man muss.
          if (goal.savedCents > 0) ...[
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '➖ Geld entnehmen',
              background: FgColors.backgroundElevated,
              foreground: FgColors.onSurface,
              onPressed: () => _withdraw(context, ref),
            ),
          ],
          const SizedBox(height: FgSpacing.s),
          TextButton(
            onPressed: () => ref
                .read(realSavingsGoalRepositoryProvider.notifier)
                .remove(goal.rowId),
            child: Text('Ziel verwerfen',
                style:
                    FgTypography.bodyS.copyWith(color: FgColors.alert)),
          ),
        ],
      ),
    );
  }
}
