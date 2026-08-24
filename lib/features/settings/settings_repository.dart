import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/db/app_database_provider.dart';
import '../../domain/age/age_state.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/weekday.dart';
import '../audio/sound_service.dart';
import '../skills/skill_tree_data.dart';
import '../xp/level_titles.dart';
import '../xp/xp_repository.dart';

part 'settings_repository.g.dart';

/// SHA-256 des Eltern-PINs (mit fester Domain-Vorsilbe). 64 Hex-Zeichen —
/// daran erkennt [SettingsRepository.parentPinMatches] auch, ob in einem
/// Alt-Save noch Klartext steht.
String hashParentPin(String pin) =>
    sha256.convert(utf8.encode('fg-pin:$pin')).toString();

/// Immutable user-settings state. Lives in memory + persists to
/// [SettingsTable] (singleton row, PK=0). Defaults match the Drift column
/// defaults so tests without overrides keep the prior hard-coded behaviour.
class GameSettings {
  const GameSettings({
    required this.allowance,
    required this.allowanceWeekday,
    required this.playerName,
    required this.soundEnabled,
    required this.lastQuizDayIndex,
    required this.zeitreiseTutorialSeen,
    required this.musicVolume,
    required this.masterVolume,
    required this.sfxVolume,
    required this.lastSleepEpochMs,
    required this.sleepCountInWindow,
    required this.onboardingComplete,
    required this.avatarEmoji,
    this.startAgeYears = 13,
    this.streakCount = 0,
    this.lastSleepDateIso = '',
    this.unlockedAvatarsCsv = '',
    this.unlockedDecorCsv = '',
    this.sparPlotCount = 4,
    this.savingsRatePct = 0,
    this.lastClaimedGoalDay = -1,
    this.quizLearnedTopicsCsv = '',
    this.seenCoachesCsv = '',
    this.lastWeekNetWorthCents = 0,
    this.lastWeeklyReviewDay = -1,
    this.recentQuizTextsCsv = '',
    this.parentPin = '',
    this.unlockedSkillsCsv = '',
    this.weeklyChallengeClaimedWeek = -1,
    this.weeklyChallengeStreak = 0,
    this.claimedStreakMilestone = 0,
    this.autoSaveDisabled = false,
    this.backupFolderUri,
    this.birthYear,
    this.birthYearAsked = false,
    this.parentGateLockedUntilMs = 0,
  });

  /// Default settings — used when no DB row exists yet.
  const GameSettings.defaults()
      : allowance = const Money.cents(8000),
        allowanceWeekday = Weekday.mon,
        playerName = 'Spieler',
        soundEnabled = true,
        lastQuizDayIndex = -1,
        zeitreiseTutorialSeen = false,
        musicVolume = 0,
        masterVolume = 60,
        sfxVolume = 40,
        lastSleepEpochMs = 0,
        sleepCountInWindow = 0,
        onboardingComplete = false,
        avatarEmoji = '🧒',
        startAgeYears = 13,
        streakCount = 0,
        lastSleepDateIso = '',
        unlockedAvatarsCsv = '',
        unlockedDecorCsv = '',
        sparPlotCount = 4,
        savingsRatePct = 0,
        lastClaimedGoalDay = -1,
        quizLearnedTopicsCsv = '',
        seenCoachesCsv = '',
        lastWeekNetWorthCents = 0,
        lastWeeklyReviewDay = -1,
        recentQuizTextsCsv = '',
        parentPin = '',
        unlockedSkillsCsv = '',
        weeklyChallengeClaimedWeek = -1,
        weeklyChallengeStreak = 0,
        claimedStreakMilestone = 0,
        autoSaveDisabled = false,
        backupFolderUri = null,
        birthYear = null,
        birthYearAsked = false,
        parentGateLockedUntilMs = 0;

  final Money allowance;
  final Weekday allowanceWeekday;
  final String playerName;
  final bool soundEnabled;

  /// Spec-17: last GameClock day on which the daily quiz overlay fired.
  /// -1 = never shown.
  final int lastQuizDayIndex;

  /// Spec-19: whether the Zeitreise tutorial overlay was already dismissed.
  final bool zeitreiseTutorialSeen;

  /// Spec-23: music volume in percent (0..100). 0 = silent, 100 = max.
  final int musicVolume;

  /// Spec-27: master volume multiplier in percent (0..100).
  final int masterVolume;

  /// Spec-27: SFX-category volume multiplier in percent (0..100).
  final int sfxVolume;

  /// Spec-33: anti-glitch sleep state.
  final int lastSleepEpochMs;
  final int sleepCountInWindow;

  /// Spec-34: onboarding done + chosen avatar emoji.
  final bool onboardingComplete;
  final String avatarEmoji;

