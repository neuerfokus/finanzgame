import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/design_tokens.dart';

/// Gemeinsame Fehleranzeige für alle Import-/Wiederherstellungs-Wege.
///
/// Der Grund für den zweiten Fall: `_applySaveFile` schließt kurz vor dem
/// Ersetzen die Live-Verbindung zur Datenbank. Geht danach noch etwas schief,
/// ist die Verbindung tot — und **jede** weitere Schreiboperation der App
/// läuft in die `catchError`-Handler der Repositories und verschwindet
/// lautlos. Die App sähe völlig normal aus und würde nichts mehr speichern.
/// In diesem Fall ist ein Neustart keine Empfehlung, sondern Pflicht; der
/// Spielstand auf der Platte ist intakt (`.bak` liegt daneben).
Future<void> showImportFailure(
  BuildContext context, {
  required String? error,
  required bool dbClosed,
  String titel = 'Laden fehlgeschlagen',
}) async {
  if (!dbClosed) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: Text(titel, style: FgTypography.bodyL),
        content: Text(
          error ?? 'Die Datei konnte nicht gelesen werden.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Ok', style: FgTypography.bodyM),
          ),
        ],
      ),
    );
    return;
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: FgColors.backgroundElevated,
        title: const Text('Laden abgebrochen', style: FgTypography.bodyL),
        content: Text(
          '${error ?? 'Der Spielstand konnte nicht eingespielt werden.'}\n\n'
          'Dein bisheriger Spielstand ist unversehrt. Die App muss jetzt '
          'geschlossen werden — sonst würde ab hier nichts mehr gespeichert.',
          style: FgTypography.bodyM,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('App schließen', style: FgTypography.bodyM),
          ),
        ],
      ),
    ),
  );
  await SystemNavigator.pop();
}
