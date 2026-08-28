import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import 'real_milestones_repository.dart';

/// Eltern-Eingabe echter Spar-/Lern-Erfolge (+150 XP je Eintrag) + Liste
/// zum Löschen. Früher in der (komplett PIN-gesperrten) Settings-Seite;
/// seit dem Echtes-Leben-Hub liegt das Formular dort und wird selbst per
/// Eltern-PIN freigeschaltet. Reine Anzeige der Erfolge bleibt im Zimmer.
class RealMilestonesSection extends ConsumerStatefulWidget {
  const RealMilestonesSection({super.key});

  @override
  ConsumerState<RealMilestonesSection> createState() =>
      _RealMilestonesSectionState();
}

class _RealMilestonesSectionState extends ConsumerState<RealMilestonesSection> {
  // Welle-8 Round 26: Kategorie (key, emoji, label). Emoji wird daraus
  // abgeleitet — kein separater Emoji-Picker mehr.
  static const List<({String key, String emoji, String label})> _categories = [
    (key: 'sparen', emoji: '💰', label: 'Sparen'),
    (key: 'lernen', emoji: '📚', label: 'Lernen'),
    (key: 'verzicht', emoji: '🚫', label: 'Verzicht'),
    (key: 'sonstiges', emoji: '⭐', label: 'Sonstiges'),
  ];

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();
  String _category = _categories.first.key;

  String get _emoji =>
      _categories.firstWhere((c) => c.key == _category).emoji;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  static String _today() {
    final n = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(n.day)}.${two(n.month)}.${n.year}';
  }

  Future<void> _add() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      showFgSnack(context, 'Bitte einen Text eingeben.', isError: true);
      return;
    }
    final amountText = _amountCtrl.text.trim().replaceAll(',', '.');
    int? cents;
    if (amountText.isNotEmpty) {
      final euros = double.tryParse(amountText);
      if (euros == null) {
        showFgSnack(context, 'Betrag ungültig.', isError: true);
        return;
      }
      cents = (euros * 100).round();
    }
    await ref.read(realMilestonesRepositoryProvider.notifier).add(
          emoji: _emoji,
          title: title,
          amountCents: cents,
          dateIso: _today(),
          category: _category,
        );
    if (!mounted) return;
    _titleCtrl.clear();
    _amountCtrl.clear();
    showFgSnack(context, 'Erfolg eingetragen ✅  +$kRealMilestoneXp XP');
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(realMilestonesRepositoryProvider);
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kategorie-Auswahl (bestimmt Emoji + Lern-Bezug).
          Wrap(
            spacing: FgSpacing.xs,
            runSpacing: FgSpacing.xs,
            children: [
              for (final c in _categories)
                GestureDetector(
                  onTap: () => setState(() => _category = c.key),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _category == c.key
                          ? FgColors.primary
                          : FgColors.backgroundDeep,
                      border: Border.all(
                        color: _category == c.key
                            ? FgColors.primary
                            : FgColors.outline,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      '${c.emoji} ${c.label}',
                      style: FgTypography.bodyS.copyWith(
                        color: _category == c.key
                            ? FgColors.onPrimary
                            : FgColors.onSurface,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            'Jeder Eintrag gibt deinem Kind +$kRealMilestoneXp XP im Spiel.',
            style: FgTypography.bodyS.copyWith(color: FgColors.info),
          ),
          const SizedBox(height: FgSpacing.s),
          TextField(
            controller: _titleCtrl,
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'z.B. 80 € aufs echte Sparbuch gelegt',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: FgSpacing.xs),
          TextField(
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: FgTypography.bodyM,
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Betrag in € (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: '➕ Erfolg eintragen',
            background: FgColors.success,
            foreground: FgColors.onSurface,
            onPressed: _add,
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: FgSpacing.m),
            const Divider(color: FgColors.outline, thickness: 1),
            for (final m in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(m.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: FgSpacing.xs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.amountCents != null
                                ? '${m.title}  (${Money.cents(m.amountCents!).formatEur()})'
                                : m.title,
                            style: FgTypography.bodyM,
                          ),
                          Text(m.dateIso, style: FgTypography.bodyS),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Eintrag löschen',
                      icon: const Icon(Icons.delete_outline,
                          color: FgColors.alert),
                      onPressed: () => ref
                          .read(realMilestonesRepositoryProvider.notifier)
                          .remove(m.rowId),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