  /// Spec-38 follow-up: Start-Alter des Spielers (abgefragt im Onboarding).
  /// Default 13. Anzeige im Header: `startAgeYears + dayIndex ~/ 365`.
  /// Drift v21: in SettingsTable persistiert (war vorher in-memory-only
  /// und fiel bei jedem App-Neustart auf 13 zurück).
  final int startAgeYears;

  /// Spec-40 C: konsekutive Real-Tage mit Schlaf-Aktion.
  final int streakCount;

  /// Letztes Schlaf-Real-Datum als ISO YYYY-MM-DD. '' = noch nie.
  final String lastSleepDateIso;

  /// Spec-41 A: freigeschaltete Avatar-Glyphs als komma-separierte Liste.
  final String unlockedAvatarsCsv;

  /// Spec-43 Stage 1: freigeschaltete Decor-Item-IDs als CSV.
  final String unlockedDecorCsv;

  /// Spec-43 follow-up: Anzahl Pflanz-Plots auf der Sparinsel (4..12).
  final int sparPlotCount;

  /// Spec-44 E3 (Pay-yourself-first): Anteil des monatlichen
  /// Taschengelds, der ZUERST aufs Spar geschoben wird (0..100). Rest
  /// bleibt als Wünsch-Geld auf Giro. Default 0 = wie vorher
  /// (alles auf Giro).
  final int savingsRatePct;

  /// B7: Tag an dem Tagesziel zuletzt gecaimt wurde. -1 = noch nie.
  /// Persistent (Drift v24) damit Banner nach App-Restart nicht erneut
  /// claimbar wird.
  final int lastClaimedGoalDay;

  /// Welle-8 Round 14: Quiz-Topics die der Spieler 1× korrekt
  /// beantwortet hat. CSV. Fließt in learnedTopicsProvider ein → Glossar
  /// markiert ✅ auch wenn nur via Quiz gelernt.
  final String quizLearnedTopicsCsv;

  /// Welle-8 Round 15: First-Steps-Coach-IDs (CSV). Pro Screen, einmal
  /// markiert → Overlay erscheint nicht mehr.
  final String seenCoachesCsv;

  /// Welle-8 Round 15: Vermögen vor 7 Spieltagen + letzter Tag mit
  /// Wochen-Review. Für Delta-Anzeige.
  final int lastWeekNetWorthCents;
  final int lastWeeklyReviewDay;

  /// Welle-8 Round 15: Pipe-separierte zuletzt gezeigte Quiz-Frage-Texte
  /// (Anti-Repeat).
  final String recentQuizTextsCsv;

  /// Welle-8 Round 23: Eltern-PIN-Lock. Leer = aus. 4-stellig wenn
  /// gesetzt. Schützt Reset/Import/Auto-Save-Force vor Kind-Wipe.
  final String parentPin;

  /// Round 28: freigeschaltete Skill-Baum-Knoten als CSV (skillId).
  final String unlockedSkillsCsv;

  /// Round 28 v4: Wochen-Herausforderung — zuletzt eingelöste Spielwoche
  /// (`dayIndex ~/ 7`, -1 = keine) + Streak aufeinanderfolgender Wochen.
  final int weeklyChallengeClaimedWeek;
  final int weeklyChallengeStreak;

  /// Optionen-Backlog #2: höchste bereits ausgezahlte Streak-Meilenstein-
  /// Schwelle (7/14/30/100). 0 = keine. Lifetime-Anti-Farm-Guard.
  final int claimedStreakMilestone;

  /// Drift v36: Auto-Sicherung ist standardmäßig AN. `true` = vom Nutzer
  /// manuell ausgeschaltet. Getter [autoSaveEnabled] kapselt die Logik.
  final bool autoSaveDisabled;

  /// Auto-Sicherung aktiv (default true, solange nicht manuell aus).
  bool get autoSaveEnabled => !autoSaveDisabled;

  /// Drift v37: SAF-Tree-URI des gewählten Backup-Ordners. null = keiner
  /// gewählt → writeAutoSave fällt auf den Legacy-Pfad zurück.
  final String? backupFolderUri;

  /// Drift v38: Geburtsjahr der echten Person am Gerät (nur das Jahr, kein
  /// volles Datum). null = keine Angabe. Siehe [AgeState] — steuert, ob der
  /// Unterstützen-Bereich überhaupt existiert.
  final int? birthYear;

  /// Drift v38: ob die Geburtsjahr-Frage schon gestellt wurde. Einmal pro
  /// Installation, danach nie wieder von selbst.
  final bool birthYearAsked;

  /// Drift v38: Sperrzeit der Eltern-Rechenaufgabe (ms seit Epoch).
  final int parentGateLockedUntilMs;

