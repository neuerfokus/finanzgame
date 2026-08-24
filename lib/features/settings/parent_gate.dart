import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_tokens.dart';
import '../../ui/widgets/fg_snack.dart';
import 'settings_repository.dart';

/// Eltern-Freigabe für Belohnungen aus der „Echtes Leben"-Brücke.
///
/// Vorher galt: kein PIN gesetzt → gar keine Prüfung. Damit konnte das Kind
/// „🔒 Eltern bestätigen → Belohnung" selbst drücken und sich XP (bis 600 beim
/// Sparziel, 150 pro echtem Erfolg) samt Trophäe geben — beliebig oft, und mit
/// dem Meister-Bonus verdoppelt. Als XP-Quelle auf Knopfdruck untergrub das
/// das ganze Level-System.
///
/// Jetzt ist ein gesetzter PIN Voraussetzung für die BELOHNUNG. Ziele anlegen
/// und Fortschritt eintragen bleiben absichtlich offen — das ist die
/// Vertrauens-Mechanik. Fehlt ein PIN, führt der Weg direkt ins Einrichten
/// statt in eine Sackgasse.
///
/// Ehrlich bleibt: 100 % dicht wird das nie, das Kind hat das Gerät in der
/// Hand und könnte den PIN selbst setzen. Der PIN ist Reibung und ein
/// bewusster Eltern-Akt, keine Sicherheitsmaßnahme.
class ParentGate {
  const ParentGate._();

  /// True = freigegeben. Fragt den PIN ab, oder bietet an, einen einzurichten.
  static Future<bool> require(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(settingsRepositoryProvider.notifier);
    final hasPin = ref.read(settingsRepositoryProvider).parentPin.isNotEmpty;

    if (!hasPin) {
      final created = await _offerSetup(context, repo);
      return created;
    }

    final entered = await _promptPin(context, '🔒 Eltern-PIN');
    if (entered == null) return false;
    if (!repo.parentPinMatches(entered)) {
      if (context.mounted) {
        showFgSnack(context, 'Falscher Eltern-PIN.', isError: true);
      }
      return false;
    }
    return true;
  }

  /// Kein PIN vorhanden: erklären, warum es einen braucht, und ihn gleich
  /// setzen lassen. Liefert true, wenn danach ein PIN steht.
  static Future<bool> _offerSetup(
    BuildContext context,
    SettingsRepository repo,
  ) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('Eltern-PIN einrichten',
            style: FgTypography.bodyL),
        content: const Text(
          'Diese Belohnung sollen deine Eltern bestätigen — dafür braucht es '
          'einmal einen Eltern-PIN.\n\n'
          'Eltern: kurz einen vierstelligen PIN festlegen. Danach reicht er '
          'für alle künftigen Bestätigungen.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Später', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('PIN festlegen', style: FgTypography.bodyM),
          ),
        ],
      ),
    );
    if (yes != true || !context.mounted) return false;

    final first = await _promptPin(context, 'Neuen PIN festlegen');
    if (first == null || first.length != 4) {
      if (context.mounted) {
        showFgSnack(context, 'PIN muss 4 Ziffern haben.', isError: true);
      }
      return false;
    }
    if (!context.mounted) return false;
    final repeat = await _promptPin(context, 'PIN wiederholen');
    if (repeat != first) {
      if (context.mounted) {
        showFgSnack(context, 'PINs stimmen nicht überein.', isError: true);
      }
      return false;
    }
    repo.setParentPin(first);
    if (context.mounted) showFgSnack(context, '✓ Eltern-PIN gesetzt.');
    return true;
  }

  static Future<String?> _promptPin(BuildContext context, String title) {
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
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Eltern-PIN',
            hintText: '4-stelliger PIN',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen', style: FgTypography.bodyM),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
            child: const Text('Ok', style: FgTypography.bodyM),
          ),
        ],
      ),
    );
  }
}
