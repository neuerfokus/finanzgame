import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/wishlist/wish_item.dart';
import '../../ui/widgets/phone_frame.dart';
import '../settings/settings_repository.dart';
import '../../ui/widgets/pixel_button.dart';
import '../wishlist/wishlist_repository.dart';
import '../island_editor/decor_catalog.dart';
import '../island_editor/decor_repository.dart';
import '../life_goals/life_goals_page.dart';
import '../newgame/legacy_page.dart';
import '../newgame/new_game_state.dart';
import '../skills/skill_tree_page.dart';
import '../weekly_challenge/weekly_challenge_page.dart';
import 'achievement_detail_page.dart';
import 'avatar_shop_page.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';
import 'achievements.dart';
import 'achievements_repository.dart';
import 'furniture_catalog.dart';
import 'furniture_sprite.dart';
import 'furniture_repository.dart';
import 'furniture_shop_page.dart';
import 'real_milestones_repository.dart';
import '../../domain/economy/money.dart';

/// Bug-fix v28: Edit-Mode für Zimmer-Stage. Wenn true, ist Parent-Scroll
/// aus + Items per Pan verschiebbar.
class RoomEditModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
}

final roomEditModeProvider =
    NotifierProvider<RoomEditModeNotifier, bool>(RoomEditModeNotifier.new);

/// Zimmer-App page (spec-21).
///
/// Avatar (emoji placeholder until a sprite lands) + trophy grid +
/// erspielte Wunschartikel. The trophy grid renders every entry in
/// [kAchievements]; unlocked ones are colored, locked ones are greyed out
/// with a lock icon.
class ZimmerPage extends ConsumerWidget {
  const ZimmerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsRepositoryProvider);
    final wishlist = ref.watch(wishlistRepositoryProvider);
    final owned = wishlist.where((i) => i.ownedOnDayIndex != null).toList()
      ..sort((a, b) =>
          (b.ownedOnDayIndex ?? 0).compareTo(a.ownedOnDayIndex ?? 0));

    final editMode = ref.watch<bool>(roomEditModeProvider);
    return PhoneFrame(
      appName: 'Zimmer',
      child: SingleChildScrollView(
        // Bug-fix v28: im Edit-Mode Scroll aus damit Pan-Drag der
        // Stage-Items nicht vom Parent geschluckt wird.
        physics: editMode
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: FgSpacing.l,
          vertical: FgSpacing.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _AvatarBlock(),
            const SizedBox(height: FgSpacing.l),
            const _LevelBlock(),
            const SizedBox(height: FgSpacing.l),
            const _FurnitureSection(),
            const SizedBox(height: FgSpacing.l),
            _TrophyGrid(unlocked: achievements.keys.toSet()),
            // Welle-8 Round 24 (#10): echte Erfolge (von Papa eingetragen).
            const _RealMilestonesWall(),
            // spec-37: Erspielte-Wunschartikel-Sektion nur zeigen wenn
            // tatsächlich Items besessen werden.
            if (owned.isNotEmpty) ...[
              const SizedBox(height: FgSpacing.l),
              _OwnedItemsSection(items: owned),
            ],
            const SizedBox(height: FgSpacing.xl),
          ],
        ),
      ),
    );
  }
}

/// Welle-8 Round 24 (#10): Reihe „Echte Erfolge (von Papa)" in der
/// Trophäenwand. Zeigt von einem Elternteil eingetragene reale Spar-/Lern-Erfolge.
/// Versteckt sich komplett wenn keine Einträge existieren.
class _RealMilestonesWall extends ConsumerWidget {
  const _RealMilestonesWall();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(realMilestonesRepositoryProvider);
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: FgSpacing.l),
        const Text('🌟 Echte Erfolge',
            style: FgTypography.bodyL),
        const SizedBox(height: FgSpacing.s),
        for (final m in items)
          Container(
            margin: const EdgeInsets.only(bottom: FgSpacing.xs),
            padding: const EdgeInsets.all(FgSpacing.s),
            decoration: BoxDecoration(
              color: FgColors.backgroundElevated,
              border: Border.all(color: FgColors.success, width: 2),
            ),
            child: Row(
              children: [
                Text(m.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: FgSpacing.s),
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
              ],
            ),
          ),
      ],
    );
  }
}