  GameSettings copyWith({
    Money? allowance,
    Weekday? allowanceWeekday,
    String? playerName,
    bool? soundEnabled,
    int? lastQuizDayIndex,
    bool? zeitreiseTutorialSeen,
    int? musicVolume,
    int? masterVolume,
    int? sfxVolume,
    int? lastSleepEpochMs,
    int? sleepCountInWindow,
    bool? onboardingComplete,
    String? avatarEmoji,
    int? startAgeYears,
    int? streakCount,
    String? lastSleepDateIso,
    String? unlockedAvatarsCsv,
    String? unlockedDecorCsv,
    int? sparPlotCount,
    int? savingsRatePct,
    int? lastClaimedGoalDay,
    String? quizLearnedTopicsCsv,
    String? seenCoachesCsv,
    int? lastWeekNetWorthCents,
    int? lastWeeklyReviewDay,
    String? recentQuizTextsCsv,
    String? parentPin,
    String? unlockedSkillsCsv,
    int? weeklyChallengeClaimedWeek,
    int? weeklyChallengeStreak,
    int? claimedStreakMilestone,
    bool? autoSaveDisabled,
    String? backupFolderUri,
    int? birthYear,
    bool? birthYearAsked,
    int? parentGateLockedUntilMs,
  }) {
    return GameSettings(
      allowance: allowance ?? this.allowance,
      allowanceWeekday: allowanceWeekday ?? this.allowanceWeekday,
      playerName: playerName ?? this.playerName,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      lastQuizDayIndex: lastQuizDayIndex ?? this.lastQuizDayIndex,
      zeitreiseTutorialSeen:
          zeitreiseTutorialSeen ?? this.zeitreiseTutorialSeen,
      musicVolume: musicVolume ?? this.musicVolume,
      masterVolume: masterVolume ?? this.masterVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      lastSleepEpochMs: lastSleepEpochMs ?? this.lastSleepEpochMs,
      sleepCountInWindow: sleepCountInWindow ?? this.sleepCountInWindow,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      startAgeYears: startAgeYears ?? this.startAgeYears,
      streakCount: streakCount ?? this.streakCount,
      lastSleepDateIso: lastSleepDateIso ?? this.lastSleepDateIso,
      unlockedAvatarsCsv:
          unlockedAvatarsCsv ?? this.unlockedAvatarsCsv,
      unlockedDecorCsv: unlockedDecorCsv ?? this.unlockedDecorCsv,
      sparPlotCount: sparPlotCount ?? this.sparPlotCount,
      savingsRatePct: savingsRatePct ?? this.savingsRatePct,
      lastClaimedGoalDay:
          lastClaimedGoalDay ?? this.lastClaimedGoalDay,
      quizLearnedTopicsCsv:
          quizLearnedTopicsCsv ?? this.quizLearnedTopicsCsv,
      seenCoachesCsv: seenCoachesCsv ?? this.seenCoachesCsv,
      lastWeekNetWorthCents:
          lastWeekNetWorthCents ?? this.lastWeekNetWorthCents,
      lastWeeklyReviewDay:
          lastWeeklyReviewDay ?? this.lastWeeklyReviewDay,
      recentQuizTextsCsv:
          recentQuizTextsCsv ?? this.recentQuizTextsCsv,
      parentPin: parentPin ?? this.parentPin,
      unlockedSkillsCsv: unlockedSkillsCsv ?? this.unlockedSkillsCsv,
      weeklyChallengeClaimedWeek:
          weeklyChallengeClaimedWeek ?? this.weeklyChallengeClaimedWeek,
      weeklyChallengeStreak:
          weeklyChallengeStreak ?? this.weeklyChallengeStreak,
      claimedStreakMilestone:
          claimedStreakMilestone ?? this.claimedStreakMilestone,
      autoSaveDisabled: autoSaveDisabled ?? this.autoSaveDisabled,
      backupFolderUri: backupFolderUri ?? this.backupFolderUri,
      birthYear: birthYear ?? this.birthYear,
      birthYearAsked: birthYearAsked ?? this.birthYearAsked,
      parentGateLockedUntilMs:
          parentGateLockedUntilMs ?? this.parentGateLockedUntilMs,
    );
  }
}

/// Parses the stored weekday tag (`'mon'`..`'sun'`) into a [Weekday].
/// Falls back to [Weekday.mon] for malformed values.
Weekday parseWeekdayTag(String tag) {
  for (final w in Weekday.values) {
    if (w.name == tag) return w;
  }
  return Weekday.mon;
}

