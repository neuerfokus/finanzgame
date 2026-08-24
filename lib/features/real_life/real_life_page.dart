import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../savings_goal/real_savings_goal_page.dart';
import '../settings/parent_gate.dart';
import '../zimmer/real_milestones_section.dart';

/// „Echtes Leben"-Hub: bündelt die Brücken zwischen echtem Leben und Spiel —
/// das echte Sparziel (kind-zugänglich) und das Eintragen echter Erfolge
/// (Eltern-PIN-gated). Vom Springboard erreichbar; die Erfolgs-Anzeige bleibt
/// in der Zimmer-Trophäenwand.
class RealLifePage extends ConsumerStatefulWidget {
  const RealLifePage({super.key});

  @override
  ConsumerState<RealLifePage> createState() => _RealLifePageState();
}

class _RealLifePageState extends ConsumerState<RealLifePage> {
  bool _milestonesUnlocked = false;

  Future<void> _unlockMilestones() async {
    // Eintragen gibt +150 XP pro Erfolg — also Eltern-Freigabe nötig. Ohne
    // gesetzten PIN war die Maske komplett offen und beliebig oft nutzbar.
    if (!await ParentGate.require(context, ref)) return;
    if (mounted) setState(() => _milestonesUnlocked = true);
  }

  @override
  Widget build(BuildContext context) {
    return PhoneFrame(
      appName: 'Echtes Leben',
      onBack: () => Navigator.of(context).pop(),
      child: ListView(
        padding: const EdgeInsets.all(FgSpacing.l),
        children: [
          const PixelPanel(
            background: FgColors.backgroundDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🌟 Echtes Leben', style: FgTypography.bodyL),
                SizedBox(height: FgSpacing.xs),
                Text(
                  'Hier trifft das Spiel auf dein echtes Leben: setz dir ein '
                  'echtes Sparziel — und deine Eltern können echte Erfolge '
                  'eintragen, die dir im Spiel XP bringen.',
                  style: FgTypography.bodyS,
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          // ── Echtes Sparziel (kind-zugänglich) ──
          PixelPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🐷 Echtes Sparziel', style: FgTypography.bodyL),
                const SizedBox(height: FgSpacing.xs),
                const Text(
                  'Spar dir was Echtes zusammen und trag deinen Fortschritt '
                  'ein. Geschafft? Eltern bestätigen → XP + Trophäe.',
                  style: FgTypography.bodyS,
                ),
                const SizedBox(height: FgSpacing.s),
                PixelButton(
                  label: 'Sparziel öffnen',
                  background: FgColors.primary,
                  foreground: FgColors.onPrimary,
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const RealSavingsGoalPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FgSpacing.m),
          // ── Echte Erfolge eintragen (Eltern-PIN) ──
          if (_milestonesUnlocked)
            const RealMilestonesSection()
          else
            PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🏅 Echte Erfolge eintragen',
                      style: FgTypography.bodyL),
                  const SizedBox(height: FgSpacing.xs),
                  const Text(
                    'Für Eltern: echte Spar-/Lern-Erfolge aus dem richtigen '
                    'Leben eintragen. Jeder Eintrag belohnt dein Kind im '
                    'Spiel. Die Erfolge erscheinen in der Trophäenwand im '
                    'Zimmer.',
                    style: FgTypography.bodyS,
                  ),
                  const SizedBox(height: FgSpacing.s),
                  PixelButton(
                    label: '🔒 Eltern: PIN eingeben',
                    background: FgColors.secondary,
                    foreground: FgColors.onPrimary,
                    onPressed: _unlockMilestones,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
