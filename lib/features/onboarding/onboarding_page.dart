import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../domain/economy/money.dart';
import '../../ui/widgets/pixel_button.dart';
import '../../ui/widgets/pixel_panel.dart';
import '../economy/cash_state.dart';
import '../newgame/new_game_state.dart';
import '../settings/save_export_service.dart';
import '../settings/settings_repository.dart';
import '../xp/xp_repository.dart';

/// Spec-34: first-run onboarding wizard. Three steps — name, monthly
/// allowance, avatar pick — followed by [SettingsRepository.setOnboardingComplete].
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  int _step = 0;
  final _nameCtrl = TextEditingController(text: 'Spieler');
  final _ageCtrl = TextEditingController(text: '13');
  final _allowanceCtrl = TextEditingController(text: '80');
  String _avatar = '🧒';

  // Spec-38 follow-up: visually distinct emojis. Samsung One UI rendert
  // 🧒/👦/🧑/🧑‍🎓 fast identisch (Junge braun) — daher Charakter-Glyphs, die
  // garantiert unterschiedlich aussehen.
  //
  // 2026-08: die weiblichen Figuren sind dazugekommen. Hier stand vorher
  // ausdrücklich „kein 👧" — die Begründung war die alte CLAUDE.md-Regel
  // „default männlich/neutral". Der Default bleibt 🧒 (neutral), aber ein
  // Mädchen soll beim allerersten Schritt der App eine Figur finden, die wie
  // sie aussieht. Die Auswahl ist gleichwertig, nicht nachrangig.
  static const _avatarChoices = [
    '🧒', '👱', '👱‍♀️', '👦', '👧', '🦸', '🦸‍♀️', '🧙', '🧙‍♀️',
    '🥷', '🤖', '👾', '🐱', '🦊', '🐼', '🐧', '🐸', '🐯',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _allowanceCtrl.dispose();
    super.dispose();
  }

  /// L8 (Analyse 2026-08): `_finish` lief per `unawaited` ohne Sperre. Zwei
  /// Taps im selben Frame auf „Los geht's!" starteten es zweimal, und die
  /// Start-Boni werden vor dem ersten `await` gebucht — also doppelt. Betrifft
  /// nur NewGame+-Runs mit gekauften Vermächtnis-Upgrades (die Erbschaft
  /// selbst ist über `consumePending()` schon geschützt), aber Startgeld und
  /// Start-XP hingen ungesichert daran.
  bool _finishing = false;

  void _next() {
    if (_step < 2) {
      setState(() => _step += 1);
      return;
    }
    if (_finishing) return;
    _finishing = true;
    unawaited(_finish());
  }

  Future<void> _finish() async {
    final notifier = ref.read(settingsRepositoryProvider.notifier);
    final name = _nameCtrl.text.trim();
    if (name.isNotEmpty) notifier.setPlayerName(name);
    final age = int.tryParse(_ageCtrl.text.trim());
    if (age != null) notifier.setStartAgeYears(age);
    final euros = int.tryParse(_allowanceCtrl.text.trim());
    if (euros != null && euros >= 0) {
      notifier.setAllowance(Money.cents(euros * 100));
    }
    notifier.setAvatarEmoji(_avatar);
    notifier.setOnboardingComplete(true);
    // Spec-45 G3: NewGame+ Boni einbuchen wenn pending.
    final ng = ref.read(newGameStateProvider.notifier).consumePending();
    if (ng.inheritanceCents > 0) {
      ref
          .read(cashStateProvider.notifier)
          .earn(Money.cents(ng.inheritanceCents));
    }
    if (ng.bonusXp > 0) {
      ref.read(xpRepositoryProvider.notifier).add(ng.bonusXp);
    }
    // Welle B: permanente Vermächtnis-Start-Boni (jeder Run, nicht
    // verbraucht — abhängig nur von gekauften Legacy-Upgrades).
    final legacy = ref.read(newGameStateProvider);
    if (legacy.legacyStartCashAmount > 0) {
      ref
          .read(cashStateProvider.notifier)
          .earn(Money.cents(legacy.legacyStartCashAmount));
    }
    if (legacy.legacyStartXpAmount > 0) {
      ref.read(xpRepositoryProvider.notifier).add(legacy.legacyStartXpAmount);
    }
    // Auto-Sicherung ist standardmäßig AN — am Ende des Onboardings einmal
    // die nötige Speicher-Berechtigung anbieten, damit der Spielstand auch
    // einen Deinstall überlebt. Kein Zwang (kann später aus).
    await _offerAutoSaveSetup();
    widget.onDone();
  }

  /// Bietet am Onboarding-Ende an, einen Backup-Ordner zu wählen (SAF). Der
  /// Spielstand wird dann dorthin gesichert — überlebt Deinstall, ohne die
  /// heikle „Zugriff auf alle Dateien"-Berechtigung. Später in Einstellungen
  /// nachholbar.
  Future<void> _offerAutoSaveSetup() async {
    if (!Platform.isAndroid) return;
    if (!mounted) return;
    final enable = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Spielstand sichern?'),
        content: const Text(
          // Android 11+ lässt den Downloads-ORDNER selbst nicht auswählen
          // („Diesen Ordner verwenden" ist ausgegraut) — deshalb explizit
          // nach einem Unterordner fragen, sonst bricht das Kind hier ab
          // und es wird nie eine Sicherung geschrieben.
          'Dein Spiel kann sich automatisch in einen Ordner sichern — dann '
          'bleibt es auch nach einer Neu-Installation erhalten.\n\n'
          'Gleich öffnet sich die Ordner-Auswahl: Erstelle dort in '
          '„Downloads" einen neuen Ordner (z. B. „Finanzgame") und wähle '
          'diesen aus. „Downloads" selbst lässt Android nicht auswählen.\n\n'
          'Später in den Einstellungen änderbar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Später'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ordner wählen'),
          ),
        ],
      ),
    );
    if (enable != true) return;
    final svc = SaveExportService.instance;
    final uri = await svc.pickBackupFolder();
    if (uri == null) return; // abgebrochen
    ref.read(settingsRepositoryProvider.notifier).setBackupFolderUri(uri);
    await svc.writeAutoSave(safFolderUri: uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FgColors.backgroundDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FgSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Willkommen bei Finanzgame!',
                style: FgTypography.display.copyWith(fontSize: 26),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FgSpacing.s),
              Text(
                'Schritt ${_step + 1} von 3',
                style: FgTypography.bodyS,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FgSpacing.l),
              Expanded(child: _body()),
              const SizedBox(height: FgSpacing.l),
              PixelButton(
                label: _step < 2 ? 'Weiter →' : 'Los geht\'s!',
                background: FgColors.primary,
                foreground: FgColors.onPrimary,
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    switch (_step) {
      case 0:
        return PixelPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Wie heißt du?', style: FgTypography.bodyL),
              const SizedBox(height: FgSpacing.s),
              TextField(
                controller: _nameCtrl,
                style: FgTypography.bodyM,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: FgSpacing.m),
              const Text('Wie alt bist du?', style: FgTypography.bodyL),
              const SizedBox(height: FgSpacing.s),
              TextField(
                controller: _ageCtrl,
                style: FgTypography.bodyM,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  suffixText: 'Jahre',
                ),
              ),
            ],
          ),
        );
      case 1:
        return PixelPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wie viel Taschengeld bekommst du pro Monat?',
                style: FgTypography.bodyL,
              ),
              const SizedBox(height: FgSpacing.s),
              TextField(
                controller: _allowanceCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: FgTypography.bodyM,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  suffixText: '€  (max 80)',
                ),
              ),
              const SizedBox(height: FgSpacing.s),
              const Text(
                'Gibt\'s am 1. Spieltag im Monat. Mehr als 80 € wird '
                'gedeckelt.',
                style: FgTypography.bodyS,
              ),
            ],
          ),
        );
      case 2:
        return PixelPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Wähle deinen Avatar', style: FgTypography.bodyL),
              const SizedBox(height: FgSpacing.s),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: FgSpacing.s,
                  crossAxisSpacing: FgSpacing.s,
                  children: [
                    for (final emoji in _avatarChoices)
                      GestureDetector(
                        onTap: () => setState(() => _avatar = emoji),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _avatar == emoji
                                ? FgColors.primary
                                : FgColors.backgroundPrimary,
                            border: Border.all(
                              color: _avatar == emoji
                                  ? FgColors.primary
                                  : FgColors.outline,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 36)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
