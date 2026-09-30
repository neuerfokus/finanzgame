import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finanzgame/domain/economy/money.dart';
import 'package:finanzgame/features/audio/sound_service.dart';
import 'package:finanzgame/features/economy/cash_state.dart';

void main() {
  tearDown(SoundService.reset);

  group('SoundService', () {
    test('RecordingSoundService captures playSfx calls', () async {
      final rec = RecordingSoundService();
      SoundService.use(rec);

      await SoundService.instance.playSfx(AudioKey.coin);
      await SoundService.instance.playSfx(AudioKey.crash);

      expect(rec.played, [AudioKey.coin, AudioKey.crash]);
    });

    test('default instance is silent (no throw)', () async {
      // Reset → _NoopSoundService.
      SoundService.reset();
      // Must not throw.
      await SoundService.instance.playSfx(AudioKey.coin);
    });

    test('CashState.earn triggers coin sound', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);

      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(const Money.cents(100));

      expect(rec.played, [AudioKey.coin]);
    });

    test('CashState.earn(0) does not trigger sound', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);

      final c = ProviderContainer();
      addTearDown(c.dispose);
      c.read(cashStateProvider.notifier).earn(Money.zero);

      expect(rec.played, isEmpty);
    });

    test('setSfxVolume begrenzt auf 0..1', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);
      SoundService.instance.setSfxVolume(-0.5);
      expect(rec.sfxVolume, 0.0);
      SoundService.instance.setSfxVolume(1.75);
      expect(rec.sfxVolume, 1.0);
      SoundService.instance.setSfxVolume(0.3);
      expect(rec.sfxVolume, closeTo(0.3, 1e-9));
    });

    test('es gibt keine Musik mehr (spec-37, Build 196)', () {
      expect(
        AudioKey.values.where((k) => k.assetPath.startsWith('music/')),
        isEmpty,
      );
    });
  });
}
