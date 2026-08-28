import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Identifiers for every SFX + music asset the app plays.
enum AudioKey {
  coin('sfx/coin.ogg', volume: 0.6),
  harvest('sfx/harvest.ogg', volume: 0.7),
  sleep('sfx/sleep_chime.ogg', volume: 0.5),
  crash('sfx/crash_rumble.ogg', volume: 0.9),
  uiTap('sfx/ui_tap.ogg', volume: 0.3),
  musicLoop('music/monetaria_loop.ogg', volume: 0.25);

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
  Future<void> startMusic();
  Future<void> stopMusic();

  /// Spec-23: set background-music volume in the range 0.0..1.0.
  /// Values outside the range MUST be clamped by the implementation.
  /// Effect is immediate if music is currently playing; otherwise the
  /// volume is remembered for the next [startMusic] call.
  void setMusicVolume(double v);

  /// Spec-27: master volume multiplier (0..1). Applied to both music and
  /// SFX on top of their per-category volume. Stored, not played live.
  void setMasterVolume(double v);

  /// Spec-27: SFX-category volume multiplier (0..1). Applied to
  /// [AudioKey.volume] on each [playSfx]. Music is not affected.
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

  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _muted = false;

  /// Cached volume (0..1). Default matches [AudioKey.musicLoop.volume];
  /// gets overwritten by [setMusicVolume] and read by [startMusic].
  double _musicVolume = AudioKey.musicLoop.volume;

  /// spec-27: master + sfx multipliers.
  double _masterVolume = 0.6;
  double _sfxVolume = 0.4;

  /// spec-27: throttle map — last play timestamp per key in ms-since-epoch.
  /// Prevents the same SFX firing twice within ~80 ms (tab-spam taps).
  final Map<AudioKey, int> _lastPlayMs = {};
  static const int _sfxThrottleMs = 80;

  @override
  bool get muted => _muted;

  @override
  set muted(bool value) {
    _muted = value;
    if (value) {
      _musicPlayer.stop();
    }
  }

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
          (key.volume * _sfxVolume * _masterVolume).clamp(0.0, 1.0);
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
  Future<void> startMusic() async {
    if (_muted) return;
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_effectiveMusicVolume);
      await _musicPlayer.play(AssetSource(AudioKey.musicLoop.assetPath));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SoundService.startMusic failed: $e');
      }
    }
  }

  @override
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (_) {}
  }

  @override
  void setMusicVolume(double v) {
    _musicVolume = v.clamp(0.0, 1.0);
    _musicPlayer.setVolume(_effectiveMusicVolume).catchError((Object _) {});
  }

  @override
  void setMasterVolume(double v) {
    _masterVolume = v.clamp(0.0, 1.0);
    _musicPlayer.setVolume(_effectiveMusicVolume).catchError((Object _) {});
  }

  @override
  void setSfxVolume(double v) {
    _sfxVolume = v.clamp(0.0, 1.0);
  }

  double get _effectiveMusicVolume =>
      (_musicVolume * _masterVolume).clamp(0.0, 1.0);
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
  Future<void> startMusic() async {}
  @override
  Future<void> stopMusic() async {}
  @override
  void setMusicVolume(double v) {}
  @override
  void setMasterVolume(double v) {}
  @override
  void setSfxVolume(double v) {}
}

/// Recording impl for tests. Stores every key the code asked to play.
///
/// Honours [muted] like the production backend: muted instances neither
/// record SFX nor flip [musicStarted].
class RecordingSoundService implements SoundService {
  final List<AudioKey> played = [];
  bool musicStarted = false;
  @override
  bool muted = false;

  /// Spec-23: last value passed to [setMusicVolume], post-clamp to 0..1.
  /// Null until set — lets tests distinguish "never called" from "set to 0".
  double? musicVolume;

  @override
  Future<void> playSfx(AudioKey key) async {
    if (muted) return;
    played.add(key);
  }

  @override
  Future<void> startMusic() async {
    if (muted) return;
    musicStarted = true;
  }

  @override
  Future<void> stopMusic() async => musicStarted = false;

  @override
  void setMusicVolume(double v) {
    musicVolume = v.clamp(0.0, 1.0);
  }

  /// spec-27: last value passed to [setMasterVolume].
  double? masterVolume;
  /// spec-27: last value passed to [setSfxVolume].
  double? sfxVolume;

  @override
  void setMasterVolume(double v) {
    masterVolume = v.clamp(0.0, 1.0);
  }

  @override
  void setSfxVolume(double v) {
    sfxVolume = v.clamp(0.0, 1.0);
  }
}
