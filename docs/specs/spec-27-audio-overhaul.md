# Spec 27 — Audio Overhaul

## Goal

Sound von „schrecklich" zu „angenehm". Neue Music-Loops + UI-SFX kuratiert. Per-Kategorie Lautstärke.

## Why

Sohn-Feedback: Sound nervt. Aktuelle Tracks zu laut/aggressiv/repetitiv.

## Non-Goals

- Eigenkomposition. Nutze Kenney + freie Quellen.

## Tasks

### 1. Asset-Audit + Auswahl

Aus `Zusätze/`:
- `kenney_music-jingles.zip` → Loop-Kandidaten (kurze Jingles, sanft)
- `kenney_rpg-audio.zip` → ambient
- `kenney_ui-audio.zip` → click/confirm/error (kurze SFX)
- `kenney_interface-sounds.zip` → alternative UI

Pro Insel/Screen ein Track:
- Heimathafen: ruhig, Akustik
- Monetaria-Karte: leicht maritim
- Bank: neutral-ambient
- Schlaf-Cutscene: lullaby-jingle
- Quiz-LockScreen: leise Drone

Tracks bei -18 LUFS normalisieren (sox/ffmpeg lokal vor commit).

### 2. SoundService-Refactor

`sound_service.dart`:
- Kategorien: `music`, `ui`, `success`, `error`, `coin`
- Pro Kategorie eigener Volume-State 0..1
- Master-Volume + Mute global
- `playMusic(track)` cross-fade 800ms zwischen Tracks
- `playSfx(SfxId id)` mit Throttling (gleiches SFX nicht mehrfach in 50ms)

Provider-Wrapping bleibt. Init in `main.dart` lädt Volumes aus Settings.

### 3. Settings: Audio-Block

`SettingsPage`: PixelPanel „Audio" mit Slidern:
- Master (0..100, default 60)
- Musik (0..100, default 30)
- Effekte (0..100, default 70)
- Mute-Schalter (oben)

Drift: neue Spalten `masterVolume`, `musicVolume` (bereits da?), `sfxVolume`.

### 4. SFX-Trigger reduzieren

Aktueller Spam: Quest-Step, Schlaf-Tick, Tab-Wechsel — alle laut. Audit:
- Tab-Wechsel: leise Click
- Money-Income: aufsteigender Coin-Plink (3 Töne)
- Money-Outgo: kurzer Thud
- Quest-Complete: Fanfare-Mini
- Error: kurz dezent
- Sleep-Snore: sehr leise Loop, max 30 % Volume

Keine SFX für: pures Scrollen, Hover, Idle.

### 5. Track-Loop-Punkte

Aktuell hört man Loop-Naht. Audio-Files mit Crossfade-Loop exportieren (Audacity-Crossfade-Loop 200ms am Anfang+Ende). Oder via `audioplayers` `setReleaseMode(ReleaseMode.loop)` + Track ist sauber zugeschnitten.

## Files

- `assets/sfx/*` — neue Files (3-5)
- `assets/music/*` — neue Loop-Tracks (4-5)
- `lib/features/audio/sound_service.dart` — Kategorie-API
- `lib/features/audio/audio_constants.dart` — SfxId enum, MusicTrack enum
- `lib/data/db/tables.dart` — sfxVolume, masterVolume cols
- `lib/features/settings/settings_repository.dart` — getter/setter
- `lib/features/settings/settings_page.dart` — Slider-Block
- `lib/main.dart` — init volumes
- `pubspec.yaml` — assets refresh
- `ASSETS.md` — neue Quellen + Lizenzen

## Tests

- SoundService.setVolume clamping
- Pro Kategorie Volume getrennt
- Cross-fade Logik (pure, ohne audio)
- Drift round-trip

## Acceptance

- [ ] Neue Tracks pro Screen, leiser+angenehmer
- [ ] Master/Music/SFX-Slider in Settings
- [ ] Loop ohne hörbare Naht
- [ ] SFX-Spam weg
- [ ] Defaults: Master 60, Musik 30, SFX 70
- [ ] Tests grün
- [ ] `flutter analyze --fatal-infos` clean
- [ ] Commit: `feat(audio): track overhaul + category volumes + reduce sfx spam`