@Riverpod(keepAlive: true)
class SettingsRepository extends _$SettingsRepository {
  @override
  GameSettings build() {
    final snap = ref.watch(dbSnapshotProvider).settings;
    final s = GameSettings(
      allowance: Money.cents(snap.allowanceCents),
      allowanceWeekday: parseWeekdayTag(snap.allowanceWeekday),
      playerName: snap.playerName,
      soundEnabled: snap.soundEnabled,
      lastQuizDayIndex: snap.lastQuizDayIndex,
      zeitreiseTutorialSeen: snap.zeitreiseTutorialSeen,
      musicVolume: snap.musicVolume,
      masterVolume: snap.masterVolume,
      sfxVolume: snap.sfxVolume,
      lastSleepEpochMs: snap.lastSleepEpochMs,
      sleepCountInWindow: snap.sleepCountInWindow,
      onboardingComplete: snap.onboardingComplete,
      avatarEmoji: snap.avatarEmoji,
      streakCount: snap.streakCount,
      lastSleepDateIso: snap.lastSleepDateIso,
      unlockedAvatarsCsv: snap.unlockedAvatars,
      unlockedDecorCsv: snap.unlockedDecor,
      sparPlotCount: snap.sparPlotCount,
      quizLearnedTopicsCsv: snap.quizLearnedTopics,
      seenCoachesCsv: snap.seenCoaches,
      lastWeekNetWorthCents: snap.lastWeekNetWorthCents,
      lastWeeklyReviewDay: snap.lastWeeklyReviewDay,
      recentQuizTextsCsv: snap.recentQuizTexts,
      startAgeYears: snap.startAgeYears,
      savingsRatePct: snap.savingsRatePct,
      lastClaimedGoalDay: snap.lastClaimedGoalDay,
      parentPin: snap.parentPin,
      unlockedSkillsCsv: snap.unlockedSkills,
      weeklyChallengeClaimedWeek: snap.weeklyChallengeClaimedWeek,
      weeklyChallengeStreak: snap.weeklyChallengeStreak,
      claimedStreakMilestone: snap.claimedStreakMilestone,
      autoSaveDisabled: snap.autoSaveDisabled,
      backupFolderUri: snap.backupFolderUri,
      birthYear: snap.birthYear,
      birthYearAsked: snap.birthYearAsked,
      parentGateLockedUntilMs: snap.parentGateLockedUntilMs,
    );
    SoundService.instance.setMasterVolume(s.masterVolume / 100.0);
    SoundService.instance.setMusicVolume(s.musicVolume / 100.0);
    SoundService.instance.setSfxVolume(s.sfxVolume / 100.0);
    // Mirror the persisted mute-flag onto the static [SoundService] so the
    // audio backend is immediately consistent on cold start.
    SoundService.instance.muted = !s.soundEnabled;
    return s;
  }

  /// B7: Tagesziel-Claim für [dayIndex] persistent festschreiben.
  void setLastClaimedGoalDay(int dayIndex) {
    state = state.copyWith(lastClaimedGoalDay: dayIndex);
    _persist();
  }

  /// Welle-8 Round 23: Eltern-PIN setzen oder leeren. Leer = Lock aus.
  ///
  /// Gespeichert wird nur der Hash — der Klartext-PIN lag vorher in der
  /// `.fgsave`, und die liegt (als ZIP mit SQLite drin) im öffentlichen
  /// Download-Ordner: mit jedem Datei-Manager + SQLite-Viewer auslesbar. Der
  /// PIN ist UX-Schutz, kein Krypto-Feature — aber er sollte wenigstens dem
  /// „neugierigen Sohn" standhalten, dem eigentlichen Bedrohungsmodell.
  void setParentPin(String pin) {
    state = state.copyWith(
      parentPin: pin.isEmpty ? '' : hashParentPin(pin),
    );
    _persist();
  }

  /// Prüft eine PIN-Eingabe gegen den gespeicherten Wert.
  ///
  /// Migriert Alt-Saves transparent: liegt noch Klartext in der DB (Länge
  /// ≠ 64 Hex-Zeichen), wird bei korrekter Eingabe direkt auf den Hash
  /// umgestellt. Leerer gespeicherter Wert = kein Lock → immer true.
  bool parentPinMatches(String entered) {
    final stored = state.parentPin;
    if (stored.isEmpty) return true;
    if (stored.length == 64) return hashParentPin(entered) == stored;
    final ok = entered == stored;
    if (ok) setParentPin(entered); // Legacy-Klartext → Hash
    return ok;
  }

  /// Auto-Sicherung an-/ausschalten. Default AN — Nutzer kann sie in den
  /// Einstellungen ausschalten (persistent, Drift v36).
  void setAutoSaveEnabled(bool enabled) {
    state = state.copyWith(autoSaveDisabled: !enabled);
    _persist();
  }

  /// Drift v37: SAF-Backup-Ordner-URI setzen (nach Ordnerwahl im Picker).
  void setBackupFolderUri(String uri) {
    state = state.copyWith(backupFolderUri: uri);
    _persist();
  }

