import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'core/design_tokens.dart';
import 'data/db/app_database.dart';
import 'data/db/app_database_provider.dart';
import 'features/audio/sound_service.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/phone_ui/springboard_page.dart';
import 'features/settings/birth_year_prompt.dart';
import 'features/settings/import_intent_channel.dart';
import 'features/settings/import_failure_dialog.dart';
import 'features/settings/parent_gate.dart';
import 'features/settings/save_export_service.dart';
import 'features/settings/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SoundService.use(AudioplayersSoundService());

  // Pre-warm: open the production DB once and load every table into a
  // [DbSnapshot] so the first widget frame already has all repos populated.
  //
  // CRASH-GUARD: ist die DB-Datei beschädigt/abgeschnitten ODER wirft eine
  // Migration, würde `runApp` ohne diesen try/catch NIE laufen → die App
  // hinge für immer auf dem nativen Splash (Baum-Icon), bis zum Reinstall.
  // Stattdessen: kaputte DB beiseitelegen (`.corrupt.bak`), mit frischer DB
  // starten + einen Recovery-Hinweis zeigen (mit Verweis auf Import).
  AppDatabase? db;
  DbSnapshot? snapshot;
  var recoveredCorrupt = false;
  try {
    db = await openProductionDatabase();
    snapshot = await loadDbSnapshot(db);
  } catch (_) {
    try {
      await db?.close();
    } catch (_) {/* egal — die Datei wird gleich entfernt */}
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'finanzgame.sqlite'));
      recoveredCorrupt = await SaveExportService.quarantineCorruptDb(file);
    } catch (_) {/* silent */}
    // Frische, leere DB — auf einem beschreibbaren App-Pfad praktisch
    // garantiert lesbar; landet im Onboarding (+ ggf. Restore-Angebot).
    // Zweite Ebene: schlägt AUCH das fehl (Quarantäne unmöglich, Speicher
    // voll, Dateisystem read-only), darf `runApp` trotzdem nicht ausfallen —
    // sonst genau der unsichtbare Brick auf dem nativen Splash, den dieser
    // Guard verhindern soll. Dann eben ein lesbarer Fehlerscreen.
    try {
      db = await openProductionDatabase();
      snapshot = await loadDbSnapshot(db);
    } catch (e) {
      runApp(_FatalDbErrorApp(details: '$e'));
      return;
    }
  }

  // Spec-23: respect persisted music volume before starting playback so
  // the loop never blasts at default volume between snapshot load + first
  // user interaction.
  // spec-37: Musik komplett entfernt (Test-Feedback: nervig). Nur SFX
  // bleiben — Coin/Harvest/Sleep/Crash/UI-Tap.
  SoundService.instance.setMusicVolume(0);

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      dbSnapshotProvider.overrideWithValue(snapshot),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: FinanzgameApp(recoveredCorrupt: recoveredCorrupt),
    ),
  );
}

/// Letzte Rettung: die Spielstand-Datenbank lässt sich weder öffnen noch
/// ersetzen. Statt schwarzem Bildschirm ein Hinweis, was zu tun ist.
class _FatalDbErrorApp extends StatelessWidget {
  const _FatalDbErrorApp({required this.details});

