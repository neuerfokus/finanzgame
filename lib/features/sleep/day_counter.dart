import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';

/// Small HUD widget that shows the current game day.
///
/// Reads [gameClockProvider] and renders `"Tag N"` inside a bordered container.
class DayCounter extends ConsumerWidget {
  const DayCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(gameClockProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FgSpacing.s,
        vertical: FgSpacing.xs,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: FgColors.primary),
        borderRadius: BorderRadius.circular(FgRadius.tight),
        color: FgColors.backgroundElevated,
      ),
      child: Text(
        'Tag ${day.dayIndex + 1}',
        style: FgTypography.pixelLabel,
      ),
    );
  }
}
