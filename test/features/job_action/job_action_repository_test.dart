import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finanzgame/features/job_action/job_action_repository.dart';

/// Spec-45 C5 + v35: Job-Wechsel (Cooldown-Gate + Titel-Rotation) +
/// Sabbatical + Reset.
void main() {
  test('initial state: keine Pause, kein Bonus, sofort wechselbar', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final state = container.read(jobActionRepositoryProvider);
    expect(state.careerBonusPct, 0);
    expect(state.pauseUntilDay, -1);
    expect(state.jobVariantIndex, 0);
    expect(state.isPaused(0), isFalse);
    expect(state.canSwitch(0), isTrue);
  });

  test('switchJob: +5 % Bonus, 30 Tage Pause, neue Titel-Variante', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final n = container.read(jobActionRepositoryProvider.notifier);
    expect(n.switchJob(100), isTrue);
    final s = container.read(jobActionRepositoryProvider);
    expect(s.careerBonusPct, 5);
    expect(s.pauseUntilDay, 130);
    expect(s.jobVariantIndex, 1);
    expect(s.isPaused(100), isTrue);
    expect(s.isPaused(129), isTrue);
    expect(s.isPaused(130), isFalse);
  });

  test('Cooldown: zweiter Wechsel direkt danach blockiert (Anti-Glitch)', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final n = container.read(jobActionRepositoryProvider.notifier);
    expect(n.switchJob(100), isTrue);
    // Sofort danach gesperrt — 3-5 Jahre Cooldown.
    expect(n.switchJob(130), isFalse);
    final s = container.read(jobActionRepositoryProvider);
    expect(s.careerBonusPct, 5); // KEIN zweiter +5 → kein Farming
    expect(s.jobVariantIndex, 1);
    expect(s.canSwitch(130), isFalse);
    expect(s.daysUntilSwitch(130), greaterThanOrEqualTo(kMinSwitchCooldownDays - 30));
  });

  test('Cooldown liegt im 3-5-Jahre-Fenster', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final n = container.read(jobActionRepositoryProvider.notifier)
      ..rng = Random(42);
    n.switchJob(0);
    final next = container.read(jobActionRepositoryProvider).nextSwitchAllowedDay;
    expect(next, greaterThanOrEqualTo(kMinSwitchCooldownDays));
    expect(next, lessThanOrEqualTo(kMaxSwitchCooldownDays));
  });

  test('switchJob stackt bis +50 % cap (über die Jahre)', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final n = container.read(jobActionRepositoryProvider.notifier)
      ..rng = Random(7);
    var day = 0;
    for (var i = 0; i < 20; i++) {
      expect(n.switchJob(day), isTrue);
      // Genau bis zum frühestmöglichen nächsten Wechsel vorspulen.
      day = container.read(jobActionRepositoryProvider).nextSwitchAllowedDay;
    }
    expect(container.read(jobActionRepositoryProvider).careerBonusPct, 50);
  });

  test('takeSabbatical: 90 Tage Pause, Bonus + Cooldown bleiben', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final n = container.read(jobActionRepositoryProvider.notifier);
    n.switchJob(0); // +5 % Bonus + Cooldown
    final cooldown =
        container.read(jobActionRepositoryProvider).nextSwitchAllowedDay;
    n.takeSabbatical(50);
    final s = container.read(jobActionRepositoryProvider);
    expect(s.careerBonusPct, 5);
    expect(s.pauseUntilDay, 140);
    expect(s.nextSwitchAllowedDay, cooldown); // Cooldown unangetastet
  });

  test('reset löscht Bonus + Pause + Cooldown + Titel', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final n = container.read(jobActionRepositoryProvider.notifier);
    n.switchJob(0);
    n.reset();
    final s = container.read(jobActionRepositoryProvider);
    expect(s.careerBonusPct, 0);
    expect(s.pauseUntilDay, -1);
    expect(s.nextSwitchAllowedDay, -1);
    expect(s.jobVariantIndex, 0);
  });
}