  final String details;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: FgColors.backgroundDeep,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('😵', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                const Text(
                  'Die Spielstand-Datei lässt sich nicht öffnen.',
                  textAlign: TextAlign.center,
                  style: FgTypography.bodyL,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bitte prüfe, ob auf dem Handy noch Speicher frei ist. '
                  'Hilft das nicht: App neu installieren und den Spielstand '
                  'über „Importieren" aus der Sicherung zurückholen.',
                  textAlign: TextAlign.center,
                  style: FgTypography.bodyS,
                ),
                const SizedBox(height: 16),
                Text(
                  details,
                  textAlign: TextAlign.center,
                  style: FgTypography.bodyS
                      .copyWith(color: FgColors.onSurfaceMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FinanzgameApp extends ConsumerWidget {
  const FinanzgameApp({this.recoveredCorrupt = false, super.key});

  /// Beim Start war die DB beschädigt → wir haben neu begonnen. Zeigt einen
  /// einmaligen Recovery-Hinweis (mit Import-Empfehlung).
  final bool recoveredCorrupt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Finanzgame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: FgColors.backgroundDeep,
        colorScheme: const ColorScheme.dark(
          primary: FgColors.primary,
          secondary: FgColors.secondary,
          surface: FgColors.backgroundElevated,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: FgTypography.pixelFamily,
              bodyColor: FgColors.onSurface,
              displayColor: FgColors.onSurface,
            ),
      ),
      // spec-34: show onboarding wizard on first run.
      //
      // Kein Resume-Catchup mehr (2026-08-11): der spulte beim Zurückkommen
      // 1 Spieltag pro echter Stunde vor (Cap 7). Raus, weil er (a) fürs
      // NICHT-Spielen belohnte — jede andere Fortschrittsquelle hängt an
      // einer Lernhandlung, (b) über den Krisen-Wurf in fastForward stumm
      // Vermögen vernichten konnte, und (c) genau dadurch Verlustangst als
      // Bindungsmechanik aufbaute („ich muss rein, sonst verliere ich Geld").
      // Das ist die Sorte Druck, die dieses Projekt ausdrücklich nicht will.
      // Tage vergehen jetzt ausschließlich durch Schlafen oder Zeitsprung.
      home: _RootSwitcher(recoveredCorrupt: recoveredCorrupt),
    );
  }
}

class _RootSwitcher extends ConsumerStatefulWidget {
  const _RootSwitcher({this.recoveredCorrupt = false});

  final bool recoveredCorrupt;

  @override
  ConsumerState<_RootSwitcher> createState() => _RootSwitcherState();
}

class _RootSwitcherState extends ConsumerState<_RootSwitcher> {
  bool _checkedRestore = false;
  bool _bootHandled = false;
  bool _askedBirthYear = false;

  @override
  void initState() {
    super.initState();
    // Datei-Öffnen-Intent (WhatsApp → "Öffnen"), während die App läuft.
    ImportIntentChannel.setHandler(_handleIncomingImport);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runBootFlow());
  }

  /// Einmaliger Boot-Ablauf nach dem ersten Frame, in fester Reihenfolge,
  /// damit nie mehrere Dialoge gleichzeitig aufpoppen:
  /// 1. Recovery-Hinweis (DB war beschädigt),
  /// 2. Datei-Öffnen-Intent (Kaltstart mit `.fgsave`),
  /// 3. Auto-Restore-Angebot aus Download/Finanzgame/.
  Future<void> _runBootFlow() async {
    if (_bootHandled) return;
    _bootHandled = true;

    if (widget.recoveredCorrupt && mounted) {
      await _showCorruptRecoveryNotice();
    }

    final initial = await ImportIntentChannel.getInitialImportFile();
    if (initial != null) {
      _checkedRestore = true; // Restore-Angebot unterdrücken (Import hat Vorrang)
      await _handleIncomingImport(initial);
      return;
    }

    // Auto-Restore-Angebot nur wenn (noch) kein Spielstand existiert —
    // also nach Deinstall+Reinstall ODER nach Corrupt-Recovery. Sequenziell
    // nach den obigen Schritten, damit nie zwei Dialoge stapeln.
    if (!_checkedRestore && mounted) {
      final done = ref.read(
        settingsRepositoryProvider.select((s) => s.onboardingComplete),
      );
      if (!done) {
        _checkedRestore = true;
        await _maybeOfferRestore();
        return;
      }
    }

    // 4. Geburtsjahr-Frage — erst wenn das Onboarding durch ist, damit sie
    //    sich nicht mit dessen Schritten stapelt.
    await _maybeAskBirthYear();
  }

  /// Fragt genau einmal pro Installation nach dem Geburtsjahr.
  ///
  /// Die Angabe steuert einzig, ob der Unterstützen-Bereich in den
  /// Einstellungen existiert — das Spiel läuft in jedem Fall vollständig,
  /// auch wenn die Frage übersprungen wird. Deshalb ist sie auch keine
  /// Bedingung für irgendetwas und blockiert nichts.
  Future<void> _maybeAskBirthYear() async {
    if (_askedBirthYear || !mounted) return;
    final s = ref.read(settingsRepositoryProvider);
    if (!s.onboardingComplete || s.birthYearAsked) return;
    _askedBirthYear = true;
    await showBirthYearPrompt(context, ref);
  }

