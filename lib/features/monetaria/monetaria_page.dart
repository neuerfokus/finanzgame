import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../game/monetaria/monetaria_world.dart';
import '../../game/monetaria/state/monetaria_state.dart';
import '../../game/monetaria/state/monetaria_unlocker.dart';
import '../../ui/widgets/fg_snack.dart';
import '../../ui/widgets/phone_frame.dart';
import '../settings/settings_repository.dart';
import 'island_page.dart';

/// Monetaria hub host page: embeds the Flame [MonetariaWorld] inside the
/// pixel [PhoneFrame] chrome.
class MonetariaPage extends ConsumerStatefulWidget {
  const MonetariaPage({super.key});

  @override
  ConsumerState<MonetariaPage> createState() => _MonetariaPageState();
}

class _MonetariaPageState extends ConsumerState<MonetariaPage> {
  MonetariaWorld? _game;

  /// L10 (Analyse 2026-08): mit welchem Freischalt-Stand die Flame-Welt
  /// gebaut wurde. Die Marker lesen `unlocked` EINMAL beim Erzeugen; das
  /// `_game ??=` hielt die Welt danach für immer fest. Eine Insel, die
  /// freigeschaltet wird, während die Karte offen ist, blieb also optisch
  /// gesperrt, bis man die Karte verließ und neu öffnete. Bisher unsichtbar,
  /// weil Freischaltungen nur außerhalb der Karte passieren (Quest, Quiz,
  /// Schlafen) — aber genau das ändert sich, sobald irgendwas auf der Karte
  /// XP gibt.
  Set<String>? _builtWith;

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(monetariaStateProvider);
    if (_game == null || !setEquals(_builtWith, unlocked)) {
      _game = MonetariaWorld(
        unlockedIslandIds: unlocked,
        onIslandSelected: _openIsland,
        onIslandLockedTap: _showLockHint,
      );
      _builtWith = {...unlocked};
    }

    return PhoneFrame(
      appName: 'Monetaria',
      onBack: () => Navigator.of(context).pop(),
      child: GameWidget(game: _game!),
    );
  }

  /// Coach-ID für die einmalige Käpt'n-Begrüßung im Heimathafen.
  static const _heimathafenGreetingId = 'heimathafen_greeting';

  void _openIsland(String islandId) {
    if (!mounted) return;
    // Der Heimathafen ist der Weg NACH HAUSE — er springt direkt zum
    // Springboard statt über eine Zwischenseite.
    //
    // Die alte HeimathafenPage stammt aus spec-15, als sie noch der Hub war.
    // Heute sind drei ihrer vier Elemente Doppelungen: die Spar-Insel hat
    // einen eigenen Marker direkt daneben, die Quests ein Springboard-Icon
    // mit Badge, und die Insel-Erklärungen macht der First-Steps-Coach pro
    // Insel (die Gesamtliste steht jetzt im Glossar). Übrig blieb nur
    // „Zurück zum Hauptmenü" — also genau das, was der Name verspricht,
    // vorher aber zwei Taps kostete.
    if (islandId == IslandId.heimathafen) {
      final settings = ref.read(settingsRepositoryProvider.notifier);
      if (!settings.hasSeenCoach(_heimathafenGreetingId)) {
        settings.markCoachSeen(_heimathafenGreetingId);
        _showGreetingThenHome();
        return;
      }
      Navigator.of(context).popUntil((r) => r.isFirst);
      return;
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => IslandPage(islandId: islandId),
      ),
    );
  }

  /// Beim allerersten Anlegen einmal die Begrüßung zeigen — neue Spieler
  /// (und NewGame+-Runs) sollen die Orientierung nicht verlieren.
  Future<void> _showGreetingThenHome() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text("Käpt'n Knut", style: FgTypography.bodyL),
        // Der Text wird EINMAL gezeigt und schickt danach direkt ins
        // Hauptmenü. Die alte Fassung begrüßte einen im Hafen („Willkommen!
        // Von hier aus segelst du zu allen Inseln") und warf einen im selben
        // Moment raus — sie beschrieb also etwas anderes, als gleich passiert.
        // Jetzt sagt Knut zuerst, wofür der Hafen da ist, und verabschiedet
        // sich passend zum Sprung.
        content: const Text(
          'Moin! Ich bin Knut und halte hier die Stellung.\n\n'
          'Der Heimathafen ist dein Weg nach Hause: einmal antippen, und du '
          'bist zurück im Hauptmenü.\n\n'
          'Die Inseln drumherum erreichst du direkt von der Karte. Ist eine '
          'noch verschlossen, erfährst du beim Antippen, was dir dafür '
          'fehlt.\n\n'
          'Und jetzt — gute Fahrt!',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Aye, Käpt\'n!', style: FgTypography.bodyM),
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void _showLockHint(String islandId) {
    if (!mounted) return;
    final criterion = MonetariaUnlocker.criterionFor(islandId);
    showFgSnack(
      context,
      criterion ?? 'Diese Insel ist noch verschlossen.',
      duration: const Duration(seconds: 5),
    );
  }
}