  /// Drift v38: Geburtsjahr setzen. Unplausible Jahre (Tippfehler, Zukunft)
  /// werden abgelehnt — dann bleibt der Status `unknown`, der Unterstützen-
  /// Bereich also unsichtbar. Liefert false, wenn nichts übernommen wurde.
  bool setBirthYear(int year, {required int currentYear}) {
    if (!isPlausibleBirthYear(year, currentYear: currentYear)) return false;
    state = state.copyWith(birthYear: year, birthYearAsked: true);
    _persist();
    return true;
  }

  /// Frage als gestellt markieren, ohne eine Angabe zu speichern (der Nutzer
  /// hat übersprungen). Verhindert, dass der Dialog bei jedem Start
  /// wiederkommt — Nerven schonen ist hier auch Richtlinien-Konformität: wer
  /// genervt wird, klickt irgendwann irgendwas.
  void markBirthYearAsked() {
    if (state.birthYearAsked) return;
    state = state.copyWith(birthYearAsked: true);
    _persist();
  }

  /// Drift v38: Sperre der Eltern-Rechenaufgabe setzen (ms seit Epoch).
  void setParentGateLockedUntil(int epochMs) {
    state = state.copyWith(parentGateLockedUntilMs: epochMs);
    _persist();
  }

  /// Spec-44 E3 setter (0..100, clamped).
  void setSavingsRatePct(int pct) {
    final clamped = pct.clamp(0, 100);
    state = state.copyWith(savingsRatePct: clamped);
    _persist();
  }

  // Spec-45 C4 hatte hier einen frei wählbaren Steuerklassen-Selektor
  // (`setSteuerklasse`). Entfernt in der Analyse-Runde 2026-08 (L11): der
  // Wert wurde nie persistiert und fiel bei jedem App-Start auf 1 zurück —
  // und genau dieser Bug war das Einzige, was einen Dauer-Gehaltsbonus
  // verhinderte. Klasse III senkt die Lohnsteuer auf 65 %, das sind bei
  // 3.500 € brutto rund 2.965 € mehr im Jahr, ohne jede Bedingung.
  //
  // Ihn zu persistieren hätte den Bonus dauerhaft gemacht. Ihn zu behalten
  // wäre auch didaktisch falsch: Klassen III/V setzen eine Ehe voraus, II ein
  // Kind, VI einen Zweitjob — nichts davon existiert im Spiel, und man sucht
  // sich seine Steuerklasse im echten Leben nicht aus wie einen Handytarif.
  // Die Spielfigur ist immer Klasse I (ledig), also rechnet die Lohnsteuer
  // fest damit. Erklärt wird das Thema jetzt im Glossar.

  void setAllowance(Money amount) {
    // Spec-43 v9: Cap auf 80 €/Monat — User-Hardregel.
    final capped = amount.cents > 8000 ? const Money.cents(8000) : amount;
    state = state.copyWith(allowance: capped);
    _persist();
  }

  void setAllowanceWeekday(Weekday weekday) {
    state = state.copyWith(allowanceWeekday: weekday);
    _persist();
  }

  void setPlayerName(String name) {
    state = state.copyWith(playerName: name);
    _persist();
  }

  void setSoundEnabled(bool enabled) {
    state = state.copyWith(soundEnabled: enabled);
    SoundService.instance.muted = !enabled;
    _persist();
  }

  /// Spec-17: persist the day-index on which the daily quiz was last shown.
  void setLastQuizDayIndex(int dayIndex) {
    state = state.copyWith(lastQuizDayIndex: dayIndex);
    _persist();
  }

  /// Spec-19: marks the Zeitreise tutorial as dismissed so it never shows
  /// again on subsequent opens.
  void setZeitreiseTutorialSeen(bool seen) {
    state = state.copyWith(zeitreiseTutorialSeen: seen);
    _persist();
  }

  /// Spec-23: persist music-volume slider value (0..100) and forward to
  /// the audio backend so the change is audible immediately.
  void setMusicVolume(int percent) {
    // spec-37: Musik komplett entfernt — Slider behält Wert für spätere
    // Reaktivierung, aber kein startMusic-Trigger mehr.
    final clamped = percent.clamp(0, 100);
    state = state.copyWith(musicVolume: clamped);
    SoundService.instance.setMusicVolume(0);
    _persist();
  }

  /// Spec-27: master volume multiplier (0..100).
  void setMasterVolume(int percent) {
    final clamped = percent.clamp(0, 100);
    state = state.copyWith(masterVolume: clamped);
    SoundService.instance.setMasterVolume(clamped / 100.0);
    _persist();
  }

  /// Spec-27: SFX volume multiplier (0..100).
  void setSfxVolume(int percent) {
    final clamped = percent.clamp(0, 100);
    state = state.copyWith(sfxVolume: clamped);
    SoundService.instance.setSfxVolume(clamped / 100.0);
    _persist();
  }

