import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Identifiers for every sound effect the app plays.
///
/// Musik gibt es seit spec-37 nicht mehr (Test-Feedback: nervig); Build 196
/// hat die tote Musik-Schleife samt Datei und Master-Regler entfernt.
enum AudioKey {
  coin('sfx/coin.ogg', volume: 0.6),
  harvest('sfx/harvest.ogg', volume: 0.7),
  sleep('sfx/sleep_chime.ogg', volume: 0.5),
  crash('sfx/crash_rumble.ogg', volume: 0.9),
  uiTap('sfx/ui_tap.ogg', volume: 0.3);

  const AudioKey(this.assetPath, {required this.volume});
  final String assetPath;
  final double volume;
}

/// App-wide audio entry point. Static singleton so widgets + repositories
/// can play sounds without wiring a provider through. Tests swap in a
/// silent / recording impl via [SoundService.use].
///
/// **Asset robustness:** if a file is missing on disk, audioplayers raises
/// silently in the catch — the call site never crashes.
abstract class SoundService {
  static SoundService _instance = const _NoopSoundService();

  static SoundService get instance => _instance;

  /// Swap implementation (tests, mute toggle).
  static void use(SoundService impl) => _instance = impl;

  /// Restore the default no-op (used in tests after explicit setup).
  static void reset() => _instance = const _NoopSoundService();

  bool get muted;
  set muted(bool value);

  Future<void> playSfx(AudioKey key);

  /// Lautstärke der Effekte (0..1), multipliziert mit [AudioKey.volume].
  /// Werte außerhalb MUSS die Implementierung begrenzen.
  void setSfxVolume(double v);
}

/// Production audio backend. Created lazily by [AudioplayersSoundService]
/// so unit tests that never call `use(...)` don't load native plugins.
class AudioplayersSoundService implements SoundService {
  AudioplayersSoundService() {
    AudioPlayer.global.setAudioContext(_mediaContext);
  }

  static final AudioContext _mediaContext = AudioContext(
    android: const AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
    ),
    // ignore: prefer_const_constructors -- AudioContextIOS isn't const.
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: const {AVAudioSessionOptions.mixWithOthers},
    ),
  );

  bool _muted = false;

  /// Standard = alter Stand Master 60 % × Effekt 40 %.
  double _sfxVolume = 0.24;

  /// spec-27: throttle map — last play timestamp per key in ms-since-epoch.
  /// Prevents the same SFX firing twice within ~80 ms (tab-spam taps).
  final Map<AudioKey, int> _lastPlayMs = {};
  static const int _sfxThrottleMs = 80;

  @override
  bool get muted => _muted;

  @override
  set muted(bool value) => _muted = value;

  @override
  Future<void> playSfx(AudioKey key) async {
    if (_muted) return;
    // spec-27: throttle. Skip if same key fired very recently.
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _lastPlayMs[key];
    if (last != null && now - last < _sfxThrottleMs) return;
    _lastPlayMs[key] = now;
    try {
      // Wiederverwendeter Pool statt „pro Klang ein neuer Player".
      //
      // Vorher entstand hier bei JEDEM Effekt ein `AudioPlayer`, der nie
      // `dispose()` bekam. `ReleaseMode.release` gibt zwar den nativen
      // MediaPlayer nach dem Abspielen frei, die Registrierung im Plugin und
      // die beiden Dart-Subscriptions bleiben aber bis zum Entsorgen — ein
      // Leck, das mit jeder eingesammelten Münze wächst. Ein Zeitsprung über
      // fünf Jahre allein erzeugte so mehrere hundert Instanzen.
      final player = _sfxPool[_sfxSlot];
      _sfxSlot = (_sfxSlot + 1) % _sfxPool.length;
      final effective =
          (key.volume * _sfxVolume).clamp(0.0, 1.0);
      await player.setVolume(effective);
      await player.play(AssetSource(key.assetPath));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SoundService.playSfx(${key.name}) failed: $e');
      }
    }
  }

  /// Reihum genutzte Abspieler. Vier reichen: der Drossel-Abstand von
  /// [_sfxThrottleMs] pro Klang ist kürzer als ein Effekt dauert, mehrere
  /// dürfen sich also überlappen — aber nie mehr als eine Handvoll.
  static const int _sfxPoolSize = 4;
  final List<AudioPlayer> _sfxPool =
      List.generate(_sfxPoolSize, (_) => AudioPlayer());
  int _sfxSlot = 0;

  @override
  void setSfxVolume(double v) {
    _sfxVolume = v.clamp(0.0, 1.0);
  }
}

/// Default impl used in tests + before assets land. All methods are no-ops.
class _NoopSoundService implements SoundService {
  const _NoopSoundService();
  @override
  bool get muted => true;
  @override
  set muted(bool value) {}
  @override
  Future<void> playSfx(AudioKey key) async {}
  @override
  void setSfxVolume(double v) {}
}

/// Recording impl for tests. Stores every key the code asked to play.
///
/// Honours [muted] like the production backend: muted instances don't
/// record SFX.
class RecordingSoundService implements SoundService {
  final List<AudioKey> played = [];
  @override
  bool muted = false;

  /// Letzter an [setSfxVolume] übergebener Wert, begrenzt auf 0..1.
  double? sfxVolume;

  @override
  Future<void> playSfx(AudioKey key) async {
    if (muted) return;
    played.add(key);
  }

  @override
  void setSfxVolume(double v) {
    sfxVolume = v.clamp(0.0, 1.0);
  }
}
