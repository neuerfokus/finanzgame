import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/sim/listeners/market_phase_listener.dart';
import 'news_pool.dart';

/// spec-35 phase O: rotating news-ticker pill for the Springboard.
/// Rotates every 6 seconds via Timer.periodic with a fade-cross-transition.
class NewsTicker extends ConsumerStatefulWidget {
  const NewsTicker({super.key});

  @override
  ConsumerState<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends ConsumerState<NewsTicker> {
  int _idx = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _idx = DateTime.now().millisecondsSinceEpoch % NewsPool.items.length;
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() => _idx = (_idx + 1) % NewsPool.items.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final warnCrash = MarketPhaseListener.willCrashWithin(dayIndex);
    final text = warnCrash
        ? '⚠ Analysten warnen vor Unruhe an den Märkten — möglicherweise Crash voraus.'
        : NewsPool.items[_idx];
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: FgSpacing.l,
        vertical: FgSpacing.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: FgSpacing.m,
        vertical: FgSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: warnCrash
            ? FgColors.alert.withValues(alpha: 0.25)
            : FgColors.backgroundDeep,
        border: Border.all(
          color: warnCrash ? FgColors.alert : FgColors.secondary,
          width: warnCrash ? 2 : 1,
        ),
        borderRadius:
            const BorderRadius.all(Radius.circular(FgRadius.tight)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Text(
          text,
          key: ValueKey<String>(text),
          style: FgTypography.bodyS.copyWith(
            color: warnCrash ? FgColors.alert : null,
            fontWeight: warnCrash ? FontWeight.bold : null,
          ),
          softWrap: true,
        ),
      ),
    );
  }
}