  /// Spec-33: persist anti-glitch sleep state.
  void setSleepState({required int epochMs, required int count}) {
    state = state.copyWith(
      lastSleepEpochMs: epochMs,
      sleepCountInWindow: count,
    );
    _persist();
  }

  /// Spec-34: onboarding setters.
  void setOnboardingComplete(bool value) {
    state = state.copyWith(onboardingComplete: value);
    _persist();
  }

  void setAvatarEmoji(String emoji) {
    state = state.copyWith(avatarEmoji: emoji);
    _persist();
  }

  /// Spec-38 follow-up: set start-age (Onboarding only — clamped 6..99).
  /// Drift v21: jetzt persistent — sonst fiel das Alter bei jedem
  /// App-Neustart auf 13 zurück und verfälschte Job/Lebenskosten/
  /// age-gated Vorsorge.
  void setStartAgeYears(int years) {
    final clamped = years.clamp(6, 99);
    state = state.copyWith(startAgeYears: clamped);
    _persist();
  }

  /// Spec-41 A: Liste freigeschalteter Avatar-Glyphs (immer inklusive 🧒).
  Set<String> unlockedAvatars() {
    final csv = state.unlockedAvatarsCsv;
    final set = <String>{'🧒'};
    for (final g in csv.split(',')) {
      final t = g.trim();
      if (t.isNotEmpty) set.add(t);
    }
    return set;
  }

  /// Spec-41 A: avatar via XP kaufen. False wenn nicht genug XP / Level
  /// zu niedrig. Bei Erfolg: XP abziehen, Glyph aktivieren, persistiert.
  /// [glyph] / [xpCost] / [minLevel] kommen aus AvatarSpec — Param-Liste
  /// statt Typ um Import-Zyklus zu vermeiden.
  bool purchaseAvatar({
    required String glyph,
    required int xpCost,
    required int minLevel,
  }) {
    final xp = ref.read(xpRepositoryProvider);
    if (xp < xpCost) return false;
    if (minLevel > 0) {
      // Level-Check via LevelSystem.xpForLevel-Formel inline (vermeidet
      // Import auf level_titles.dart): xpForLevel(n) = 100 * n^1.5.
      final lvl = minLevel.toDouble();
      final needed = (100 * lvl * _approxSqrt(lvl)).round();
      if (xp < needed) return false;
    }
    ref.read(xpRepositoryProvider.notifier).add(-xpCost);
    final unlocked = unlockedAvatars()..add(glyph);
    unlocked.remove('🧒');
    state = state.copyWith(
      unlockedAvatarsCsv: unlocked.join(','),
      avatarEmoji: glyph,
    );
    _persist();
    return true;
  }

  /// Spec-43 Stage 1: freigeschaltete Decor-Item-IDs.
  Set<String> unlockedDecor() {
    final csv = state.unlockedDecorCsv;
    final set = <String>{};
    for (final id in csv.split(',')) {
      final t = id.trim();
      if (t.isNotEmpty) set.add(t);
    }
    return set;
  }

  /// Round 28: freigeschaltete Skill-Baum-Knoten.
  Set<String> unlockedSkills() {
    final csv = state.unlockedSkillsCsv;
    final set = <String>{};
    for (final id in csv.split(',')) {
      final t = id.trim();
      if (t.isNotEmpty) set.add(t);
    }
    return set;
  }

  /// True wenn Skill [skillId] freigeschaltet ist.
  bool hasSkill(String skillId) => unlockedSkills().contains(skillId);

  /// Round 28: verfügbare Skill-Punkte = aktuelles Level − ausgegebene
  /// Punkte. Round 28 v4: ausgegeben = Summe der Knoten-KOSTEN (Prestige-
  /// Knoten kosten mehrere) + eingelöste Punkte. Nie negativ.
  int availableSkillPoints() {
    final level = LevelSystem.levelFor(ref.read(xpRepositoryProvider));
    final spent = spentSkillPoints(unlockedSkills());
    final free = level - spent;
    return free < 0 ? 0 : free;
  }

  /// Round 28: Skill freischalten. Kostet `skillCost(id)` Skill-Punkte (kein
  /// XP-Abzug — Punkte kommen aus Level-Ups). Tier-Voraussetzungen prüft die
  /// UI vor dem Aufruf. Liefert true bei Erfolg, false wenn nicht genug
  /// Punkte frei.
  bool unlockSkill(String skillId) {
    if (skillId.isEmpty) return false;
    final unlocked = unlockedSkills();
    if (unlocked.contains(skillId)) return true;
    if (availableSkillPoints() < skillCost(skillId)) return false;
    unlocked.add(skillId);
    state = state.copyWith(unlockedSkillsCsv: unlocked.join(','));
    _persist();
    return true;
  }

