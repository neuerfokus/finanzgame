import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../settings/settings_repository.dart';
import '../xp/xp_repository.dart';
import 'decor_catalog.dart';
import 'decor_repository.dart';

/// Spec-43 Stage 1: Editor zum Platzieren von Decor-Items auf einer Insel.
///
/// Free-Placement im quadratischen Bühnenbereich. Tap auf Katalog-Item legt
/// neue Instanz mittig ab, Drag verschiebt, Tap rotiert, Long-Press öffnet
/// Entfernen-Dialog.
class IslandEditorPage extends ConsumerStatefulWidget {
  const IslandEditorPage({
    required this.islandId,
    required this.islandLabel,
    super.key,
  });

  final String islandId;
  final String islandLabel;

  @override
  ConsumerState<IslandEditorPage> createState() =>
      _IslandEditorPageState();
}

class _IslandEditorPageState extends ConsumerState<IslandEditorPage> {
  int? _selectedRowId;

  @override
  Widget build(BuildContext context) {
    final placements =
        ref.watch(decorRepositoryProvider.notifier).forIsland(widget.islandId);
    final settings = ref.read(settingsRepositoryProvider.notifier);
    final unlocked = settings.unlockedDecor();
    final xp = ref.watch(xpRepositoryProvider);

    return PhoneFrame(
      appName: '${widget.islandLabel} — Editor',
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: FgSpacing.l),
            child: Text(
              'Long-Press = Entfernen · Tap = Drehen · Drag = Verschieben',
              style: FgTypography.bodyS,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(FgSpacing.m),
              child: _Stage(
                islandId: widget.islandId,
                placements: placements,
                selectedRowId: _selectedRowId,
                onSelect: (rowId) =>
                    setState(() => _selectedRowId = rowId),
              ),
            ),
          ),
          _Catalog(
            islandId: widget.islandId,
            unlocked: unlocked,
            xp: xp,
            placementCount: placements.length,
          ),
        ],
      ),
    );
  }
}

/// Free-placement Bühne. Quadrat mit Wasser-BG, Decor-Items absolut
/// positioniert über normalisierte (x, y) ∈ [0, 1].
class _Stage extends ConsumerWidget {
  const _Stage({
    required this.islandId,
    required this.placements,
    required this.selectedRowId,
    required this.onSelect,
  });

  final String islandId;
  final List<DecorPlacement> placements;
  final int? selectedRowId;
  final void Function(int? rowId) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side =
            constraints.maxWidth.clamp(0, constraints.maxHeight).toDouble();
        return Center(
          child: SizedBox(
            width: side,
            height: side,
            child: GestureDetector(
              onTap: () => onSelect(null),
              child: Stack(
                children: [
                  // Insel-BG: Composite-PNG wenn vorhanden, sonst Fallback.
                  Positioned.fill(
                    child: PixelPanel(
                      child: Center(
                        child: Image.asset(
                          'assets/images/islands_composite/$islandId.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                  for (final p in placements)
                    _DecorItem(
                      placement: p,
                      side: side,
                      selected: p.rowId == selectedRowId,
                      onSelect: () => onSelect(p.rowId),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DecorItem extends ConsumerWidget {
  const _DecorItem({
    required this.placement,
    required this.side,
    required this.selected,
    required this.onSelect,
  });

  final DecorPlacement placement;
  final double side;
  final bool selected;
  final VoidCallback onSelect;

  static const double _size = 48;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spec = decorSpecById(placement.decorId);
    if (spec == null) return const SizedBox.shrink();
    final left = placement.x * side - _size / 2;
    final top = placement.y * side - _size / 2;
    final repo = ref.read(decorRepositoryProvider.notifier);

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onSelect();
          repo.update(placement.copyWith(rotation: (placement.rotation + 1) & 3));
        },
        onLongPress: () => _confirmRemove(context, ref),
        onPanUpdate: (details) {
          onSelect();
          final nx =
              ((placement.x * side) + details.delta.dx).clamp(0.0, side) / side;
          final ny =
              ((placement.y * side) + details.delta.dy).clamp(0.0, side) / side;
          repo.update(placement.copyWith(x: nx, y: ny));
        },
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: selected
                ? FgColors.primary.withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: selected
                ? Border.all(color: FgColors.primary, width: 2)
                : null,
          ),
          child: Transform.rotate(
            angle: placement.rotation * 1.5707963267948966,
            child: Center(
              child: Text(
                spec.glyph,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('Entfernen?', style: FgTypography.bodyL),
        content: const Text('Decor wird von der Insel entfernt.',
            style: FgTypography.bodyM),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Entfernen', style: FgTypography.bodyM),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(decorRepositoryProvider.notifier).remove(placement.rowId);
    }
  }
}

class _Catalog extends ConsumerWidget {
  const _Catalog({
    required this.islandId,
    required this.unlocked,
    required this.xp,
    required this.placementCount,
  });

  final String islandId;
  final Set<String> unlocked;
  final int xp;
  final int placementCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: FgColors.backgroundElevated,
      padding: const EdgeInsets.all(FgSpacing.m),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Decor ($placementCount/$kMaxDecorPerIsland)',
                  style: FgTypography.bodyM),
              Text('XP: $xp', style: FgTypography.bodyS),
            ],
          ),
          const SizedBox(height: FgSpacing.s),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kDecorCatalog.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: FgSpacing.s),
              itemBuilder: (context, i) {
                final spec = kDecorCatalog[i];
                final isUnlocked = unlocked.contains(spec.id);
                return _CatalogTile(
                  spec: spec,
                  unlocked: isUnlocked,
                  canAfford: xp >= spec.xpCost,
                  canPlace: placementCount < kMaxDecorPerIsland,
                  onTap: () => _onTap(context, ref, spec, isUnlocked),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    DecorSpec spec,
    bool isUnlocked,
  ) async {
    if (!isUnlocked) {
      final ok = await _confirmPurchase(context, spec);
      if (ok != true) return;
      final bought = ref
          .read(settingsRepositoryProvider.notifier)
          .purchaseDecor(decorId: spec.id, xpCost: spec.xpCost);
      if (!bought) {
        if (context.mounted) {
          showFgSnack(context, 'Nicht genug XP', isError: true);
        }
        return;
      }
    }
    if (placementCount >= kMaxDecorPerIsland) {
      if (context.mounted) {
        showFgSnack(context, 'Max $kMaxDecorPerIsland Items',
            isError: true);
      }
      return;
    }
    await ref.read(decorRepositoryProvider.notifier).place(
          islandId: islandId,
          decorId: spec.id,
          x: 0.5,
          y: 0.5,
        );
  }

  Future<bool?> _confirmPurchase(BuildContext context, DecorSpec spec) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text('${spec.glyph} ${spec.label} kaufen?',
            style: FgTypography.bodyL),
        content: Text(
          'Kostet ${spec.xpCost} XP. Danach beliebig oft platzierbar.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Kaufen', style: FgTypography.bodyM),
          ),
        ],
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({
    required this.spec,
    required this.unlocked,
    required this.canAfford,
    required this.canPlace,
    required this.onTap,
  });

  final DecorSpec spec;
  final bool unlocked;
  final bool canAfford;
  final bool canPlace;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = unlocked ? canPlace : canAfford;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: PixelButton(
        label: '${spec.glyph}\n'
            '${unlocked ? "+" : "${spec.xpCost} XP"}',
        background: unlocked ? spec.color : FgColors.backgroundPrimary,
        foreground: FgColors.onSurface,
        onPressed: enabled ? onTap : null,
      ),
    );
  }
}