class _LevelBlock extends ConsumerWidget {
  const _LevelBlock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpRepositoryProvider);
    // Round 28: auf Settings hören, damit der Skill-Punkte-Badge nach dem
    // Freischalten sofort aktualisiert.
    ref.watch(settingsRepositoryProvider);
    final level = LevelSystem.levelFor(xp);
    final title = LevelSystem.titleFor(level);
    final toNext = LevelSystem.xpToNext(xp);
    final atMax = level >= LevelSystem.maxLevel;
    // Round 28 v4: Prestige-/Meister-Level ★ ohne Obergrenze.
    final meister = LevelSystem.meisterLevelFor(xp);
    final progressMax = atMax
        ? LevelSystem.meisterXpPerLevel.toDouble()
        : (LevelSystem.xpForLevel(level + 1) - LevelSystem.xpForLevel(level))
            .toDouble();
    final progressNow = atMax
        ? (LevelSystem.meisterXpPerLevel - LevelSystem.xpToNextMeister(xp))
            .toDouble()
        : (xp - LevelSystem.xpForLevel(level)).toDouble();
    return Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.primary, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Level $level${atMax && meister > 0 ? '  ★$meister' : ''}',
                  style: FgTypography.display.copyWith(fontSize: 22)),
              const SizedBox(width: FgSpacing.s),
              Expanded(
                child: Text(title, style: FgTypography.bodyM),
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.s),
          ClipRRect(
            borderRadius:
                const BorderRadius.all(Radius.circular(FgRadius.tight)),
            child: LinearProgressIndicator(
              value: progressNow / progressMax,
              minHeight: 10,
              backgroundColor: FgColors.backgroundDeep,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(FgColors.primary),
            ),
          ),
          const SizedBox(height: FgSpacing.xs),
          Text(
            atMax
                ? 'XP: $xp  •  ${LevelSystem.xpToNextMeister(xp)} bis '
                    'Meister-Stern ★${meister + 1}'
                : 'XP: $xp  •  $toNext bis Level ${level + 1}',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.m),
          Builder(builder: (ctx) {
            final free =
                ref.read(settingsRepositoryProvider.notifier).availableSkillPoints();
            return PixelButton(
              label: free > 0
                  ? '🌟 Fähigkeiten · $free Punkt${free == 1 ? '' : 'e'} frei'
                  : '🌟 Fähigkeiten',
              background: free > 0 ? FgColors.success : FgColors.secondary,
              foreground: FgColors.onPrimary,
              onPressed: () => Navigator.of(ctx).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const SkillTreePage(),
                ),
              ),
            );
          }),
          const SizedBox(height: FgSpacing.s),
          // Round 28 v4: Wochen-Herausforderung (renewing) + Lebensziele.
          PixelButton(
            label: '🔥 Wochen-Challenge',
            background: FgColors.primary,
            foreground: FgColors.onPrimary,
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const WeeklyChallengePage(),
              ),
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: '🎯 Lebensziele',
            background: FgColors.secondary,
            foreground: FgColors.onPrimary,
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const LifeGoalsPage(),
              ),
            ),
          ),
          const SizedBox(height: FgSpacing.s),
          // Welle B: Vermächtnis-Prestige — Generation + permanente Boni.
          Builder(builder: (ctx) {
            final ng = ref.watch(newGameStateProvider);
            final freeLp =
                ref.read(newGameStateProvider.notifier).availableLegacyPoints();
            return PixelButton(
              label: freeLp > 0
                  ? '👑 Vermächtnis · Gen ${ng.generation} · $freeLp 🪙'
                  : '👑 Vermächtnis · Gen ${ng.generation}',
              background: freeLp > 0 ? FgColors.success : FgColors.secondary,
              foreground: FgColors.onPrimary,
              onPressed: () => Navigator.of(ctx).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const LegacyPage(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FurnitureSection extends ConsumerWidget {
  const _FurnitureSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final furniture = ref.watch(furnitureRepositoryProvider);
    return Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Einrichtung',
                  style: FgTypography.display.copyWith(fontSize: 20),
                ),
              ),
              Consumer(builder: (ctx, ref, _) {
                final editing = ref.watch<bool>(roomEditModeProvider);
                return PixelButton(
                  label: editing ? '✓ Fertig' : '✏ Verschieben',
                  background: editing ? FgColors.success : FgColors.info,
                  foreground: FgColors.onSurface,
                  onPressed: () =>
                      ref.read(roomEditModeProvider.notifier).toggle(),
                );
              }),
              const SizedBox(width: FgSpacing.s),
              PixelButton(
                label: 'Shop',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const FurnitureShopPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: FgSpacing.s),
          // spec-32: top half of the panel renders a tiny "room" diorama
          // where each owned item appears as a giant emoji on the floor.
          _RoomScene(furniture: furniture),
          const SizedBox(height: FgSpacing.m),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: FgSpacing.s,
            crossAxisSpacing: FgSpacing.s,
            childAspectRatio: 0.9,
            children: [
              for (final slot in FurnitureSlot.values)
                _SlotTile(
                  slot: slot,
                  itemId: furniture[slot],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// spec-32: Pixel-style room diorama. Wall + floor + each owned item as a
/// big emoji placed at its slot position. Empty slots = no emoji.
/// Spec-43 v2: zusätzlich gekaufte Decor-Items finger-positionierbar.
/// Bug-fix v26: DragTarget-Stage statt manueller RenderBox-Lookup.
class _RoomScene extends ConsumerStatefulWidget {
  const _RoomScene({required this.furniture});

  final Map<FurnitureSlot, String> furniture;

  @override
  ConsumerState<_RoomScene> createState() => _RoomSceneState();
}

class _RoomSceneState extends ConsumerState<_RoomScene> {
  // Pan-Drag-State: welches Item gerade gezogen wird + cumulative offset.
  String? _draggingId;
  Offset _dragOffset = Offset.zero;

  static const Map<FurnitureSlot, (double, double)> _slotDefault = {
    // Normalisiert 0..1 statt Alignment ±1.
    FurnitureSlot.bed: (0.15, 0.7),
    FurnitureSlot.desk: (0.85, 0.5),
    FurnitureSlot.chair: (0.7, 0.75),
    FurnitureSlot.tech: (0.85, 0.25),
    FurnitureSlot.decor: (0.2, 0.2),
    FurnitureSlot.lamp: (0.5, 0.1),
  };

  @override
  Widget build(BuildContext context) {
    final editMode = ref.watch<bool>(roomEditModeProvider);
    final decor = ref
        .watch(decorRepositoryProvider.notifier)
        .forIsland('zimmer');
    final decorRepo = ref.read(decorRepositoryProvider.notifier);
    final furnRepo = ref.read(furnitureRepositoryProvider.notifier);

    return AspectRatio(
      aspectRatio: 2.2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6B5BB6),
                  Color(0xFF6B5BB6),
                  Color(0xFF4A3A85),
                ],
                stops: [0.0, 0.55, 0.55],
              ),
              border: Border.all(
                color: editMode ? FgColors.success : FgColors.outline,
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                // v29: alle gekauften Möbel zeigen (nicht nur slot-active),
                // jeweils per Item-ID positioniert + per Item-ID
                // ein-/ausblendbar.
                for (final itemId in furnRepo.ownedIds)
                  if (furnRepo.isItemVisible(itemId))
                    _buildFurnitureItem(
                      itemId: itemId,
                      w: w,
                      h: h,
                      editMode: editMode,
                      onCommit: (nx, ny) =>
                          furnRepo.setItemPosition(itemId, nx, ny),
                    ),
                // Decor frei.
                for (final p in decor)
                  _buildDecor(
                    id: 'decor-${p.rowId}',
                    x: p.x,
                    y: p.y,
                    glyph: decorSpecById(p.decorId)?.glyph ?? '?',
                    w: w,
                    h: h,
                    editMode: editMode,
                    onCommit: (nx, ny) =>
                        decorRepo.update(p.copyWith(x: nx, y: ny)),
                  ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(FgSpacing.xs),
                    child: Text(
                      editMode
                          ? '✏ Verschiebe-Modus · Tippe + ziehe Möbel/Deko'
                          : 'Dein Zimmer',
                      style: FgTypography.bodyS.copyWith(
                        color: editMode
                            ? FgColors.success
                            : FgColors.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFurnitureItem({
    required String itemId,
    required double w,
    required double h,
    required bool editMode,
    required void Function(double, double) onCommit,
  }) {
    final furnRepo = ref.read(furnitureRepositoryProvider.notifier);
    final item = FurnitureCatalog.byId(itemId);
    final saved = furnRepo.positionForItem(itemId);
    // Default-Position: Slot-Default + Jitter pro Item-Hash (vermeidet
    // Stapelung bei mehreren Items im selben Slot).
    final base = _slotDefault[item.slot] ?? (0.5, 0.5);
    final jitter = (itemId.hashCode % 13) / 100.0 - 0.06; // ±0.06
    final (x, y) = saved ?? (base.$1 + jitter, base.$2 + jitter);
    return _draggableItem(
      id: 'furn-$itemId',
      x: x.clamp(0.05, 0.95),
      y: y.clamp(0.05, 0.95),
      glyph: item.emoji,
      fontSize: 44,
      w: w,
      h: h,
      editMode: editMode,
      onCommit: onCommit,
      assetPath: item.assetPath,
    );
  }

  Widget _buildDecor({
    required String id,
    required double x,
    required double y,
    required String glyph,
    required double w,
    required double h,
    required bool editMode,
    required void Function(double, double) onCommit,
  }) {
    return _draggableItem(
      id: id,
      x: x,
      y: y,
      glyph: glyph,
      fontSize: 40,
      w: w,
      h: h,
      editMode: editMode,
      onCommit: onCommit,
    );
  }

  Widget _draggableItem({
    required String id,
    required double x,
    required double y,
    required String glyph,
    required double fontSize,
    required double w,
    required double h,
    required bool editMode,
    required void Function(double, double) onCommit,
    String? assetPath,
  }) {
    final isDragging = _draggingId == id;
    final dx = isDragging ? _dragOffset.dx : 0.0;
    final dy = isDragging ? _dragOffset.dy : 0.0;
    const half = 32.0;
    final left = (x * w - half + dx).clamp(0.0, w - 2 * half);
    final top = (y * h - half + dy).clamp(0.0, h - 2 * half);

    Widget child = SizedBox(
      width: 64,
      height: 64,
      child: Center(
        child: assetPath != null
            ? Image.asset(
                assetPath,
                width: fontSize + 8,
                height: fontSize + 8,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    Text(glyph, style: TextStyle(fontSize: fontSize)),
              )
            : Text(glyph, style: TextStyle(fontSize: fontSize)),
      ),
    );
    if (editMode) {
      child = Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          border: Border.all(
            color: isDragging ? FgColors.success : FgColors.primary,
            width: 2,
          ),
        ),
        child: child,
      );
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) {
          setState(() {
            _draggingId = id;
            _dragOffset = Offset.zero;
          });
        },
        onPanUpdate: (d) {
          setState(() => _dragOffset += d.delta);
        },
        onPanEnd: (_) {
          final newX = ((x * w) + _dragOffset.dx).clamp(0.0, w) / w;
          final newY = ((y * h) + _dragOffset.dy).clamp(0.0, h) / h;
          onCommit(newX, newY);
          setState(() {
            _draggingId = null;
            _dragOffset = Offset.zero;
          });
        },
        child: child,
      );
    }
    return Positioned(left: left, top: top, child: child);
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({required this.slot, required this.itemId});

  final FurnitureSlot slot;
  final String? itemId;

  @override
  Widget build(BuildContext context) {
    final item = itemId == null ? null : FurnitureCatalog.byId(itemId!);
    return Container(
      padding: const EdgeInsets.all(FgSpacing.xs),
      decoration: BoxDecoration(
        color: item == null
            ? FgColors.backgroundDeep
            : FgColors.backgroundPrimary,
        border: Border.all(
          color: item == null ? FgColors.neutral : FgColors.primary,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          item != null
              ? FurnitureSprite(item: item, size: 36)
              : const Text('➕', style: TextStyle(fontSize: 30)),
          const SizedBox(height: FgSpacing.xs),
          Text(
            item?.name ?? FurnitureCatalog.labelForSlot(slot),
            style: FgTypography.bodyS,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _AvatarBlock extends ConsumerWidget {
  const _AvatarBlock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // spec-34: avatar emoji + player name from onboarding.
    final s = ref.watch(settingsRepositoryProvider);
    return GestureDetector(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => const AvatarShopPage(),
        ),
      ),
      child: Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: Column(
        children: [
          Text(s.avatarEmoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: FgSpacing.s),
          Text(s.playerName, style: FgTypography.bodyL),
          const Text(
            '(Tippen → Avatar-Shop)',
            style: FgTypography.bodyS,
          ),
        ],
      ),
      ),
    );
  }

  // Spec-41: alter Avatar-Picker entfernt — Tap → AvatarShopPage.
}

class _TrophyGrid extends StatelessWidget {
  const _TrophyGrid({required this.unlocked});

  final Set<String> unlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trophäen-Wand',
            style: FgTypography.display.copyWith(fontSize: 20),
          ),
          const SizedBox(height: FgSpacing.s),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: FgSpacing.s,
            crossAxisSpacing: FgSpacing.s,
            childAspectRatio: 0.9,
            children: [
              for (final a in kAchievements)
                _TrophyTile(
                  achievement: a,
                  unlocked: unlocked.contains(a.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrophyTile extends StatelessWidget {
  const _TrophyTile({required this.achievement, required this.unlocked});

  final Achievement achievement;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final color = unlocked ? FgColors.primary : FgColors.neutral;
    // Barrierefreiheit: Button-Rolle + Label mit Freischalt-Status, damit
    // TalkBack nicht nur das Emoji vorliest. Inhalt aus Semantik ausschließen.
    return Semantics(
      button: true,
      label: '${achievement.label}, '
          '${unlocked ? 'freigeschaltet' : 'noch gesperrt'}',
      child: ExcludeSemantics(
        child: GestureDetector(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) =>
              AchievementDetailPage(achievement: achievement),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(FgSpacing.xs),
        decoration: BoxDecoration(
          color: unlocked
              ? FgColors.backgroundPrimary
              : FgColors.backgroundDeep,
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welle-8 Round 23: Geist-Teaser — Locked-Achievements
            // zeigen das echte Emoji halbtransparent statt 🔒. Kid
            // sieht was kommt, motivierender. Lock-Icon als Overlay.
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: unlocked ? 1.0 : 0.25,
                  child: Text(
                    achievement.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                if (!unlocked)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text('🔒', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: FgSpacing.xs),
            Text(
              achievement.label,
              style: FgTypography.bodyS.copyWith(color: color),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

class _OwnedItemsSection extends StatelessWidget {
  const _OwnedItemsSection({required this.items});

  final List<WishItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FgSpacing.l),
      decoration: BoxDecoration(
        color: FgColors.backgroundElevated,
        border: Border.all(color: FgColors.outline, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Erspielte Wunschartikel',
            style: FgTypography.display.copyWith(fontSize: 20),
          ),
          const SizedBox(height: FgSpacing.s),
          if (items.isEmpty)
            const Text(
              'Noch nichts gekauft.',
              style: FgTypography.bodyS,
            )
          else
            for (final i in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: FgSpacing.xs),
                child: Row(
                  children: [
                    Text(i.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: FgSpacing.s),
                    Expanded(child: Text(i.name, style: FgTypography.bodyM)),
                    Text(
                      'Tag ${(i.ownedOnDayIndex ?? 0) + 1}',
                      style: FgTypography.bodyS,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
