import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/design_tokens.dart';
import '../../domain/age/age_state.dart';
import '../../domain/economy/money.dart';
import '../../domain/sim/weekday.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../../data/db/app_database_provider.dart';
import '../../data/quest/quest_asset_repository.dart';
import '../../domain/quest/quest.dart';
import '../highscore/highscore_page.dart';
import '../highscore/highscore_repository.dart';
import '../quest_runner/quest_progress_repository.dart';
import '../quest_runner/quest_runner_page.dart';
import 'about_page.dart';
import 'birth_year_prompt.dart';
import 'parent_math_gate.dart';
import 'save_export_service.dart';
import 'settings_repository.dart';

/// Freiwilliger Trinkgeld-Link. LEER lassen = Sektion ausgeblendet.
/// Zum Aktivieren die eigene PayPal.me- oder Ko-fi-URL eintragen, z. B.
/// 'https://paypal.me/DEINNAME' oder 'https://ko-fi.com/DEINNAME'.
/// Hinweis: PayPal.me ist hier sauberer, weil dort nichts verkauft wird —
/// keine Gegenleistung, siehe [_SupportSection].
///
/// Bewusst `final` statt `const`: bei `const ''` würde der Analyzer den
/// Sichtbarkeits-Branch als toten Code + das Widget als ungenutzt melden.
// ignore: prefer_const_declarations
final String kDonationUrl = 'https://www.paypal.me/SLeipziger';

/// Kontaktadresse für die Erstattungszusage im Unterstützen-Bereich.
/// LEER lassen = die Zusage wird nicht angezeigt.
///
/// Bewusst eine eigene Projekt-Adresse und nicht die private: sie steht
/// öffentlich im Quelltext, im Repository und später im Store-Eintrag. An
/// allen drei Stellen dieselbe — abweichende Adressen sind ein vermeidbarer
/// Stolperstein bei der Prüfung.
///
/// Ohne sie fehlt die Erstattungszusage, und die fängt den einen Fall ab, den
/// keine Elternschranke verhindern kann: ein Kind, das die Altersfrage falsch
/// beantwortet UND die Rechenaufgabe löst.
// ignore: prefer_const_declarations
final String kContactEmail = 'sepp.github@gmail.com';

