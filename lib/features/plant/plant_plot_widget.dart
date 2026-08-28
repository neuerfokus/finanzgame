import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';
import '../../domain/plant/plant.dart';

/// Spec-45 Welle-7: Flutter-Plot-Cell statt Flame-Component.
/// Fixe Größe, kein Resize bei mehr Plots — wächst stattdessen nach
/// rechts via horizontalem GridView.
class PlantPlotWidget extends StatelessWidget {
  const PlantPlotWidget({
    required this.plotIndex,
    required this.plant,
    required this.onEmptyTap,
    required this.onReadyTap,
    this.currentDayIndex,
    super.key,
  });

  final int plotIndex;
  final Plant? plant;
  final void Function(int plotIndex) onEmptyTap;
  final void Function(int plotIndex) onReadyTap;
  /// Spec-45 D1/D2: aktueller Spieltag für Restzeit-Berechnung im Tooltip.
  /// Null = kein Tooltip (Tests/Pre-Setup).
  final int? currentDayIndex;

  /// Was TalkBack vorliest. Ohne das war die gesamte Pflanz-Mechanik — der
  /// Kern-Loop der Spar-Insel — fuer eine blinde Spielerin unbedienbar: der
  /// Zustand steckt ausschliesslich in Emoji, Rahmenfarbe und der Fuellung
  /// des Wachstumsbalkens, und der GestureDetector meldete nur "Doppeltippen
  /// zum Aktivieren", ohne zu sagen, was passieren wuerde.
  String _semantik() {
    final p = plant;
    final nr = plotIndex + 1;
    if (p == null) return 'Feld $nr, leer. Antippen zum Bepflanzen.';
    final name = p.kind.displayName;
    switch (p.status) {
      case PlantStatus.withered:
        return 'Feld $nr, $name verdorrt. Antippen zum Neubepflanzen.';
      case PlantStatus.ready:
        return 'Feld $nr, $name erntereif. Antippen zum Ernten.';
      case PlantStatus.growing:
        final tag = currentDayIndex;
        if (tag == null) return 'Feld $nr, $name wächst.';
        final rest = p.plantedOnDayIndex +
            PlantKinds.spec(p.kind).growDays -
            tag;
        if (rest <= 0) return 'Feld $nr, $name fast reif.';
        return 'Feld $nr, $name wächst, '
            'noch $rest ${rest == 1 ? 'Tag' : 'Tage'}.';
      case PlantStatus.harvested:
        return 'Feld $nr, $name abgeerntet.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _semantik(),
      child: ExcludeSemantics(child: _buildTappable(context)),
    );
  }