  /// Round 28 v2: einen übrigen Skill-Punkt einlösen. Speichert eine
  /// synthetische redeem_N-ID (zählt gegen die verfügbaren Punkte). Der
  /// Aufrufer schreibt den Cash-Gegenwert gut. Liefert true bei Erfolg.
  bool redeemSkillPoint() {
    if (availableSkillPoints() <= 0) return false;
    final n = redeemedCount(unlockedSkills());
    return unlockSkill('$kRedeemPrefix$n');
  }

  /// Round 28 v4: Wochen-Herausforderung — Stand lesen/schreiben.
  int weeklyChallengeClaimedWeek() => state.weeklyChallengeClaimedWeek;
  int weeklyChallengeStreak() => state.weeklyChallengeStreak;

  void setWeeklyChallenge({required int claimedWeek, required int streak}) {
    state = state.copyWith(
      weeklyChallengeClaimedWeek: claimedWeek,
      weeklyChallengeStreak: streak,
    );
    _persist();
  }

  /// Optionen-Backlog #2: höchste ausgezahlte Streak-Meilenstein-Schwelle.
  int claimedStreakMilestone() => state.claimedStreakMilestone;

  void setClaimedStreakMilestone(int milestone) {
    state = state.copyWith(claimedStreakMilestone: milestone);
    _persist();
  }

  /// Welle-8 Round 14: Quiz-Topic als gelernt markieren (1× richtig).
  Set<String> quizLearnedTopics() {
    final csv = state.quizLearnedTopicsCsv;
    final set = <String>{};
    for (final t in csv.split(',')) {
      final trimmed = t.trim();
      if (trimmed.isNotEmpty) set.add(trimmed);
    }
    return set;
  }

  void addQuizLearnedTopic(String topic) {
    if (topic.isEmpty) return;
    final set = quizLearnedTopics();
    if (!set.add(topic)) return;
    state = state.copyWith(quizLearnedTopicsCsv: set.join(','));
    _persist();
  }

  /// Welle-8 Round 15: First-Steps-Coach getroffen.
  bool hasSeenCoach(String coachId) {
    if (coachId.isEmpty) return true;
    return state.seenCoachesCsv
        .split(',')
        .map((s) => s.trim())
        .contains(coachId);
  }

  void markCoachSeen(String coachId) {
    if (coachId.isEmpty) return;
    if (hasSeenCoach(coachId)) return;
    final set = <String>{};
    for (final s in state.seenCoachesCsv.split(',')) {
      final t = s.trim();
      if (t.isNotEmpty) set.add(t);
    }
    set.add(coachId);
    state = state.copyWith(seenCoachesCsv: set.join(','));
    _persist();
  }

  /// Welle-8 Round 15: Wochen-Review-Snapshot speichern.
  void setWeeklyReviewSnapshot({
    required int netWorthCents,
    required int dayIndex,
  }) {
    state = state.copyWith(
      lastWeekNetWorthCents: netWorthCents,
      lastWeeklyReviewDay: dayIndex,
    );
    _persist();
  }

  /// Welle-8 Round 15: Quiz-Anti-Repeat Set persistent setzen.
  void setRecentQuizTexts(String csv) {
    state = state.copyWith(recentQuizTextsCsv: csv);
    _persist();
  }

  /// Spec-43 Stage 1: Decor-Item via XP kaufen.
  /// Liefert true bei Erfolg. Bei Erfolg: XP abziehen + persist.
  bool purchaseDecor({required String decorId, required int xpCost}) {
    final xp = ref.read(xpRepositoryProvider);
    if (xp < xpCost) return false;
    if (unlockedDecor().contains(decorId)) return true;
    ref.read(xpRepositoryProvider.notifier).add(-xpCost);
    final unlocked = unlockedDecor()..add(decorId);
    state = state.copyWith(unlockedDecorCsv: unlocked.join(','));
    _persist();
    return true;
  }

  /// Spec-43 follow-up: Spar-Insel-Plot kaufen.
  /// XP-Kosten + Level-Lock pro Plot. Liefert true bei Erfolg.
  /// Plot-Kosten (Formel): cost = 50 * (n-4)^1.5, gerundet.
  /// minLevel = ceil((n-4) / 2). Spec-43 v9: max 24 statt 10.
  static (int, int) _plotCostFor(int n) {
    if (n < 5 || n > 18) return (0, 0);
    final delta = n - 4;
    final cost = (50 * math.pow(delta, 1.5)).round();
    final minLevel = ((delta + 1) ~/ 2).clamp(1, 12);
    return (cost, minLevel);
  }

  bool purchaseSparPlot() {
    final next = state.sparPlotCount + 1;
    if (next > 18) return false;
    final (cost, minLevel) = _plotCostFor(next);
    if (cost == 0) return false;
    final xp = ref.read(xpRepositoryProvider);
    if (xp < cost) return false;
    if (minLevel > 0) {
      final lvl = minLevel.toDouble();
      final needed = (100 * lvl * _approxSqrt(lvl)).round();
      if (xp < needed) return false;
    }
    ref.read(xpRepositoryProvider.notifier).add(-cost);
    state = state.copyWith(sparPlotCount: next);
    _persist();
    return true;
  }

