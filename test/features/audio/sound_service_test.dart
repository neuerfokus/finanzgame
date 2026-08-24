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

    test('startMusic / stopMusic toggle', () async {
      final rec = RecordingSoundService();
      SoundService.use(rec);
      await SoundService.instance.startMusic();
      expect(rec.musicStarted, isTrue);
      await SoundService.instance.stopMusic();
      expect(rec.musicStarted, isFalse);
    });

    test('default instance is silent (no throw)', () async {
      // Reset → _NoopSoundService.
      SoundService.reset();
      // Must not throw.
      await SoundService.instance.playSfx(AudioKey.coin);
      await SoundService.instance.startMusic();
      await SoundService.instance.stopMusic();
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

    test('setMusicVolume clamps below 0 to 0 (spec-23)', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);
      SoundService.instance.setMusicVolume(-0.5);
      expect(rec.musicVolume, 0.0);
    });

    test('setMusicVolume clamps above 1 to 1 (spec-23)', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);
      SoundService.instance.setMusicVolume(1.75);
      expect(rec.musicVolume, 1.0);
    });

    test('setMusicVolume passes through valid range', () {
      final rec = RecordingSoundService();
      SoundService.use(rec);
      SoundService.instance.setMusicVolume(0.3);
      expect(rec.musicVolume, closeTo(0.3, 1e-9));
    });
  });
}