  Widget _buildTappable(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final p = plant;
        // Welle-8: Withered = behandelt wie leer, sonst kann der
        // Spieler nicht mehr pflanzen wenn alle Plots verdorrt sind.
        if (p == null || p.status == PlantStatus.withered) {
          onEmptyTap(plotIndex);
        } else if (p.status == PlantStatus.ready) {
          onReadyTap(plotIndex);
        }
      },
      onLongPress: () => _showInfoSheet(context),
      child: Container(
        margin: const EdgeInsets.all(FgSpacing.xs),
        decoration: BoxDecoration(
          color: const Color(0xFF5A3A1F),
          border: Border.all(
            color: plant?.status == PlantStatus.ready
                ? FgColors.primary
                : FgColors.outline,
            width: plant?.status == PlantStatus.ready ? 3 : 2,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final p = plant;
    if (p == null) {
      return const Padding(
        padding: EdgeInsets.all(6),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 48,
              color: Color(0xFF8B6B3F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    final spec = PlantKinds.spec(p.kind);
    final fraction = (p.currentStage / spec.stages).clamp(0.0, 1.0);
    final isReady = p.status == PlantStatus.ready;
    final isWithered = p.status == PlantStatus.withered;
    // Welle-8 Round 11: Stack.fit=expand garantiert dass alle Stack-Children
    // die volle Cell-Größe bekommen — Emoji im Center wird sonst evtl. mit
    // 0×0 gerendert und nicht sichtbar.
    return Stack(
      fit: StackFit.expand,
      children: [
        // Growth-bar als Hintergrund unten.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: FractionallySizedBox(
            heightFactor: isReady ? 1.0 : fraction.clamp(0.15, 1.0),
            child: Container(
              color: isWithered
                  ? FgColors.alert.withValues(alpha: 0.4)
                  : isReady
                      ? FgColors.primary.withValues(alpha: 0.7)
                      : FgColors.success.withValues(alpha: 0.5),
            ),
          ),
        ),
        // Emoji im Zentrum mit Schatten für bessere Sichtbarkeit
        // über growth-bar. Welle-8 Round 12: FittedBox skaliert das Emoji
        // auf die Cell-Größe — sonst overflowt fontSize 72 in 4-spaltigen
        // Grids und User sieht nichts.
        Padding(
          padding: const EdgeInsets.all(6),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              isWithered ? '🍂' : p.kind.emoji,
              style: const TextStyle(
                fontSize: 64,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Color(0xCC000000),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Reife-Indikator oben rechts.
        if (isReady)
          const Positioned(
            top: 4,
            right: 4,
            child: Text('✨', style: TextStyle(fontSize: 18)),
          ),
        if (isWithered)
          const Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Text(
              'Tippen → neu',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  /// Spec-45 D1/D2: BottomSheet mit Reife-/Withered-Tooltip bei Long-Press.
  void _showInfoSheet(BuildContext context) {
    final p = plant;
    final title = p == null ? 'Leeres Beet' : p.kind.displayName;
    final emoji = p == null ? '🟫' : p.kind.emoji;
    final body = _infoBody(p);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FgColors.backgroundDeep,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(FgSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: FgSpacing.s),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: FgColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FgSpacing.m),
              Text(
                body,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: FgSpacing.m),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _infoBody(Plant? p) {
    if (p == null) {
      return 'Tippe kurz, um eine Pflanze zu setzen.\n\n'
          'Im Pflanz-Menü stehen Kosten, erwarteter Ertrag, '
          'Wachstumstage und passende Jahreszeiten.';
    }
    final spec = PlantKinds.spec(p.kind);
    switch (p.status) {
      case PlantStatus.ready:
        return 'Erntereif! ✨\n\n'
            'Tippe kurz, um zu ernten.\n'
            'Erwarteter Ertrag: ${spec.yield_.formatEur()} '
            '(Wetter kann ihn leicht verändern).';
      case PlantStatus.withered:
        return 'Verdorrt 💀\n\n'
            'Wahrscheinliche Ursache:\n'
            '• Sturm-Event hat das Beet zerstört, oder\n'
            '• zu lange nicht geerntet, oder\n'
            '• Pflanze nicht in passender Jahreszeit.\n\n'
            'Tippe lang, um Beet zurückzusetzen — bei nächstem '
            'Klick auf "+" wird neu gepflanzt.';
      case PlantStatus.harvested:
        return 'Bereits geerntet — Beet ist frei.';
      case PlantStatus.growing:
        final stage = p.currentStage;
        final percent = ((stage / spec.stages) * 100).clamp(0, 100).round();
        final dayIdx = currentDayIndex;
        final daysLeft = dayIdx == null
            ? null
            : (p.plantedOnDayIndex + spec.growDays - dayIdx).clamp(0, 999);
        final restLine = daysLeft == null
            ? ''
            : '\nNoch ~$daysLeft Tag${daysLeft == 1 ? '' : 'e'} bis reif.';
        return 'Wächst — Stufe $stage / ${spec.stages} ($percent %)$restLine\n'
            '\n'
            'Kosten beim Setzen: ${spec.cost.formatEur()}\n'
            'Erwarteter Ertrag: ${spec.yield_.formatEur()}\n'
            'Wachstumszeit: ${spec.growDays} Tage';
    }
  }
}