  ({int cost, int minLevel})? sparPlotCostPreview() {
    final next = state.sparPlotCount + 1;
    if (next > 18) return null;
    final (cost, minLevel) = _plotCostFor(next);
    if (cost == 0) return null;
    return (cost: cost, minLevel: minLevel);
  }

  /// Newton-iteration sqrt (Dart double hat keinen `.sqrt()`).
  static double _approxSqrt(double v) {
    if (v <= 0) return 0;
    var x = v;
    for (var i = 0; i < 10; i++) {
      x = 0.5 * (x + v / x);
    }
    return x;
  }

  /// Spec-40 C: registriere einen Schlaf am realen Tag [today]. Erhöht den
  /// Streak wenn [today] = [lastSleepDateIso] + 1 Tag, sonst reset auf 1.
  /// Gibt den NEUEN Streak-Count zurück. Persistiert sofort.
  int registerSleep(DateTime today) {
    final iso =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    if (state.lastSleepDateIso == iso) {
      // Schon heute geschlafen — Streak unverändert.
      return state.streakCount;
    }
    int newCount;
    if (state.lastSleepDateIso.isEmpty) {
      newCount = 1;
    } else {
      final last = DateTime.tryParse(state.lastSleepDateIso);
      if (last == null) {
        newCount = 1;
      } else {
        final delta = today.difference(last).inDays;
        newCount = delta == 1 ? state.streakCount + 1 : 1;
      }
    }
    state = state.copyWith(
      streakCount: newCount,
      lastSleepDateIso: iso,
    );
    _persist();
    return newCount;
  }

  void _persist() {
    final db = ref.read(appDatabaseProvider);
    final s = state;
    unawaited(
      db.settingsDao
          .upsert(
            allowanceCents: s.allowance.cents,
            allowanceWeekday: s.allowanceWeekday.name,
            playerName: s.playerName,
            soundEnabled: s.soundEnabled,
            lastQuizDayIndex: s.lastQuizDayIndex,
            zeitreiseTutorialSeen: s.zeitreiseTutorialSeen,
            musicVolume: s.musicVolume,
            masterVolume: s.masterVolume,
            sfxVolume: s.sfxVolume,
            lastSleepEpochMs: s.lastSleepEpochMs,
            sleepCountInWindow: s.sleepCountInWindow,
            onboardingComplete: s.onboardingComplete,
            avatarEmoji: s.avatarEmoji,
            streakCount: s.streakCount,
            lastSleepDateIso: s.lastSleepDateIso,
            unlockedAvatars: s.unlockedAvatarsCsv,
            unlockedDecor: s.unlockedDecorCsv,
            sparPlotCount: s.sparPlotCount,
            quizLearnedTopics: s.quizLearnedTopicsCsv,
            seenCoaches: s.seenCoachesCsv,
            lastWeekNetWorthCents: s.lastWeekNetWorthCents,
            lastWeeklyReviewDay: s.lastWeeklyReviewDay,
            recentQuizTexts: s.recentQuizTextsCsv,
            startAgeYears: s.startAgeYears,
            savingsRatePct: s.savingsRatePct,
            lastClaimedGoalDay: s.lastClaimedGoalDay,
            parentPin: s.parentPin,
            unlockedSkills: s.unlockedSkillsCsv,
            weeklyChallengeClaimedWeek: s.weeklyChallengeClaimedWeek,
            weeklyChallengeStreak: s.weeklyChallengeStreak,
            claimedStreakMilestone: s.claimedStreakMilestone,
            autoSaveDisabled: s.autoSaveDisabled,
            backupFolderUri: s.backupFolderUri,
            birthYear: s.birthYear,
            birthYearAsked: s.birthYearAsked,
            parentGateLockedUntilMs: s.parentGateLockedUntilMs,
          )
          .catchError((Object _) {}),
    );
  }
}

/// Altersstatus der echten Person am Gerät, abgeleitet aus dem gespeicherten
/// Geburtsjahr und dem HEUTIGEN Jahr — nicht eingefroren. Wer als
/// minderjährig eingetragen ist, wird mit der Zeit von selbst volljährig.
///
/// Steuert einzig die Sichtbarkeit des Unterstützen-Bereichs. Auf das Spiel
/// selbst hat der Status keinerlei Einfluss: es ist in jedem Zustand
/// vollständig spielbar, auch wenn die Frage übersprungen wurde.
@riverpod
AgeState ageState(Ref ref) {
  final birthYear = ref.watch(settingsRepositoryProvider).birthYear;
  return ageStateFor(birthYear, currentYear: DateTime.now().year);
}
