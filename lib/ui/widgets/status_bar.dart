import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../core/game_clock.dart';
import '../../domain/plant/plant.dart' show seasonForDayIndex;
import '../../features/settings/settings_repository.dart';

/// 8-bit-style status bar shown at top of [PhoneFrame].
///
/// Spec-43 v4: zeigt Tag · Jahr · Alter · Saison in einer Zeile.
class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayIndex = ref.watch(gameClockProvider).dayIndex;
    final settings = ref.watch(settingsRepositoryProvider);
    final years = dayIndex ~/ 365;
    final ageYears = settings.startAgeYears + years;
    final season = seasonForDayIndex(dayIndex);
    return Container(
      width: double.infinity,
      color: FgColors.backgroundDeep,
      padding: const EdgeInsets.symmetric(
        horizontal: FgSpacing.m,
        vertical: FgSpacing.xs,
      ),
      child: DefaultTextStyle.merge(
        style: FgTypography.pixelLabel.copyWith(color: FgColors.primary),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tag ${dayIndex + 1}  ·  Jahr $years  ·  Alter $ageYears'
            '  ·  ${season.label}',
          ),
        ),
      ),
    );
  }
}
