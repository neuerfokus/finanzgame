import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../features/xp/xp_repository.dart';

/// Header showing cash, savings, XP with animated +N coin-popup on cash gain.
///
/// Spec-21: XP is now sourced from [xpRepositoryProvider] — callers no
/// longer pass it in. Savings still passed in until [SavingsRepository]
/// integration is wired across all callers.
class MoneyHeader extends ConsumerStatefulWidget {
  const MoneyHeader({
    required this.cash,
    required this.savings,
    super.key,
  });

  final Money cash;
  final Money savings;

  @override
  ConsumerState<MoneyHeader> createState() => _MoneyHeaderState();
}

class _MoneyHeaderState extends ConsumerState<MoneyHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _popupController;
  Money? _animatingDelta;

  @override
  void initState() {
    super.initState();
    _popupController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(MoneyHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.cash > oldWidget.cash) {
      final delta = widget.cash - oldWidget.cash;
      if (_popupController.isAnimating) {
        _animatingDelta = (_animatingDelta ?? Money.zero) + delta;
      } else {
        _animatingDelta = delta;
      }
      _popupController.forward(from: 0.0);
    } else if (widget.cash < oldWidget.cash) {
      _popupController.reset();
      _animatingDelta = null;
    } else if (widget.cash.cents != oldWidget.cash.cents) {
      _animatingDelta = null;
      _popupController.reset();
    }
  }

  @override
  void dispose() {
    _popupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final xp = ref.watch(xpRepositoryProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: FgSpacing.l,
        vertical: FgSpacing.m,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  widget.cash.formatEur(),
                  key: ValueKey(widget.cash.cents),
                  style: FgTypography.display.copyWith(fontSize: 28),
                ),
              ),
              const SizedBox(height: FgSpacing.xs),
              Text(
                'Sparen ${widget.savings.formatEur()}  ·  ⚡ $xp XP',
                style: FgTypography.bodyS,
              ),
            ],
          ),
          if (_animatingDelta != null)
            ListenableBuilder(
              listenable: _popupController,
              builder: (context, child) {
                final progress = _popupController.value;
                return Positioned(
                  right: FgSpacing.l,
                  top: FgSpacing.m + 10 - (50 * progress),
                  child: Opacity(opacity: 1.0 - progress, child: child),
                );
              },
              child: Text(
                '+${_animatingDelta!.formatEur()}',
                style: FgTypography.display.copyWith(
                  fontSize: 18,
                  color: FgColors.success,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