/// Editable settings screen — spec-15.
///
/// Lives inside the standard [PhoneFrame] so the HomeBar still works
/// (back / home / settings). All edits go through [SettingsRepository]
/// which persists fire-and-forget via Drift.
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _allowanceCtrl;
  late final TextEditingController _nameCtrl;
  // Welle-8 Round 23 v3: PIN-Gate auf gesamte Settings-Page. Wenn
  // parentPin gesetzt → erst Eingabe-Dialog, dann Inhalt sichtbar.
  bool _unlocked = false;
  bool _promptShown = false;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsRepositoryProvider);
    _allowanceCtrl = TextEditingController(
      text: (s.allowance.cents / 100).toStringAsFixed(0),
    );
    _nameCtrl = TextEditingController(text: s.playerName);
    if (s.parentPin.isEmpty) {
      _unlocked = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _askPinGate());
    }
  }

  Future<void> _askPinGate() async {
    if (_promptShown) return;
    _promptShown = true;
    final repo = ref.read(settingsRepositoryProvider.notifier);
    if (ref.read(settingsRepositoryProvider).parentPin.isEmpty) {
      setState(() => _unlocked = true);
      return;
    }
    final entered = await _promptPin('🔒 Eltern-PIN');
    if (!mounted) return;
    // Der PIN liegt nur als Hash in der DB — Vergleich über das Repository.
    if (entered != null && repo.parentPinMatches(entered)) {
      setState(() => _unlocked = true);
    } else {
      showFgSnack(context, 'Falscher PIN.', isError: true);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _allowanceCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final notifier = ref.read(settingsRepositoryProvider.notifier);
    final euros = int.tryParse(_allowanceCtrl.text.trim());
    if (euros != null && euros >= 0) {
      notifier.setAllowance(Money.cents(euros * 100));
    }
    final name = _nameCtrl.text.trim();
    if (name.isNotEmpty) {
      notifier.setPlayerName(name);
    }
    // Welle-8 Round 22 / B4: Start-Alter-Editor entfernt — war Cheating-
    // Vector (Alter zurücksetzen → Job-Phase + Lebenskosten manipulieren).
    // Alter nur noch im Onboarding setzbar.
    showFgSnack(context, 'Gespeichert ✓');
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsRepositoryProvider);
    final notifier = ref.watch(settingsRepositoryProvider.notifier);

    // Welle-8 Round 23 v3: PIN-Gate — Inhalt erst sichtbar nach
    // korrekter PIN-Eingabe (wenn PIN gesetzt).
    if (!_unlocked) {
      return PhoneFrame(
        appName: 'Einstellungen',
        onBack: () => Navigator.of(context).pop(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(FgSpacing.l),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🔒', style: TextStyle(fontSize: 64)),
                const SizedBox(height: FgSpacing.m),
                const Text(
                  'Einstellungen sind durch Eltern-PIN geschützt.',
                  style: FgTypography.bodyM,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FgSpacing.l),
                PixelButton(
                  label: 'PIN eingeben',
                  background: FgColors.primary,
                  foreground: FgColors.onPrimary,
                  onPressed: () {
                    _promptShown = false;
                    _askPinGate();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PhoneFrame(
      appName: 'Einstellungen',
      onBack: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(FgSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welle-8 Round 22 v5: Version-Anzeige oben — Sohn weiß
            // welche Version installiert ist.
            const _VersionRow(),
            const SizedBox(height: FgSpacing.s),
            // spec-46: Attribution ist bei Twemoji (CC-BY 4.0)
            // Lizenzbedingung, nicht Deko — die Seite muss erreichbar sein.
            PixelButton(
              label: 'ℹ Über & Lizenzen',
              semanticLabel: 'Über die App und ihre Lizenzen',
              background: FgColors.backgroundElevated,
              foreground: FgColors.onSurface,
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const AboutPage()),
              ),
            ),
            const SizedBox(height: FgSpacing.s),
            PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Spielername', style: FgTypography.bodyS),
                  const SizedBox(height: FgSpacing.xs),
                  TextField(
                    controller: _nameCtrl,
                    style: FgTypography.bodyM,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: FgSpacing.m),
            PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Taschengeld pro Monat (€)',
                      style: FgTypography.bodyS),
                  const SizedBox(height: FgSpacing.xs),
                  TextField(
                    controller: _allowanceCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: FgTypography.bodyM,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      suffixText: '€',
                    ),
                  ),
                  const SizedBox(height: FgSpacing.m),
                  const Text(
                    'Bevorzugter Auszahlungstag (monatlich)',
                    style: FgTypography.bodyS,
                  ),
                  const Text(
                    'Taschengeld kommt einmal pro Monat — du wählst nur '
                    'den Wochentag-Rhythmus.',
                    style: FgTypography.bodyS,
                  ),
                  const SizedBox(height: FgSpacing.xs),
                  DropdownButton<Weekday>(
                    value: settings.allowanceWeekday,
                    isExpanded: true,
                    items: [
                      for (final w in Weekday.values)
                        DropdownMenuItem(
                          value: w,
                          child: Text(w.fullNameDe,
                              style: FgTypography.bodyM),
                        ),
                    ],
                    onChanged: (w) {
                      if (w != null) notifier.setAllowanceWeekday(w);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: FgSpacing.m),
            PixelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text('Sound', style: FgTypography.bodyM),
                      ),
                      Switch(
                        value: settings.soundEnabled,
                        onChanged: notifier.setSoundEnabled,
                      ),
                    ],
                  ),
                  // spec-37: Musik-Slider entfernt (keine Musik mehr).
                  const SizedBox(height: FgSpacing.s),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Master-Lautstärke',
                          style: FgTypography.bodyM,
                        ),
                      ),
                      Text(
                        '${settings.masterVolume}%',
                        style: FgTypography.bodyS,
                      ),
                    ],
                  ),
                  Slider(
                    value: settings.masterVolume.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${settings.masterVolume}%',
                    onChanged: (v) => notifier.setMasterVolume(v.round()),
                  ),
                  const SizedBox(height: FgSpacing.s),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Effekt-Lautstärke',
                          style: FgTypography.bodyM,
                        ),
                      ),
                      Text(
                        '${settings.sfxVolume}%',
                        style: FgTypography.bodyS,
                      ),
                    ],
                  ),
                  Slider(
                    value: settings.sfxVolume.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${settings.sfxVolume}%',
                    onChanged: (v) => notifier.setSfxVolume(v.round()),
                  ),
                ],
              ),
            ),
            // Hier stand bis zur Analyse-Runde 2026-08 ein frei wählbarer
            // Steuerklassen-Selektor (spec-45 C4). Raus, siehe L11 im
            // SettingsRepository: die Wahl war ein bedingungsloser
            // Gehaltsbonus (Klasse III = bis zu 2.965 €/Jahr mehr), und
            // Steuerklassen hängen an der Lebenssituation, nicht an einer
            // Auswahl. Die Spielfigur ist ledig = Klasse I. Erklärt wird das
            // Thema im Glossar.
            const SizedBox(height: FgSpacing.xl),
            PixelButton(
              label: 'Speichern',
              background: FgColors.primary,
              foreground: FgColors.onSurface,
              onPressed: _save,
            ),
            const SizedBox(height: FgSpacing.xl),
            const Divider(color: FgColors.outline, thickness: 1),
            const SizedBox(height: FgSpacing.m),
            const Text(
              'Hilfe & Tutorial',
              style: FgTypography.bodyL,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '🔁 Tutorial wiederholen',
              background: FgColors.info,
              foreground: FgColors.onSurface,
              onPressed: _replayTutorial,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '🏆 Highscore',
              background: FgColors.primary,
              foreground: FgColors.onPrimary,
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const HighscorePage(),
                ),
              ),
            ),
            const SizedBox(height: FgSpacing.xl),
            const Divider(color: FgColors.outline, thickness: 1),
            const SizedBox(height: FgSpacing.m),
            const Text(
              '💾 Spielstand sichern',
              style: FgTypography.bodyL,
            ),
            const SizedBox(height: FgSpacing.s),
            Container(
              padding: const EdgeInsets.all(FgSpacing.s),
              decoration: BoxDecoration(
                color: FgColors.info.withValues(alpha: 0.15),
                border: Border.all(color: FgColors.info, width: 1),
                borderRadius:
                    const BorderRadius.all(Radius.circular(FgRadius.tight)),
              ),
              child: const Text(
                '• Update via APK/Play-Store: Spielstand bleibt ✓\n'
                '• Auto-Save nach jedem Schlafen → Download/Finanzgame/\n'
                '  (überlebt Deinstall — App fragt beim Neustart ob '
                'wiederherstellen)\n'
                '• Zusätzlich manuell via "Exportieren" → Datei zu '
                'Drive/WhatsApp schicken.',
                style: FgTypography.bodyS,
              ),
            ),
            const SizedBox(height: FgSpacing.s),
            _buildAutoSaveToggle(),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '💾 Auto-Save jetzt erzwingen',
              background: FgColors.success,
              foreground: FgColors.onSurface,
              onPressed: _forceAutoSave,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '📤 Spielstand exportieren',
              background: FgColors.info,
              foreground: FgColors.onSurface,
              onPressed: _exportSave,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '📥 Spielstand importieren',
              background: FgColors.secondary,
              foreground: FgColors.onSurface,
              onPressed: _confirmImport,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '🔧 Diagnose-Dateien teilen',
              background: FgColors.backgroundElevated,
              foreground: FgColors.onSurface,
              onPressed: _shareDiagnostics,
            ),
            // Bestand- + Wochen-Report sind in die eigene „Berichte"-Seite
            // (Springboard, vor den Settings) umgezogen.
            const SizedBox(height: FgSpacing.l),
            const Divider(color: FgColors.outline, thickness: 1),
            const SizedBox(height: FgSpacing.m),
            const Text(
              '🔒 Eltern-Schutz',
              style: FgTypography.bodyL,
            ),
            const SizedBox(height: FgSpacing.s),
            _ParentPinSection(),
            const SizedBox(height: FgSpacing.m),
            const _BirthYearSection(),
            // Der Unterstützen-Bereich existiert NUR für Volljährige. Bei
            // `minor` und `unknown` wird er nicht ausgegraut und nicht mit
            // Schloss gezeigt, sondern gar nicht erst gebaut — es gibt auch
            // keinen Hinweis darauf, dass es ihn gibt. „Keine Angabe" zählt
            // dabei wie minderjährig: das Überspringen der Altersfrage ist
            // kein Nachweis von Volljährigkeit.
            if (kDonationUrl.isNotEmpty &&
                ref.watch(ageStateProvider) == AgeState.adult) ...[
              const SizedBox(height: FgSpacing.l),
              const Text('💛 Unterstützen', style: FgTypography.bodyL),
              const SizedBox(height: FgSpacing.s),
              const _SupportSection(),
            ],
            const SizedBox(height: FgSpacing.l),
            const Text(
              'Gefährlicher Bereich',
              style: FgTypography.bodyL,
            ),
            const SizedBox(height: FgSpacing.s),
            PixelButton(
              label: '⚠ Spiel komplett neu starten',
              background: FgColors.alert,
              foreground: FgColors.onSurface,
              onPressed: _confirmReset,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _replayTutorial() async {
    // Spec-42 Welle-6: q00_tutorial-Progress löschen + Quest sofort
    // pushen. Springboard re-checkt nicht mehr, deshalb direkt Page öffnen.
    final progressRepo =
        ref.read(questProgressRepositoryProvider.notifier);
    await progressRepo.deleteQuestProgress('q00_tutorial');
    if (!mounted) return;
    final quests = await ref.read(questsProvider.future);
    if (!mounted) return;
    final Quest? q =
        quests.where((Quest q) => q.id == 'q00_tutorial').firstOrNull;
    if (q == null) {
      showFgSnack(context, 'Tutorial nicht gefunden', isError: true);
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => QuestRunnerPage(quest: q),
      ),
    );
  }

  /// Welle-8 Round 23 v3: Helper für PIN-Gate-Dialog.
  Future<String?> _promptPin(String title) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text(title, style: FgTypography.bodyL),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '4-stelliger PIN',
            counterText: '',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ctrl.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Auto-Sicherung-Schalter (default AN) + Status-Zeile (Berechtigung +
  /// letzte Sicherung). Drift v36.
  Widget _buildAutoSaveToggle() {
    final enabled = ref.watch(
      settingsRepositoryProvider.select((s) => s.autoSaveEnabled),
    );
    final folderUri = ref.watch(
      settingsRepositoryProvider.select((s) => s.backupFolderUri),
    );
    final hasFolder = folderUri != null && folderUri.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // A11y: MergeSemantics — TalkBack liest Label + Schalter-Zustand
        // zusammen (sonst nur "Schalter, an/aus" ohne Namen).
        MergeSemantics(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  enabled ? '🟢 Auto-Sicherung: AN' : '🔴 Auto-Sicherung: AUS',
                  style: FgTypography.bodyM,
                ),
              ),
              Switch(
                value: enabled,
                onChanged: (v) => unawaited(_toggleAutoSave(v)),
              ),
            ],
          ),
        ),
        FutureBuilder<String>(
          future: _autoSaveStatusText(),
          builder: (ctx, snap) => Text(
            snap.data ?? 'Status wird geprüft…',
            style: FgTypography.bodyS.copyWith(color: FgColors.onSurfaceMuted),
          ),
        ),
        const SizedBox(height: FgSpacing.s),
        PixelButton(
          label:
              hasFolder ? '📁 Backup-Ordner ändern' : '📁 Backup-Ordner wählen',
          background: FgColors.info,
          foreground: FgColors.onPrimary,
          onPressed: () => unawaited(_pickBackupFolder()),
        ),
      ],
    );
  }

  /// SAF-Ordnerwahl: kein „Zugriff auf alle Dateien" nötig. Persistiert die
  /// Tree-URI + schreibt sofort eine erste Sicherung.
  Future<void> _pickBackupFolder() async {
    final svc = SaveExportService.instance;
    final uri = await svc.pickBackupFolder();
    if (uri == null) {
      if (mounted) showFgSnack(context, 'Ordnerwahl abgebrochen.');
      return;
    }
    ref.read(settingsRepositoryProvider.notifier).setBackupFolderUri(uri);
    final ok = await svc.writeAutoSave(
      safFolderUri: uri,
      live: ref.read(appDatabaseProvider),
    );
    if (!mounted) return;
    showFgSnack(
      context,
      ok
          ? '✅ Backup-Ordner gesetzt — erste Sicherung gespeichert.'
          : 'Ordner gesetzt, aber Sicherung fehlgeschlagen.',
      isError: !ok,
    );
    setState(() {}); // Status-Zeile aktualisieren
  }

  Future<void> _toggleAutoSave(bool enabled) async {
    ref.read(settingsRepositoryProvider.notifier).setAutoSaveEnabled(enabled);
    if (enabled) {
      final folderUri = ref.read(settingsRepositoryProvider).backupFolderUri;
      if (folderUri == null || folderUri.isEmpty) {
        // Noch kein Ordner gewählt → direkt zur Ordnerwahl führen.
        await _pickBackupFolder();
      } else {
        final ok = await SaveExportService.instance.writeAutoSave(
          safFolderUri: folderUri,
          live: ref.read(appDatabaseProvider),
        );
        if (mounted) {
          showFgSnack(
            context,
            ok
                ? '✅ Auto-Sicherung an — erste Sicherung gespeichert.'
                : 'Auto-Sicherung an, aber Sicherung fehlgeschlagen.',
            isError: !ok,
          );
        }
      }
    }
    if (mounted) setState(() {}); // Status-Zeile + Switch aktualisieren
  }

  Future<String> _autoSaveStatusText() async {
    final svc = SaveExportService.instance;
    final folderUri = ref.read(settingsRepositoryProvider).backupFolderUri;
    String two(int n) => n.toString().padLeft(2, '0');
    // SAF-Pfad (bevorzugt): Ordner gewählt.
    if (folderUri != null && folderUri.isNotEmpty) {
      final info = await svc.safBackupInfo(folderUri);
      if (info == null) {
        return 'Ordner gewählt ✓ — noch keine Sicherung. Schlafe einmal '
            'oder tippe „Auto-Save jetzt erzwingen".';
      }
      final m = info.modified;
      return 'Ordner gewählt ✓ — letzte Sicherung: '
          '${two(m.day)}.${two(m.month)}.${m.year} ${two(m.hour)}:'
          '${two(m.minute)}';
    }
    // Legacy-Pfad: MANAGE_EXTERNAL_STORAGE.
    final granted = await svc.hasStoragePermission();
    if (!granted) {
      return '⚠ Kein Backup-Ordner gewählt. Tippe „Backup-Ordner wählen" '
          '— so überlebt dein Spielstand eine Neu-Installation.';
    }
    final found = await svc.findExternalAutoSave();
    if (found == null) {
      return 'Alt-Berechtigung erteilt ✓ — noch keine Sicherung.';
    }
    final m = found.modified;
    return 'Alt-Berechtigung erteilt ✓ — letzte Sicherung: '
        '${two(m.day)}.${two(m.month)}.${m.year} ${two(m.hour)}:'
        '${two(m.minute)}';
  }

  /// Teilt Diagnose-Dateien (kaputte .corrupt.bak + aktuelle DB + Auto-Save)
  /// per Share-Sheet — zur Analyse z.B. via WhatsApp.
  Future<void> _shareDiagnostics() async {
    try {
      final n = await SaveExportService.instance.shareDiagnostics();
      if (!mounted) return;
      if (n == 0) {
        showFgSnack(
          context,
          'Keine Diagnose-Dateien gefunden.',
          isError: true,
        );
      }
    } on Object catch (e) {
      if (mounted) {
        showFgSnack(context, 'Diagnose fehlgeschlagen: $e', isError: true);
      }
    }
  }

  /// Welle-8 Round 23: erzwingt sofortiges Auto-Save in
  /// Download/Finanzgame/autosave.fgsave (fragt ggf. nach Permission).
  Future<void> _forceAutoSave() async {
    try {
      final folderUri = ref.read(settingsRepositoryProvider).backupFolderUri;
      final ok = await SaveExportService.instance.writeAutoSave(
        safFolderUri: folderUri,
        live: ref.read(appDatabaseProvider),
      );
      if (!mounted) return;
      showFgSnack(
        context,
        ok
            ? '✅ Auto-Save gespeichert.'
            : 'Auto-Save fehlgeschlagen — Backup-Ordner wählen?',
        isError: !ok,
      );
    } on Object catch (e) {
      if (mounted) {
        showFgSnack(context, 'Auto-Save Fehler: $e', isError: true);
      }
    }
  }

  /// Welle-8 Round 20: JSON/SQLite-Export der gesamten Spielstand-DB.
  Future<void> _exportSave() async {
    try {
      final ok = await SaveExportService.instance.exportToShareSheet(
        live: ref.read(appDatabaseProvider),
      );
      if (!mounted) return;
      if (!ok) {
        showFgSnack(
          context,
          'Noch kein Spielstand vorhanden zum Exportieren.',
          isError: true,
        );
      }
    } on Object catch (e) {
      if (mounted) {
        showFgSnack(
          context,
          'Export fehlgeschlagen: $e',
          isError: true,
        );
      }
    }
  }

  /// Welle-8 Round 20: Import eines zuvor exportierten Spielstands.
  /// Warnt User dass aktueller Stand überschrieben wird + App neu
  /// gestartet werden muss.
  Future<void> _confirmImport() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text(
          '📥 Spielstand laden?',
          style: FgTypography.bodyL,
        ),
        content: const Text(
          'Dein aktueller Spielstand wird durch die geladene Datei '
          'ersetzt!\n\n'
          'Nach dem Import musst du die App schließen + neu öffnen, '
          'damit alles richtig geladen wird.\n\n'
          'Wähle danach eine .fgsave-Datei aus.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Ja, ersetzen',
              style: FgTypography.bodyM.copyWith(color: FgColors.alert),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final result = await SaveExportService.instance.importFromFilePicker(
      live: ref.read(appDatabaseProvider),
    );
    if (!mounted) return;
    if (result.success) {
      // App SOFORT schließen statt nur bitten: die noch offene DB-Verbindung
      // aus main.dart hält die gerade überschriebene Datei + einen Seiten-
      // Cache. Spielt der User weiter ohne Neustart, kann ein späterer
      // Schreibvorgang veraltete Cache-Seiten über den frischen Import
      // schreiben. Erzwungenes Beenden schließt dieses Fenster.
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: FgColors.backgroundElevated,
          title: const Text('✓ Spielstand geladen', style: FgTypography.bodyL),
          content: const Text(
            'Die App wird jetzt geschlossen. Öffne sie neu — dann ist dein '
            'geladener Spielstand da.',
            style: FgTypography.bodyM,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('App schließen', style: FgTypography.bodyM),
            ),
          ],
        ),
      );
      await SystemNavigator.pop();
    } else if (result.error != null) {
      showFgSnack(context, result.error!, isError: true);
    }
  }

  Future<void> _confirmReset() async {
    // PIN-Gate bereits auf gesamte Settings-Page → kein 2. Verifier nötig.
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text(
          '⚠ Wirklich neu starten?',
          style: FgTypography.bodyL,
        ),
        content: const Text(
          'ALLE gespeicherten Daten werden gelöscht:\n'
          '• Cash, Spar, Investments\n'
          '• Pflanzen, Wunschartikel, Trophäen\n'
          '• Quests, XP, Level\n'
          '• Möbel, Einstellungen\n\n'
          'Das kann NICHT rückgängig gemacht werden!\n'
          'Danach beginnt das Spiel von vorn mit dem Onboarding.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Ja, alles löschen',
              style: FgTypography.bodyM.copyWith(color: FgColors.alert),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final db = ref.read(appDatabaseProvider);
    await db.wipeAll();
    // v29: auch aktuellen Highscore-Run-State zurücksetzen
    // (firstMillionaireDayIndex). Die Lifetime-Entries bleiben.
    try {
      await ref
          .read(highscoreRepositoryProvider.notifier)
          .clearCurrentRun();
    } on Object {/* ignore — kein Highscore-File OK */}
    if (!mounted) return;
    showFgSnack(
      context,
      '✓ Spiel zurückgesetzt. Bitte App neu starten für sauberen Neustart.',
      duration: const Duration(seconds: 10),
    );
  }
}