  Future<void> _showCorruptRecoveryNotice() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Spielstand war beschädigt'),
        content: const Text(
          'Dein gespeicherter Spielstand konnte leider nicht geladen werden '
          'und war beschädigt. Damit die App wieder startet, haben wir neu '
          'begonnen.\n\n'
          'Falls du eine Sicherung (.fgsave) hast, kannst du sie laden: '
          'Einstellungen → "Spielstand importieren".\n\n'
          '(Die beschädigte Datei wurde als finanzgame.sqlite.corrupt.bak '
          'gesichert.)\n\n'
          'Tipp: Mit „🔧 Datei senden" kannst du die beschädigte Datei zur '
          'Analyse verschicken (z.B. an Papa per WhatsApp).',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final n = await SaveExportService.instance.shareDiagnostics();
              if (n == 0 && ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Keine Diagnose-Dateien gefunden.'),
                  ),
                );
              }
            },
            child: const Text('🔧 Datei senden'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final done = ref.watch(
      settingsRepositoryProvider.select((s) => s.onboardingComplete),
    );
    if (!done) {
      // Welle-8 Round 23: erstmaliger Start (kein Onboarding-Save) — das
      // Auto-Restore-Angebot (Download/Finanzgame/ + Download/) läuft
      // sequenziell in [_runBootFlow] (initState), damit es nie mit dem
      // Corrupt-Recovery- oder Datei-Öffnen-Dialog kollidiert.
      return OnboardingPage(onDone: () {
        // Triggers a rebuild via the watched onboardingComplete flag.
        // Danach die Geburtsjahr-Frage nachholen: beim allerersten Start lief
        // der Boot-Ablauf, als das Onboarding noch offen war.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _maybeAskBirthYear(),
        );
      });
    }
    return const SpringboardPage();
  }

  /// Spielt eine per Datei-Öffnen-Intent angekommene `.fgsave` ein
  /// (Bestätigung → Import → App schließen).
  Future<void> _handleIncomingImport(String path) async {
    if (!mounted) return;
    final yes = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Spielstand laden?'),
        content: const Text(
          'Du hast eine Spielstand-Datei geöffnet. Soll sie geladen werden?\n\n'
          'Achtung: Dein aktueller Spielstand wird dabei überschrieben. '
          'Danach schließt sich die App und du startest sie neu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ja, laden'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    // Der Import über den Dateimanager führte an der PIN-gesperrten
    // Einstellungsseite vorbei: ein mitgebrachter Spielstand bringt seine
    // eigene (womöglich leere) parentPin mit, sein eigenes Geburtsjahr und
    // beliebiges Vermögen. Ohne eingerichteten PIN bleibt der Weg offen —
    // er ist zugleich der Rettungsweg nach einem beschädigten Spielstand.
    if (!await ParentGate.verifyIfConfigured(context, ref)) return;
    if (!mounted) return;
    final res = await SaveExportService.instance.importFromPath(
      path,
      live: ref.read(appDatabaseProvider),
    );
    if (!mounted) return;
    if (!res.success) {
      await showImportFailure(
        context,
        error: res.error,
        dbClosed: res.dbClosed,
      );
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // PopScope: die App MUSS hier neu starten. Der Android-Back-Button
      // poppt sonst trotz barrierDismissible:false die Dialog-Route → das
      // Kind spielt auf der alten, noch offenen DB-Verbindung weiter, während
      // auf der Platte schon die importierte Datei liegt. Der nächste Persist
      // schreibt dann alte In-Memory-Werte in den frischen Spielstand
      // (Hybrid-Save) und das nächste Auto-Save zementiert ihn.
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Erfolgreich geladen'),
          content: const Text(
            'Schließe die App jetzt komplett und öffne sie wieder. '
            'Dann ist der geladene Spielstand da.',
          ),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('App schließen'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _maybeOfferRestore() async {
    final svc = SaveExportService.instance;
    // "Alles versuchen": scannt Download/Finanzgame/ + Download/ nach der
    // neuesten gültigen Sicherung (Auto-Save ODER manuell hinkopierter
    // Export), nicht nur die eine kanonische Auto-Save-Datei.
    final found = await svc.findAnyRestoreCandidate();
    if (!mounted) return;
    if (found == null) {
      // Nichts im Download-Ordner gefunden — auf Android 11+ der Normalfall,
      // seit MANAGE_EXTERNAL_STORAGE nicht mehr deklariert ist → SAF-
      // Ordnerwahl anbieten.
      await _offerSafRestore();
      return;
    }
    final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(found.modified);
    final fileName = found.file.uri.pathSegments.isNotEmpty
        ? found.file.uri.pathSegments.last
        : 'Sicherung';
    // 3 Antworten, weil dieser Fund NICHT zwingend der neueste ist: seit die
    // Sicherung bevorzugt in den SAF-Ordner geht, veraltet die Datei im
    // Download-Ordner. Ohne die dritte Option hätte das Kind hier einen
    // monatealten Stand bestätigt, obwohl im Backup-Ordner ein aktueller lag.
    final choice = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Alten Spielstand gefunden'),
        content: Text(
          'Wir haben eine Sicherung gefunden:\n'
          '„$fileName" vom $dateStr.\n\n'
          'Soll dieser Spielstand wiederhergestellt werden?\n\n'
          'Falls du früher einen eigenen Backup-Ordner gewählt hast, liegt '
          'dort vielleicht eine neuere Sicherung.\n\n'
          'Beim Wiederherstellen wird die App geschlossen. Du musst sie '
          'danach neu starten — dann ist dein alter Stand wieder da.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(0),
            child: const Text('Nein, neu anfangen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(2),
            child: const Text('📁 Backup-Ordner wählen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(1),
            child: const Text('Ja, wiederherstellen'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (choice == 2) {
      await _offerSafRestore();
      return;
    }
    if (choice != 1) return;
    final res = await svc.importFromPath(
      found.file.path,
      live: ref.read(appDatabaseProvider),
    );
    final ok = res.success;
    if (!mounted) return;
    if (!ok) {
      await showImportFailure(
        context,
        titel: 'Wiederherstellung fehlgeschlagen',
        error: res.error ??
            'Die Sicherung konnte nicht geladen werden. Du kannst sie '
            'später in Einstellungen → Importieren manuell auswählen.',
        dbClosed: res.dbClosed,
      );
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // PopScope: Neustart ist Pflicht — Back würde auf der alten
      // DB-Verbindung weiterspielen lassen (Hybrid-Save, siehe oben).
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Erfolgreich wiederhergestellt'),
          content: const Text(
            'Schließe die App jetzt komplett (aus dem App-Wechsler '
            'wischen) und öffne sie wieder. Dann ist dein alter '
            'Spielstand da.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('App schließen'),
            ),
          ],
        ),
      ),
    );
  }

  /// Restore über den SAF-Backup-Ordner: der Nutzer wählt den Ordner, in den
  /// er beim ersten Start gesichert hat, erneut aus — wir lesen die
  /// `autosave.fgsave` daraus. Greift nach Reinstall, wenn der Download-Scan
  /// nichts findet — auf Android 11+ also praktisch immer. Auch der Weg für
  /// Alt-Stände: wer früher nach `Download/Finanzgame/` gesichert hat, wählt
  /// hier genau diesen Ordner und bekommt seine Sicherung zurück.
  Future<void> _offerSafRestore() async {
    if (!mounted) return;
    final yes = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Alten Spielstand laden?'),
        content: const Text(
          'Falls du früher einen Backup-Ordner gewählt hast, kannst du ihn '
          'jetzt erneut auswählen, um deinen alten Spielstand zu laden.\n\n'
          'Wichtig: Wähle im Auswahl-Fenster den Unterordner, in dem die '
          'Sicherung liegt (z. B. in „Downloads" den Ordner „Finanzgame"). '
          'Den Ordner „Downloads" selbst lässt Android nicht auswählen.\n\n'
          'Wenn ja, wird die App danach geschlossen — beim nächsten Start '
          'ist dein alter Stand da.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Nein, neu anfangen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ordner wählen'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    final svc = SaveExportService.instance;
    final uri = await svc.pickBackupFolder();
    if (uri == null || !mounted) return;
    final res = await svc.restoreFromSafFolder(
      uri,
      live: ref.read(appDatabaseProvider),
    );
    if (!mounted) return;
    if (!res.success) {
      await showImportFailure(
        context,
        titel: 'Wiederherstellung fehlgeschlagen',
        error: res.error ?? 'Im gewählten Ordner wurde keine Sicherung gefunden.',
        dbClosed: res.dbClosed,
      );
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      // PopScope: Neustart ist Pflicht (Hybrid-Save-Schutz, siehe oben).
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Erfolgreich wiederhergestellt'),
          content: const Text(
            'Schließe die App jetzt komplett und öffne sie wieder. Dann ist '
            'dein alter Spielstand da.',
          ),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('App schließen'),
            ),
          ],
        ),
      ),
    );
  }
}