/// Welle-8 Round 23: Eltern-PIN Setzer + Status.
class _ParentPinSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pin = ref.watch(
      settingsRepositoryProvider.select((s) => s.parentPin),
    );
    final active = pin.isNotEmpty;
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            active ? '🔒 PIN aktiv' : '🔓 Kein PIN gesetzt',
            style: FgTypography.bodyM.copyWith(
              color: active ? FgColors.success : FgColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: FgSpacing.xs),
          const Text(
            'Schützt Spielstand-Reset, Import + Auto-Save-Erzwingen.\n'
            'Erst nach PIN-Eingabe ausführbar. 4-stellig.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: active ? '🔁 PIN ändern' : '➕ PIN setzen',
            background: FgColors.info,
            foreground: FgColors.onSurface,
            onPressed: () => _editPin(context, ref, hasOld: active),
          ),
          if (active) ...[
            const SizedBox(height: FgSpacing.xs),
            PixelButton(
              label: '🗑 PIN entfernen',
              background: FgColors.alert,
              foreground: FgColors.onSurface,
              onPressed: () => _removePin(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editPin(
    BuildContext context,
    WidgetRef ref, {
    required bool hasOld,
  }) async {
    final repo = ref.read(settingsRepositoryProvider.notifier);
    if (hasOld) {
      final entered = await _ask(context, 'Alten PIN eingeben');
      if (entered == null || !repo.parentPinMatches(entered)) {
        if (context.mounted) {
          showFgSnack(context, 'Falscher PIN.', isError: true);
        }
        return;
      }
    }
    if (!context.mounted) return;
    final newPin = await _ask(context, 'Neuen PIN eingeben (4 Ziffern)');
    if (newPin == null || newPin.length != 4) {
      if (context.mounted) {
        showFgSnack(context, 'PIN muss 4 Ziffern haben.', isError: true);
      }
      return;
    }
    if (!context.mounted) return;
    final repeat = await _ask(context, 'PIN wiederholen');
    if (repeat != newPin) {
      if (context.mounted) {
        showFgSnack(context, 'PINs stimmen nicht überein.', isError: true);
      }
      return;
    }
    repo.setParentPin(newPin);
    if (context.mounted) {
      showFgSnack(context, '✓ PIN gesetzt.');
    }
  }

  Future<void> _removePin(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(settingsRepositoryProvider.notifier);
    final entered = await _ask(context, 'PIN eingeben zum Entfernen');
    if (entered == null || !repo.parentPinMatches(entered)) {
      if (context.mounted) {
        showFgSnack(context, 'Falscher PIN.', isError: true);
      }
      return;
    }
    repo.setParentPin('');
    if (context.mounted) {
      showFgSnack(context, '✓ PIN entfernt.');
    }
  }

  Future<String?> _ask(BuildContext context, String title) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text(title, style: FgTypography.bodyL),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '4-stelliger PIN',
            counterText: '',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ctrl.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Welle-8 Round 24 (#10): Eltern tragen echte Erfolge ein. Erscheinen in
/// der Zimmer-Trophäenwand. Reine Eltern-kuratierte Liste.
/// Freiwilliger Unterstützungs-Link für Eltern. Öffnet die URL im externen
/// Browser. Nur sichtbar wenn [kDonationUrl] gesetzt ist.
///
/// **Wortwahl (2026-08):** hier steht bewusst NIRGENDS „Spende". Eine Spende
/// im steuerlichen Sinn geht an eine gemeinnützige Organisation und ist
/// abzugsfähig — Geld, das bei einer Privatperson landet, ist schlicht eine
/// Einnahme. Der Begriff wäre also irreführend, und ausgerechnet in einer
/// App, die Finanzbegriffe richtig beibringen soll, ist das keine
/// Kleinigkeit. „Trinkgeld" trifft es: freiwillig, ohne Gegenleistung,
/// niemand erwartet es.
///
/// Ebenso bewusst: es gibt KEINE Gegenleistung — kein Abzeichen, kein
/// Freischalten, kein Dankeschön im Spiel. Sobald es die gäbe, wäre es ein
/// Kauf digitaler Inhalte statt einer freiwilligen Zuwendung.
class _SupportSection extends ConsumerWidget {
  const _SupportSection();

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    // Elternschranke VOR dem Verlassen der App. Die Sichtbarkeitsregel oben
    // filtert schon nach Alter — aber die Altersangabe kann falsch sein, und
    // ein Weg zu einem Zahlungsanbieter darf nicht an einer einzigen
    // Zahleneingabe hängen.
    final passed = await showParentMathGate(
      context,
      ref,
      purpose: 'Danach öffnet sich PayPal im Browser.',
    );
    if (!passed || !context.mounted) return;

    final uri = Uri.tryParse(kDonationUrl);
    if (uri == null) return;
    // Externer Browser, NIE ein eigenes WebView: eine Zahlung in einem
    // In-App-WebView wertet Google als Umgehung von Play Billing.
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      showFgSnack(context, 'Link konnte nicht geöffnet werden.',
          isError: true);
    }
  }

  Future<void> _mail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: kContactEmail,
      queryParameters: const {'subject': 'Erstattung Unterstützung'},
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (ok || !context.mounted) return;
    // Kein Mail-Programm installiert → Adresse kopierbar anbieten statt
    // kommentarlos nichts zu tun.
    await Clipboard.setData(ClipboardData(text: kContactEmail));
    if (context.mounted) {
      showFgSnack(context, 'Adresse kopiert: $kContactEmail');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dieses Spiel ist kostenlos, ohne Werbung und ohne '
            'In-App-Käufe.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.xs),
          // Dieser Satz ist die Grundlage dafür, dass hier kein Play Billing
          // vorgeschrieben ist: freiwillige Zuwendung, keine Gegenleistung.
          // Sobald irgendetwas dafür freigeschaltet würde — und sei es ein
          // Danke-Abzeichen — wäre es ein Kauf digitaler Inhalte.
          const Text(
            'Wenn es gefällt, kann man die Weiterentwicklung freiwillig '
            'unterstützen — wie ein Trinkgeld. Ohne Gegenleistung: es '
            'schaltet nichts frei und ändert nichts im Spiel. Läuft über '
            'PayPal.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: '💛 Trinkgeld per PayPal',
            background: FgColors.secondary,
            foreground: FgColors.onPrimary,
            onPressed: () => _open(context, ref),
          ),
          // Fängt den Fall ab, den keine Schranke verhindern kann: ein Kind,
          // das die Altersfrage falsch beantwortet UND die Rechenaufgabe
          // löst. Steht bewusst offen da — nicht aufklappbar, nicht hinter
          // der Schranke. Ohne hinterlegte Adresse entfällt sie (siehe
          // [kContactEmail]) — vor einem Store-Release also eintragen.
          if (kContactEmail.isNotEmpty) ...[
            const SizedBox(height: FgSpacing.s),
            const Text(
              'Versehentlich gezahlt? Zum Beispiel, weil ein Kind das Gerät '
              'benutzt hat? Schreib mir kurz — ich erstatte das '
              'unbürokratisch und ohne Nachfragen zurück.',
              style: FgTypography.bodyS,
            ),
            const SizedBox(height: FgSpacing.xs),
            InkWell(
              onTap: () => _mail(context),
              child: Text(
                kContactEmail,
                style: FgTypography.bodyS.copyWith(
                  color: FgColors.info,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Geburtsjahr korrigieren. **Immer sichtbar**, in jedem Altersstatus — sonst
/// könnte sich ein fälschlich als minderjährig eingestufter Erwachsener nie
/// korrigieren, und ein übersprungener Dialog wäre eine Sackgasse.
///
/// Die Änderung selbst steckt hinter der Eltern-Rechenaufgabe: ohne die wäre
/// die ganze Konstruktion mit zwei Tipps in den Einstellungen ausgehebelt.
class _BirthYearSection extends ConsumerWidget {
  const _BirthYearSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthYear =
        ref.watch(settingsRepositoryProvider.select((s) => s.birthYear));
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Geburtsjahr', style: FgTypography.bodyS),
          const SizedBox(height: FgSpacing.xs),
          Text(
            birthYear == null
                ? 'Keine Angabe. Bleibt auf diesem Gerät, wird nicht '
                    'verschickt.'
                : 'Angegeben: $birthYear. Bleibt auf diesem Gerät, wird '
                    'nicht verschickt.',
            style: FgTypography.bodyS,
          ),
          const SizedBox(height: FgSpacing.s),
          PixelButton(
            label: 'Ändern',
            background: FgColors.info,
            foreground: FgColors.onPrimary,
            onPressed: () async {
              final passed = await showParentMathGate(
                context,
                ref,
                purpose: 'Das Geburtsjahr lässt sich nur von einem '
                    'Erwachsenen ändern.',
              );
              if (!passed || !context.mounted) return;
              await showBirthYearPrompt(context, ref);
            },
          ),
        ],
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  const _VersionRow();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (ctx, snap) {
        final v = snap.data;
        final text = v == null
            ? "Version laed..."
            : "Version ${v.version}+${v.buildNumber}";
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: FgSpacing.s),
          child: Text(text, style: FgTypography.bodyS),
        );
      },
    );
  }
}
